require './lib/searchable.rb'

describe Searchable do
  let(:dummy_chessboard) { Class.new {include Searchable} }

  describe '#find_squares' do
    subject(:bb_to_square) { dummy_chessboard.new }

    it 'returns an array of squares corresponding to set bits in a bitboard' do
      bitboard = 0x2000040000800800
      squares = bb_to_square.find_squares(bitboard)

      expect(squares).to eq([52, 40, 21, 2])
    end
  end
end