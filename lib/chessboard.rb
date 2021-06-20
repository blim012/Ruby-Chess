require './lib/gen_pseudo_moves.rb'
require './lib/nonray_attack.rb'
require './lib/ray_attack.rb'
require './lib/searchable.rb'
require './lib/move.rb'

class Chessboard
  include Gen_Pseudo_Moves
  include Ray_Attack
  include Nonray_Attack
  include Searchable

  attr_accessor :piece_BB, :color_BB, :occupied_BB

  def initialize
    # initialize piece bitboards
    @piece_BB = {}
    @piece_BB[:pawn] = 0x000000000000FF00 | 0x00FF000000000000
    @piece_BB[:bishop] = 0x0000000000000024 | 0x2400000000000000 
    @piece_BB[:knight] = 0x0000000000000042 | 0x4200000000000000 
    @piece_BB[:rook] = 0x0000000000000081 | 0x8100000000000000 
    @piece_BB[:queen] = 0x0000000000000010 | 0x1000000000000000 
    @piece_BB[:king] = 0x0000000000000008 | 0x0800000000000000 

    # initialize color bitboards
    @color_BB = {}
    @color_BB[:white] = 0x000000000000FF00 |
                        0x0000000000000024 |
                        0x0000000000000042 |
                        0x0000000000000081 |
                        0x0000000000000010 |
                        0x0000000000000008

    @color_BB[:black] = 0x00FF000000000000 |
                        0x2400000000000000 |
                        0x4200000000000000 |
                        0x8100000000000000 |
                        0x1000000000000000 |
                        0x0800000000000000

    # initialize occupied space bitboard
    @occupied_BB = @piece_BB[:pawn] |
                   @piece_BB[:bishop] |
                   @piece_BB[:knight] |
                   @piece_BB[:rook] |
                   @piece_BB[:queen] |
                   @piece_BB[:king]
    
    # generate pseudo-legal bitboards ray attacks
    @pseudo_ray_attacks = gen_ray_attacks

    # generate non-ray attack bitboards
    @knight_attacks = gen_knight_attacks
    @king_attacks = gen_king_attacks
    @w_pawn_attacks = gen_w_pawn_attacks
    @b_pawn_attacks = gen_b_pawn_attacks

    @prev_move = nil
  end

  # Returns the piece and color that is residing on a square
  def find_piece(square)
    square_BB = 1 << (63 - square)
    @piece_BB.each do |piece, bitboard|
      piece_loc = square_BB & bitboard
      return [piece, :white] if piece_loc & @color_BB[:white] != 0
      return [piece, :black] if piece_loc & @color_BB[:black] != 0
    end

    [nil, nil]
  end

  def generate_move(src_dest, color)
    src = src_dest[0]
    dest = src_dest[1]
    src_BB = 1 << (63 - src)
    return nil if src_BB & get_occupied_by_color(color) == 0

    piece_type = find_piece(src)
    cap_piece_type = find_piece(dest)
    
    Move.new(src, dest, piece_type[0], piece_type[1], cap_piece_type[0], cap_piece_type[1])
  end

  def legal_move?(move)
    case move.piece
    when :bishop, :rook, :queen
      return legal_ray_move?(move)
    when :pawn
      return legal_pawn_move?(move)
    when :knight
      return legal_knight_move?(move)
    when :king
      return legal_king_move?(move)
    end
    false
  end

  def legal_ray_move?(move)
    legal_move_lambda = -> { self.send("legal_#{move.piece}_rays", move.from_offset, @pseudo_ray_attacks, @occupied_BB) }
    self_color_BB = get_occupied_by_color(move.color)
    to_BB = 1 << (63 - move.to_offset)
    legal_rays_hash = legal_move_lambda.call
    legal_rays_BB = legal_rays_hash.values.reduce(0) { |threat_BB, threat| threat_BB |= threat }
    return true if (legal_rays_BB & to_BB != 0) && 
                   (to_BB & self_color_BB == 0)
    false
  end

  def legal_knight_move?(move)
    self_color_BB = get_occupied_by_color(move.color)
    to_BB = 1 << (63 - move.to_offset)
    return true if (@knight_attacks[move.from_offset] & to_BB != 0) && 
                   (to_BB & self_color_BB == 0)
    false
  end

  def legal_king_move?(move)
    self_color_BB = get_occupied_by_color(move.color)
    to_BB = 1 << (63 - move.to_offset)
    return true if (@king_attacks[move.from_offset] & to_BB != 0) &&
                   (to_BB & self_color_BB == 0)
    false
  end

  def legal_pawn_move?(move)
    colored_pawn_attack = (move.color == :white ? @w_pawn_attacks : @b_pawn_attacks)
    self_color_BB = get_occupied_by_color(move.color)
    enemy_color = get_enemy_color(move.color)
    enemy_color_BB = get_occupied_by_color(enemy_color)
    pawn_column_mask = get_pawn_column_mask(move.from_offset)
    to_BB = 1 << (63 - move.to_offset)
    if to_BB & pawn_column_mask != 0 # Not a capture attempt
      return true if (colored_pawn_attack[move.from_offset] & to_BB != 0) &&
                     (to_BB & @occupied_BB == 0)
    else # Capture attempt
      return true if (colored_pawn_attack[move.from_offset] & to_BB != 0) &&
                     (to_BB & self_color_BB == 0) &&
                     (to_BB & enemy_color_BB != 0)
    end
    false
  end

  def make_move(move)
    from_BB = 1 << (63 - move.from_offset)
    to_BB = 1 << (63 - move.to_offset)
    from_to_BB = from_BB ^ to_BB
    @piece_BB[move.piece] ^= from_to_BB
    @color_BB[move.color] ^= from_to_BB
    @piece_BB[move.cap_piece] ^= to_BB unless move.cap_piece.nil?
    @color_BB[move.cap_color] ^= to_BB unless move.cap_color.nil?
    @occupied_BB ^= from_BB
    @occupied_BB |= to_BB
    @prev_move = move
  end

  def undo_move
    make_move(@prev_move)
    # unset the destination bit if there was no capture
    @occupied_BB ^= (1 << (63 - @prev_move.to_offset)) if @prev_move.cap_piece.nil? 
  end

  def get_pieces_by_color(color)
    occupied_color_BB = get_occupied_by_color(color)
    colored_pieces = {}
    colored_pieces[:bishop] = @piece_BB[:bishop] & occupied_color_BB
    colored_pieces[:rook] = @piece_BB[:rook] & occupied_color_BB
    colored_pieces[:queen] = @piece_BB[:queen] & occupied_color_BB
    colored_pieces[:king] = @piece_BB[:king] & occupied_color_BB
    colored_pieces[:knight] = @piece_BB[:knight] & occupied_color_BB
    colored_pieces[:pawn] = @piece_BB[:pawn] & occupied_color_BB
    colored_pieces
  end

  def in_check?(color)
    king_attackers_info = find_king_attackers(color)
    return false if king_attackers_info[:num_threats] == 0
    true

    #enemy_color = get_enemy_color(color)
    #colored_king_BB = @piece_BB[:king] & @color_BB[color]
    #threat_BB = get_threats_by_color(enemy_color)
    #return true if colored_king_BB & threat_BB != 0
    #false
  end

  def print_board
    square = 0x8000000000000000
    8.times do
      8.times do
        case
        when ((square & (@piece_BB[:pawn] & @color_BB[:white])) != 0)
          print 'P'
        when ((square & (@piece_BB[:bishop] & @color_BB[:white])) != 0)
          print 'B'
        when ((square & (@piece_BB[:knight] & @color_BB[:white])) != 0)
          print 'N'
        when ((square & (@piece_BB[:rook] & @color_BB[:white])) != 0)
          print 'R'
        when ((square & (@piece_BB[:queen] & @color_BB[:white])) != 0)
          print 'Q'
        when ((square & (@piece_BB[:king] & @color_BB[:white])) != 0)
          print 'K'
        when ((square & (@piece_BB[:pawn] & @color_BB[:black])) != 0)
          print 'p'
        when ((square & (@piece_BB[:bishop] & @color_BB[:black])) != 0)
          print 'b'
        when ((square & (@piece_BB[:knight] & @color_BB[:black])) != 0)
          print 'n'
        when ((square & (@piece_BB[:rook] & @color_BB[:black])) != 0)
          print 'r'
        when ((square & (@piece_BB[:queen] & @color_BB[:black])) != 0)
          print 'q'
        when ((square & (@piece_BB[:king] & @color_BB[:black])) != 0)
          print 'k'
        else
          print '-'
        end
        square >>= 1
        print ' '
      end
      puts ''
    end
    puts ''
  end

  private

  def get_threats_by_color(color)
    colored_pieces = get_pieces_by_color(color)
    ray_threats = get_all_ray_threats(colored_pieces)
    nonray_threats = get_all_nonray_threats(colored_pieces, color)
    ray_threats.merge(nonray_threats)
  end

  def get_all_ray_threats(colored_pieces)
    ray_threats = {}
    colored_bishop_threats = get_legal_rays('bishop', colored_pieces[:bishop], @pseudo_ray_attacks, @occupied_BB)
    colored_rook_threats = get_legal_rays('rook', colored_pieces[:rook], @pseudo_ray_attacks, @occupied_BB)
    colored_queen_threats = get_legal_rays('queen', colored_pieces[:queen], @pseudo_ray_attacks, @occupied_BB)
    ray_threats[:bishop] = colored_bishop_threats
    ray_threats[:rook] = colored_rook_threats
    ray_threats[:queen] = colored_queen_threats
    ray_threats 
  end

  def get_all_nonray_threats(colored_pieces, color)
    nonray_threats = {}
    colored_pawn_attack = (color == :white ? @w_pawn_attacks : @b_pawn_attacks)
    colored_pawn_threats = pawn_threats(colored_pieces[:pawn], colored_pawn_attack)
    colored_knight_threats = knight_threats(colored_pieces[:knight], @knight_attacks)
    colored_king_threats = king_threats(colored_pieces[:king], @king_attacks)
    nonray_threats[:pawn] = colored_pawn_threats 
    nonray_threats[:knight] = colored_knight_threats
    nonray_threats[:king] = colored_king_threats
    nonray_threats
  end

  # Generates the bitboard of blocks/captures needed to protect the king, and
  # the number of enemy pieces checking the king.
  def find_king_attackers(king_color)
    colored_king_BB = @piece_BB[:king] & @color_BB[king_color]
    enemy_color = get_enemy_color(king_color)
    king_threats = get_threats_by_color(enemy_color)

    king_attackers_info = {num_threats: 0, block_capture_BB: 0}
    king_threats.values.each do |threat_hash|
      attacker_info = get_king_attacker_info(colored_king_BB, threat_hash)
      king_attackers_info[:num_threats] += attacker_info[:num_threats]
      king_attackers_info[:block_capture_BB] |= attacker_info[:block_capture_BB]
    end
    
    king_attackers_info
  end

  def get_king_attacker_info(colored_king_BB, threat_hash)
    num_threats = 0
    block_capture_BB = 0
    threat_hash.each do |square, threat|
      if threat.is_a?(Hash) #ray threats
        threat.each do |dir8, ray_threat|
          unless colored_king_BB & ray_threat == 0
            block_capture_BB |= ray_threat
            block_capture_BB |= square
            num_threats += 1
            break
          end
        end
      else
        unless colored_king_BB & threat == 0
          block_capture_BB |= threat
          block_capture_BB |= square
          num_threats += 1
        end
      end
    end

    {num_threats: num_threats, block_capture_BB: block_capture_BB}
  end

  def get_occupied_by_color(color)
    @color_BB[color] & @occupied_BB
  end

  def get_enemy_color(self_color)
    self_color == :white ? :black : :white
  end
end