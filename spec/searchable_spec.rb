require './lib/searchable.rb'

describe Searchable do
  let(:dummy_chessboard) { Class.new {include Searchable} }
  subject(:search_board) { dummy_chessboard.new }

  describe '#find_squares' do
    it 'returns an array of squares corresponding to set bits in a bitboard' do
      bitboard = 0x2000040000800800
      squares = search_board.find_squares(bitboard)

      expect(squares).to eq([52, 40, 21, 2])
    end
  end
end