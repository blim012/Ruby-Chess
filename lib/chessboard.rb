require './lib/piece_moves.rb'

class Chessboard
  include Piece_Moves
  attr_reader :ray_attacks

  def initialize
    # initialize piece bitboards
    @w_pawn = 0x000000000000FF00
    @w_bishop = 0x0000000000000024
    @w_knight = 0x0000000000000042
    @w_rook = 0x0000000000000081
    @w_queen = 0x0000000000000010
    @w_king = 0x0000000000000008

    @b_pawn = 0x00FF000000000000
    @b_bishop = 0x2400000000000000
    @b_knight = 0x4200000000000000
    @b_rook = 0x8100000000000000
    @b_queen = 0x1000000000000000
    @b_king = 0x0800000000000000

    # can probably move the attacks/attack_from into classes

    # generate attack (pseudo-legal move) bitboards
    @ray_attacks = gen_ray_attacks
    @knight_attacks = gen_knight_attacks
    @king_attacks = gen_king_attacks
    #@pawn_attacks = gen_pawn_attacks

    # I think we have to update attack_from every single turn for both players

    @prev_move = nil
  end

  def print_king_moves_at_square(square_index)
    king_moves = @king_attacks[square_index]
    square = 0x8000000000000000
    8.times do
      8.times do
        case
        when ((square & king_moves) != 0)
          print '.'
        else
          print '-'
        end
        square >>= 1
        print ' '
      end
      puts ''
    end
  end

  def print_knight_moves_at_square(square_index)
    knight_moves = @knight_attacks[square_index]
    square = 0x8000000000000000
    8.times do
      8.times do
        case
        when ((square & knight_moves) != 0)
          print '.'
        else
          print '-'
        end
        square >>= 1
        print ' '
      end
      puts ''
    end
  end

  def print_rays_at_square(square_index)
    rays_at_square_index = @ray_attacks[Piece_Moves::NORTH_WEST][square_index] |
                           @ray_attacks[Piece_Moves::NORTH][square_index] |
                           @ray_attacks[Piece_Moves::NORTH_EAST][square_index] |
                           @ray_attacks[Piece_Moves::EAST][square_index] |
                           @ray_attacks[Piece_Moves::SOUTH_EAST][square_index] |
                           @ray_attacks[Piece_Moves::SOUTH][square_index] |
                           @ray_attacks[Piece_Moves::SOUTH_WEST][square_index] |
                           @ray_attacks[Piece_Moves::WEST][square_index]

    square = 0x8000000000000000
    8.times do
      8.times do
        case
        when ((square & rays_at_square_index) != 0)
          print '.'
        else
          print '-'
        end
        square >>= 1
        print ' '
      end
      puts ''
    end
  end

  def print_board
    square = 0x8000000000000000
    8.times do
      8.times do
        case
        when ((square & @w_pawn) != 0)
          print 'P'
        when ((square & @w_bishop) != 0)
          print 'B'
        when ((square & @w_knight) != 0)
          print 'N'
        when ((square & @w_rook) != 0)
          print 'R'
        when ((square & @w_queen) != 0)
          print 'Q'
        when ((square & @w_king) != 0)
          print 'K'
        when ((square & @b_pawn) != 0)
          print 'p'
        when ((square & @b_bishop) != 0)
          print 'b'
        when ((square & @b_knight) != 0)
          print 'n'
        when ((square & @b_rook) != 0)
          print 'r'
        when ((square & @b_queen) != 0)
          print 'q'
        when ((square & @b_king) != 0)
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