require './lib/gen_pseudo_moves.rb'
require './lib/gen_legal_moves.rb'

class Chessboard
  include Gen_Pseudo_Moves
  include Gen_Legal_Moves

  attr_reader :ray_attacks

  def initialize
    # initialize piece bitboards
    @white_pieces = {}
    @white_pieces[:pawn] = 0x000000000000FF00
    @white_pieces[:bishop] = 0x0000000000000024 
    @white_pieces[:knight] = 0x0000000000000042
    @white_pieces[:rook] = 0x0000000000000081  
    @white_pieces[:queen] = 0x0000000000000010 
    @white_pieces[:king] = 0x0000000000000008 

    @black_pieces = {}
    @black_pieces[:pawn] = 0x00FF000000000000  
    @black_pieces[:bishop] = 0x2400000000000000 
    @black_pieces[:knight] = 0x4200000000000000
    @black_pieces[:rook] = 0x8100000000000000 
    @black_pieces[:queen] = 0x1000000000000000 
    @black_pieces[:king] = 0x0800000000000000
     
    # can probably move the attacks/attack_from into classes

    # generate attack (pseudo-legal move) bitboards
    @ray_attacks = gen_ray_attacks
    @knight_attacks = gen_knight_attacks
    @king_attacks = gen_king_attacks
    @w_pawn_attacks = gen_w_pawn_attacks
    @b_pawn_attacks = gen_b_pawn_attacks

    # I think we have to update attack_from every single turn for both players

    @prev_move = nil
  end

  def print_board
    square = 0x8000000000000000
    8.times do
      8.times do
        case
        when ((square & @white_pieces[:pawn]) != 0)
          print 'P'
        when ((square & @white_pieces[:bishop]) != 0)
          print 'B'
        when ((square & @white_pieces[:knight]) != 0)
          print 'N'
        when ((square & @white_pieces[:rook]) != 0)
          print 'R'
        when ((square & @white_pieces[:queen]) != 0)
          print 'Q'
        when ((square & @white_pieces[:king]) != 0)
          print 'K'
        when ((square & @black_pieces[:pawn]) != 0)
          print 'p'
        when ((square & @black_pieces[:bishop]) != 0)
          print 'b'
        when ((square & @black_pieces[:knight]) != 0)
          print 'n'
        when ((square & @black_pieces[:rook]) != 0)
          print 'r'
        when ((square & @black_pieces[:queen]) != 0)
          print 'q'
        when ((square & @black_pieces[:king]) != 0)
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