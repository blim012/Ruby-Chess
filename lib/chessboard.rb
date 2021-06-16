require './lib/gen_pseudo_moves.rb'
require './lib/ray_attack.rb'

class Chessboard
  include Gen_Pseudo_Moves
  include Ray_Attack

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

    # generate initial legal ray attack bitboards

    # generate non-ray attack bitboards
    @knight_attacks = gen_knight_attacks
    @king_attacks = gen_king_attacks
    @w_pawn_attacks = gen_w_pawn_attacks
    @b_pawn_attacks = gen_b_pawn_attacks

    @prev_move = nil

    #We only need to update the legal RAY attacks after each piece move.
  end

  # move: { 
  #         from_offset: offset, 
  #         to_offset: offset, 
  #         piece: symbol,
  #         color: symbol,
  #         cap_piece: symbol,
  #         cap_color: symbol
  #       }

  def make_move(move)
    from_BB = 1 << (63 - move[:from_offset])
    to_BB = 1 << (63 - move[:to_offset])
    from_to_BB = from_BB ^ to_BB
    @piece_BB[move[:piece]] ^= from_to_BB
    @color_BB[move[:color]] ^= from_to_BB
    @piece_BB[move[:cap_piece]] ^= to_BB
    @color_BB[move[:cap_color]] ^= to_BB
    @occupied_BB ^= from_BB
    @occupied_BB |= to_BB
  end

  # legal_move? (from_offset, to_offset)
  #   1) get piece type and color using from_offset 
  #   2) depending on the piece, run 'piece'_move? (from_offset, to_offset)
  # end

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
  end
end