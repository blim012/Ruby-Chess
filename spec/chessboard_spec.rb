require './lib/chessboard.rb'

describe Chessboard do
  describe '#make_move' do
    subject(:make_move_board) { described_class.new }

    it 'performs a quiet move' do
      move = {}
      move[:from_offset] = 42 # offset for the starting square, C3
      move[:to_offset] = 21 # offset for the destination square, F6
      move[:piece] = :bishop # piece to move
      move[:color] = :white # color of piece to move
      move[:cap_piece] = nil # piece to be captured, if any
      move[:cap_color] = nil # color of piece to move, if any

      make_move_board.piece_BB[:bishop] = 0x0000000000200000 # bishop on C3
      make_move_board.color_BB[:white] = 0x0000000000200000
      make_move_board.make_move(move)

      result = make_move_board.piece_BB[:bishop] & make_move_board.color_BB[:white]
      expect(result).to eq(0x0000040000000000)
    end

    it 'updates the occupied bitboard on a quiet move' do
      move = {}
      move[:from_offset] = 42 # offset for the starting square, C3
      move[:to_offset] = 21 # offset for the destination square, F6
      move[:piece] = :bishop # piece to move
      move[:color] = :white # color of piece to move
      move[:cap_piece] = nil # piece to be captured, if any
      move[:cap_color] = nil # color of piece to move, if any

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
      move = {}
      move[:from_offset] = 19 # offset for the starting square, D6
      move[:to_offset] = 51 # offset for the destination square, D2
      move[:piece] = :rook # piece to move
      move[:color] = :black # color of piece to move
      move[:cap_piece] = :pawn # piece to be captured, if any
      move[:cap_color] = :white #color of piece to move, if any

      make_move_board.piece_BB[:rook] = 0x0000100000000000 # rook on D6
      make_move_board.color_BB[:black] = 0x0000100000000000
      make_move_board.make_move(move)

      black_rook = make_move_board.piece_BB[:rook] & make_move_board.color_BB[:black]
      white_pawns = make_move_board.piece_BB[:pawn] & make_move_board.color_BB[:white]
      b_rooks_and_w_pawns = black_rook ^ white_pawns

      expect(b_rooks_and_w_pawns).to eq(0x000000000000FF00)
    end

    it 'updates the occupied bitboard on a capture' do
      move = {}
      move[:from_offset] = 19 # offset for the starting square, D6
      move[:to_offset] = 51 # offset for the destination square, D2
      move[:piece] = :rook # piece to move
      move[:color] = :black # color of piece to move
      move[:cap_piece] = :pawn # piece to be captured, if any
      move[:cap_color] = :white #color of piece to move, if any

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
end