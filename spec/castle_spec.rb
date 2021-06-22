require './lib/castle.rb'

describe Castle do
  let(:dummy_chessboard) { Class.new { include Castle } }
  subject(:castle_board) { dummy_chessboard.new }

  describe '#castle_move?' do
    it 'returns false if the moving piece is not a king' do
      move = Move.new(60, 62, :queen, :white)
      result = castle_board.castle_move?(move)

      expect(result).to be(false)
    end

    it 'returns false if the king move is not a castle' do
      move = Move.new(60, 61, :king, :white)
      result = castle_board.castle_move?(move)

      expect(result).to be(false)
    end

    it 'returns true on a valid castle' do
      move = Move.new(60, 62, :king, :white)
      result = castle_board.castle_move?(move)

      expect(result).to be(true)
    end
  end

  describe '#castleable?' do
    it 'returns true when castle is available' do
      move = Move.new(60, 62, :king, :white)
      occupied_BB = 0x000000000008019
      enemy_threat_BB = 0x000000000000FF01
      result = castle_board.castleable?(move, occupied_BB, enemy_threat_BB)

      expect(result).to be(true)
    end

    it 'returns false if the king is in check' do
      move = Move.new(60, 62, :king, :white)
      occupied_BB = 0x000000000009019
      enemy_threat_BB = 0x000000000000FF09
      result = castle_board.castleable?(move, occupied_BB, enemy_threat_BB)

      expect(result).to be(false)
    end

    it 'returns false if the king moves into check' do
      move = Move.new(60, 62, :king, :white)
      occupied_BB = 0x000000000009019
      enemy_threat_BB = 0x000000000000FF02
      result = castle_board.castleable?(move, occupied_BB, enemy_threat_BB)

      expect(result).to be(false)
    end

    it 'returns false if the king passes through check' do
      move = Move.new(60, 62, :king, :white)
      occupied_BB = 0x000000000009019
      enemy_threat_BB = 0x000000000000FF04
      result = castle_board.castleable?(move, occupied_BB, enemy_threat_BB)

      expect(result).to be(false)
    end

    it 'returns false if the castling path is not clear' do
      move = Move.new(60, 62, :king, :white)
      occupied_BB = 0x00000000000901D
      enemy_threat_BB = 0
      result = castle_board.castleable?(move, occupied_BB, enemy_threat_BB)

      expect(result).to be(false)
    end
  end
end