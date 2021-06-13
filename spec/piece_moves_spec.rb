require './lib/piece_moves.rb'

describe Piece_Moves do
  let(:dummy_chessboard) { Class.new { include Piece_Moves } }

  context 'when generating pseudo-legal piece moves' do
    describe '#gen_ray_attacks' do
      subject(:ray_piece_moves) { dummy_chessboard.new }

      # Direction of rays as indices 
      NORTH_WEST = 0
      NORTH = 1
      NORTH_EAST = 2
      EAST = 3
      SOUTH_EAST = 4
      SOUTH = 5
      SOUTH_WEST = 6
      WEST = 7

      it 'generates rays in all possible directions' do
        index_for_d4 = 35
        rays = ray_piece_moves.gen_ray_attacks
        rays_at_d4 = rays[NORTH_WEST][index_for_d4] |
                    rays[NORTH][index_for_d4] |
                    rays[NORTH_EAST][index_for_d4] |
                    rays[EAST][index_for_d4] |
                    rays[SOUTH_EAST][index_for_d4] |
                    rays[SOUTH][index_for_d4] |
                    rays[SOUTH_WEST][index_for_d4] |
                    rays[WEST][index_for_d4]
        
        expect(rays_at_d4).to eq(0x11925438EF385492)
      end

      it 'generates rays properly against edge squares' do
        index_for_a5 = 24
        rays = ray_piece_moves.gen_ray_attacks
        rays_at_a5 = rays[NORTH_WEST][index_for_a5] |
                    rays[NORTH][index_for_a5] |
                    rays[NORTH_EAST][index_for_a5] |
                    rays[EAST][index_for_a5] |
                    rays[SOUTH_EAST][index_for_a5] |
                    rays[SOUTH][index_for_a5] |
                    rays[SOUTH_WEST][index_for_a5] |
                    rays[WEST][index_for_a5]

        expect(rays_at_a5).to eq(0x90A0C07FC0A09088)
      end

      it 'generates rays properly on corner squares' do
        index_for_h8 = 7
        rays = ray_piece_moves.gen_ray_attacks
        rays_at_h8 = rays[NORTH_WEST][index_for_h8] |
                    rays[NORTH][index_for_h8] |
                    rays[NORTH_EAST][index_for_h8] |
                    rays[EAST][index_for_h8] |
                    rays[SOUTH_EAST][index_for_h8] |
                    rays[SOUTH][index_for_h8] |
                    rays[SOUTH_WEST][index_for_h8] |
                    rays[WEST][index_for_h8]

        expect(rays_at_h8).to eq(0xFE03050911214181)
      end
    end

    describe '#gen_knight_attacks' do
      subject(:knight_piece_moves) { dummy_chessboard.new }

      it 'generates moves properly in all possible directions' do
        index_for_d5 = 27
        knight_moves = knight_piece_moves.gen_knight_attacks
        knight_at_d5 = knight_moves[index_for_d5]

        expect(knight_at_d5).to eq(0x28440044280000)
      end

      it 'does not generate moves out of bounds' do
        index_for_a1 = 56
        knight_moves = knight_piece_moves.gen_knight_attacks
        knight_at_a1 = knight_moves[index_for_a1]

        expect(knight_at_a1).to eq(0x402000)
      end
    end

    describe '#gen_king_attacks' do
      subject(:king_piece_moves) { dummy_chessboard.new }

      it 'generates moves properly in all possible directions' do
        index_for_g7 = 14
        king_moves = king_piece_moves.gen_king_attacks
        king_at_g7 = king_moves[index_for_g7]

        expect(king_at_g7).to eq(0x705070000000000)
      end

      it 'does not generate moves out of bounds' do
        index_for_h1 = 63
        king_moves = king_piece_moves.gen_king_attacks
        king_at_h1 = king_moves[index_for_h1]

        expect(king_at_h1).to eq(0x302)
      end
    end

    describe '#gen_w_pawn_attacks' do
      subject(:w_pawn_piece_moves) { dummy_chessboard.new }

      it 'generates moves properly in all possible directions' do
        index_for_e3 = 44
        w_pawn_moves = w_pawn_piece_moves.gen_w_pawn_attacks
        w_pawn_at_e3 = w_pawn_moves[index_for_e3]

        expect(w_pawn_at_e3).to eq(0x1C000000)
      end

      it 'allows pawns to move two spaces forward if they are on their starting square' do
        index_for_a2 = 48
        w_pawn_moves = w_pawn_piece_moves.gen_w_pawn_attacks
        w_pawn_at_a2 = w_pawn_moves[index_for_a2]

        expect(w_pawn_at_a2).to eq(0x80C00000)
      end

      it 'does not generate moves out of bounds' do
        index_for_a8 = 0
        w_pawn_moves = w_pawn_piece_moves.gen_w_pawn_attacks
        w_pawn_at_a8 = w_pawn_moves[index_for_a8]

        expect(w_pawn_at_a8).to eq(0)
      end
    end
  end
end