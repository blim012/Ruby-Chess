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
    subject(:legal_move_board) { described_class.new }

    describe '#legal_ray_move?' do
      it 'returns true on legal quiet move with a queen' do
        move = Move.new(42, 21, :queen, :white)
        legal_move_board.piece_BB[:queen] = 0x0000000000200000 # queen on C3
        legal_move_board.color_BB[:white] |= 0x0000000000200000
        legal_move_board.occupied_BB |= legal_move_board.piece_BB[:queen]
        
        result = legal_move_board.legal_ray_move?(move)
        expect(result).to be(true)
      end

      it 'returns true on legal capture with a queen' do
        move = Move.new(42, 14, :queen, :white)
        legal_move_board.piece_BB[:queen] = 0x0000000000200000 # queen on C3
        legal_move_board.color_BB[:white] |= 0x0000000000200000
        legal_move_board.occupied_BB |= legal_move_board.piece_BB[:queen]
        
        result = legal_move_board.legal_ray_move?(move)
        expect(result).to be(true)
      end

      it 'returns false on illegal quiet move with a queen'  do
        move = Move.new(42, 19, :queen, :white)
        legal_move_board.piece_BB[:queen] = 0x0000000000200000 # queen on C3
        legal_move_board.color_BB[:white] |= 0x0000000000200000
        legal_move_board.occupied_BB |= legal_move_board.piece_BB[:queen]
        
        result = legal_move_board.legal_ray_move?(move)
        expect(result).to be(false)
      end

      it 'returns false on illegal capture with a queen' do
        move = Move.new(42, 50, :queen, :white)
        legal_move_board.piece_BB[:queen] = 0x0000000000200000 # queen on C3
        legal_move_board.color_BB[:white] |= 0x0000000000200000
        legal_move_board.occupied_BB |= legal_move_board.piece_BB[:queen]
        
        result = legal_move_board.legal_ray_move?(move)
        expect(result).to be(false)
      end
    end

    describe '#legal_knight_move?' do
      it 'returns true on legal quiet move' do
        move = Move.new(35, 29, :knight, :black)
        legal_move_board.piece_BB[:knight] = 0x0000000010000000 # knight on D4
        legal_move_board.color_BB[:black] |= 0x0000000010000000
        legal_move_board.occupied_BB |= legal_move_board.piece_BB[:knight]
        
        result = legal_move_board.legal_knight_move?(move)
        expect(result).to be(true)
      end

      it 'returns true on legal capture' do
        move = Move.new(35, 50, :knight, :black)
        legal_move_board.piece_BB[:knight] = 0x0000000010000000 # knight on D4
        legal_move_board.color_BB[:black] |= 0x0000000010000000
        legal_move_board.occupied_BB |= legal_move_board.piece_BB[:knight]
        
        result = legal_move_board.legal_knight_move?(move)
        expect(result).to be(true)
      end

      it 'returns false on illegal quiet move'  do
        move = Move.new(27, 43, :knight, :black)
        legal_move_board.piece_BB[:knight] = 0x0000001000000000 # knight on D5
        legal_move_board.color_BB[:black] |= 0x0000001000000000
        legal_move_board.occupied_BB |= legal_move_board.piece_BB[:knight]
        
        result = legal_move_board.legal_knight_move?(move)
        expect(result).to be(false)
      end

      it 'returns false on illegal capture' do
        move = Move.new(27, 10, :knight, :black)
        legal_move_board.piece_BB[:knight] = 0x0000001000000000 # knight on D5
        legal_move_board.color_BB[:black] |= 0x0000001000000000
        legal_move_board.occupied_BB |= legal_move_board.piece_BB[:knight]
        
        result = legal_move_board.legal_knight_move?(move)
        expect(result).to be(false)
      end
    end

    describe '#legal_king_move?' do
      it 'returns true on legal quiet move' do
        move = Move.new(35, 27, :king, :black)
        legal_move_board.piece_BB[:king] = 0x0000000010000000 # king on D4
        legal_move_board.color_BB[:black] |= 0x0000000010000000
        legal_move_board.occupied_BB |= legal_move_board.piece_BB[:king]
        
        result = legal_move_board.legal_king_move?(move)
        expect(result).to be(true)
      end

      it 'returns true on legal capture' do
        move = Move.new(43, 51, :king, :black)
        legal_move_board.piece_BB[:king] = 0x0000000000100000 # king on D3
        legal_move_board.color_BB[:black] |= 0x0000000000100000
        legal_move_board.occupied_BB |= legal_move_board.piece_BB[:king]
        
        result = legal_move_board.legal_king_move?(move)
        expect(result).to be(true)
      end

      it 'returns false on illegal quiet move'  do
        move = Move.new(27, 43, :king, :black)
        legal_move_board.piece_BB[:king] = 0x0000001000000000 # king on D5
        legal_move_board.color_BB[:black] |= 0x0000001000000000
        legal_move_board.occupied_BB |= legal_move_board.piece_BB[:king]
        
        result = legal_move_board.legal_king_move?(move)
        expect(result).to be(false)
      end

      it 'returns false on illegal capture' do
        move = Move.new(19, 11, :king, :black)
        legal_move_board.piece_BB[:king] = 0x0000100000000000 # king on D6
        legal_move_board.color_BB[:black] |= 0x0000100000000000
        legal_move_board.occupied_BB |= legal_move_board.piece_BB[:king]
        
        result = legal_move_board.legal_king_move?(move)
        expect(result).to be(false)
      end
    end
  end

  describe '#get_pieces_by_color' do
    subject(:get_pieces_board) { described_class.new }

    it 'returns the bitboards of all white pieces' do
      white_pieces = get_pieces_board.get_pieces_by_color(:white)
      expected_pieces = {}
      expected_pieces[:pawn] = 0x000000000000FF00
      expected_pieces[:bishop] = 0x0000000000000024
      expected_pieces[:knight] = 0x0000000000000042
      expected_pieces[:rook] = 0x0000000000000081
      expected_pieces[:queen] = 0x0000000000000010
      expected_pieces[:king] = 0x0000000000000008

      expect(expected_pieces).to eq(white_pieces)
    end

    it 'returns the bitboards of all black pieces' do
      black_bitboard = get_pieces_board.get_pieces_by_color(:black)
      expected_pieces = {}
      expected_pieces[:pawn] = 0x00FF000000000000
      expected_pieces[:bishop] = 0x2400000000000000
      expected_pieces[:knight] = 0x4200000000000000
      expected_pieces[:rook] = 0x8100000000000000
      expected_pieces[:queen] = 0x1000000000000000
      expected_pieces[:king] = 0x0800000000000000

      expect(expected_pieces).to eq(black_bitboard)
    end
  end

  context 'when obtaining a threat bitboard of a color' do
  end
end