require './lib/piece_moves.rb'

describe Piece_Moves do
  describe '#gen_ray_attacks' do
    let(:dummy_chessboard) { Class.new { include Piece_Moves } }
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
end