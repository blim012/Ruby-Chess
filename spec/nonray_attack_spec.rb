require './lib/nonray_attack.rb'

describe Nonray_Attack do
  let(:dummy_chessboard) { Class.new { include Nonray_Attack } }
  subject(:nonray_board) { dummy_chessboard.new }

  context 'when finding threat bitboards' do
    describe '#knight_threats' do
      before do
        allow(nonray_board).to receive(:find_squares).and_return([38, 49])
      end

      it 'generates a bitboard of all possible threats from knights of a color' do
        knight_attacks = Array.new(64)
        knight_attacks[38] = 0x0000050800080500
        knight_attacks[49] = 0x00000000A0100010

        threat_hash = nonray_board.knight_threats(0, knight_attacks)
        result = threat_hash.values.reduce(0) { |threat_BB, threat| threat_BB |= threat }
        expect(result).to eq(0x00000508A0180510)
      end
    end

    describe '#king_threats' do
      before do
        allow(nonray_board).to receive(:find_squares).and_return([38, 49])
      end

      it 'generates a bitboard of all possible threats from king of a color' do
        king_attacks = Array.new(64)
        king_attacks[38] = 0x0000000705070000
        king_attacks[49] = 0x0000000000E0A0E0

        threat_hash = nonray_board.king_threats(0, king_attacks)
        result = threat_hash.values.reduce(0) { |threat_BB, threat| threat_BB |= threat }
        expect(result).to eq(0x0000000705E7A0E0)
      end
    end

    describe '#pawn_threats' do
      before do
        allow(nonray_board).to receive(:find_squares).and_return([38, 49])
        allow(nonray_board).to receive(:get_pawn_column_mask).and_return(0x0202020202020202, 0x4040404040404040)
      end

      it 'generates a bitboard of all possible threats from pawn of a color' do
        pawn_attacks = Array.new(64)
        pawn_attacks[38] = 0x0000000500000000
        pawn_attacks[49] = 0x0000000000A00000

        threat_hash = nonray_board.pawn_threats(0, pawn_attacks)
        result = threat_hash.values.reduce(0) { |threat_BB, threat| threat_BB |= threat }
        expect(result).to eq(0x0000000500A00000)
      end
    end
  end

  describe '#get_pawn_column_mask' do
    it 'returns a mask that represents a column of the chessboard' do
      square = 35 # column d
      column_mask = nonray_board.get_pawn_column_mask(square)

      expect(column_mask).to eq(0x1010101010101010)
    end
  end
end