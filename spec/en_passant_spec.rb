require './lib/en_passant.rb'
require './lib/move.rb'

describe En_Passant do
  let(:dummy_chessboard) { Class.new { include En_Passant } }
  subject(:en_passant_board) { dummy_chessboard.new }

  describe '#en_passantable?' do
    it 'returns false if the piece is not a pawn' do
      move = Move.new(50, 35, :rook, :white)
      result = en_passant_board.en_passantable?(move)

      expect(result).to be(false)
    end

    it 'returns false if the pawn did not move two spaces forward' do
      move = Move.new(50, 42, :pawn, :white)
      result = en_passant_board.en_passantable?(move)

      expect(result).to be(false)
    end

    it 'returns true if the pawn that moved is en passantable' do
      move = Move.new(50, 35, :pawn, :white)
      result = en_passant_board.en_passantable?(move)

      expect(result).to be(false)
    end
  end
end