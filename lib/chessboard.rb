class Chessboard
  def initialize
    #initialize bitboards
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