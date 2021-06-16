require './lib/chessboard.rb'
require './lib/move.rb'

describe Chessboard do
  describe '#make_move' do
    subject(:make_move_board) { described_class.new }

    it 'performs a quiet move' do
      move = Move.new(42, 21, :bishop, :white)

      make_move_board.piece_BB[:bishop] = 0x0000000000200000 # bishop on C3
      make_move_board.color_BB[:white] = 0x0000000000200000
      make_move_board.make_move(move)

      result = make_move_board.piece_BB[:bishop] & make_move_board.color_BB[:white]
      expect(result).to eq(0x0000040000000000)
    end

    it 'updates the occupied bitboard on a quiet move' do
      move = Move.new(42, 21, :bishop, :white)

      make_move_board.piece_BB[:bishop] = 0x0000000000200000 # bishop on C3
      make_move_board.color_BB[:white] = 0x0000000000200000
      make_move_board.occupied_BB = make_move_board.piece_BB[:pawn] |
                                    make_move_board.piece_BB[:bishop] |
                                    make_move_board.piece_BB[:knight] |
                                    make_move_board.piece_BB[:rook] |
                                    make_move_board.piece_BB[:queen] |
                                    make_move_board.piece_BB[:king]
      make_move_board.make_move(move) 

      expect(make_move_board.occupied_BB).to eq(0xDBFF04000000FFDB)
    end

    it 'performs a capture' do
      move = Move.new(19, 51, :rook, :black, :pawn, :white)

      make_move_board.piece_BB[:rook] = 0x0000100000000000 # rook on D6
      make_move_board.color_BB[:black] = 0x0000100000000000
      make_move_board.make_move(move)

      black_rook = make_move_board.piece_BB[:rook] & make_move_board.color_BB[:black]
      white_pawns = make_move_board.piece_BB[:pawn] & make_move_board.color_BB[:white]
      b_rooks_and_w_pawns = black_rook ^ white_pawns

      expect(b_rooks_and_w_pawns).to eq(0x000000000000FF00)
    end

    it 'updates the occupied bitboard on a capture' do
      move = Move.new(19, 51, :rook, :black, :pawn, :white)

      make_move_board.piece_BB[:rook] = 0x0000100000000000 # rook on D6
      make_move_board.color_BB[:black] = 0x0000100000000000
      make_move_board.occupied_BB = make_move_board.piece_BB[:pawn] |
                                    make_move_board.piece_BB[:bishop] |
                                    make_move_board.piece_BB[:knight] |
                                    make_move_board.piece_BB[:rook] |
                                    make_move_board.piece_BB[:queen] |
                                    make_move_board.piece_BB[:king]
      make_move_board.make_move(move)

      expect(make_move_board.occupied_BB).to eq(0x7EFF00000000FF7E)
    end
  end

  context 'when testing the legality of a move' do
    describe '#legal_queen_move?' do
      subject(:queen_move_board) { described_class.new }

      it 'returns true on legal quiet move' do
        move = Move.new(42, 21, :queen, :white)
        queen_move_board.piece_BB[:queen] = 0x0000000000200000 # queen on C3
        queen_move_board.color_BB[:white] |= 0x0000000000200000
        queen_move_board.occupied_BB |= queen_move_board.piece_BB[:queen]
        
        result = queen_move_board.legal_queen_move?(move)
        expect(result).to be(true)
      end

      it 'returns true on legal capture' do
        move = Move.new(42, 14, :queen, :white)
        queen_move_board.piece_BB[:queen] = 0x0000000000200000 # queen on C3
        queen_move_board.color_BB[:white] |= 0x0000000000200000
        queen_move_board.occupied_BB |= queen_move_board.piece_BB[:queen]
        
        result = queen_move_board.legal_queen_move?(move)
        expect(result).to be(true)
      end

      it 'returns false on illegal quiet move' do
        move = Move.new(42, 19, :queen, :white)
        queen_move_board.piece_BB[:queen] = 0x0000000000200000 # queen on C3
        queen_move_board.color_BB[:white] |= 0x0000000000200000
        queen_move_board.occupied_BB |= queen_move_board.piece_BB[:queen]
        
        result = queen_move_board.legal_queen_move?(move)
        expect(result).to be(false)
      end

      it 'returns false on illegal capture' do
        move = Move.new(42, 50, :queen, :white)
        queen_move_board.piece_BB[:queen] = 0x0000000000200000 # queen on C3
        queen_move_board.color_BB[:white] |= 0x0000000000200000
        queen_move_board.occupied_BB |= queen_move_board.piece_BB[:queen]
        
        result = queen_move_board.legal_queen_move?(move)
        expect(result).to be(false)
      end
    end

    describe '#legal_bishop_move?' do
      
    end
  end
end