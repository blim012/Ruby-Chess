require './lib/ray_attack.rb'

describe Ray_Attack do
  let(:dummy_chessboard) { Class.new { include Ray_Attack } }

  context 'when generating general legal rays' do
    describe '#gen_upper_ray' do
      subject(:upper_ray_attack) { dummy_chessboard.new }
      let(:occupied_BB) { 0x6FCA11A4E011F175 }

      it 'generates legal west ray' do
        west_ray = 0x0000000000F00000 
        result = upper_ray_attack.gen_upper_ray(west_ray, occupied_BB)

        expect(result).to eq(0x0000000000100000)
      end

      it 'generates legal northwest ray' do
        northwest_ray = 0x0080402010000000
        result = upper_ray_attack.gen_upper_ray(northwest_ray, occupied_BB)

        expect(result).to eq(0x0000002010000000)
      end

      it 'generates legal north ray' do
        north_ray = 0x0808080808000000
        result = upper_ray_attack.gen_upper_ray(north_ray, occupied_BB)

        expect(result).to eq(0x0008080808000000)
      end

      it 'generates legal northeast ray' do
        northeast_ray = 0x0000010204000000
        result = upper_ray_attack.gen_upper_ray(northeast_ray, occupied_BB)

        expect(result).to eq(0x0000010204000000)
      end

      it 'returns the entire ray if there are no pieces in the way' do
        ray = 0x0808080808000000
        occupied = 0
        result = upper_ray_attack.gen_upper_ray(ray, occupied)

        expect(result).to eq(0x0808080808000000)
      end
    end

    describe '#gen_lower_ray' do
      subject(:lower_ray_attack) { dummy_chessboard.new }
      let(:occupied_BB) { 0x977223404C42B556 }

      it 'generates legal east ray' do
        east_ray = 0x00000F0000000000
        result = lower_ray_attack.gen_lower_ray(east_ray, occupied_BB)

        expect(result).to eq(0x00000E0000000000)
      end

      it 'generates legal southeast ray' do
        southeast_ray = 0x0000000804020100
        result = lower_ray_attack.gen_lower_ray(southeast_ray, occupied_BB)

        expect(result).to eq(0x0000000804000000)
      end

      it 'generates legal south ray' do
        south_ray = 0x0000001010101010
        result = lower_ray_attack.gen_lower_ray(south_ray, occupied_BB)

        expect(result).to eq(0x0000001010101000)
      end

      it 'generates legal southwest ray' do
        southwest_ray = 0x0000002040800000
        result = lower_ray_attack.gen_lower_ray(southwest_ray, occupied_BB)

        expect(result).to eq(0x0000002040000000)
      end

      it 'returns the entire ray if there are no pieces in the way' do
        ray = 0x0000001010101010
        occupied = 0
        result = lower_ray_attack.gen_lower_ray(ray, occupied)

        expect(result).to eq(0x0000001010101010)
      end
    end
  end

  context 'when generating legal rays for specific pieces' do
    let(:occupied_BB) { 0x6FCA11A4E011F175 }
    
    describe '#legal_rook_rays' do
      subject(:rook_ray_attack) { dummy_chessboard.new }

      it 'generates all possible legal moves for a rook' do
        pseudo_ray_attacks = Array.new(8) { Array.new(64) }
        pseudo_ray_attacks[1][44] = 0x0808080808000000 # north
        pseudo_ray_attacks[3][44] = 0x0000000000070000 # east
        pseudo_ray_attacks[5][44] = 0x0000000000000808 # south
        pseudo_ray_attacks[7][44] = 0x0000000000F00000 # west
        result = rook_ray_attack.legal_rook_rays(44, pseudo_ray_attacks, occupied_BB)

        expect(result).to eq(0x0008080808170808)
      end
    end

    describe '#legal_bishop_rays' do
      subject(:bishop_ray_attack) { dummy_chessboard.new }

      it 'generates all possible legal moves for a bishop' do
        pseudo_ray_attacks = Array.new(8) { Array.new(64) }
        pseudo_ray_attacks[0][44] = 0x0080402010000000 # northwest
        pseudo_ray_attacks[2][44] = 0x0000010204000000 # northeast
        pseudo_ray_attacks[4][44] = 0x0000000000000402 # southeast
        pseudo_ray_attacks[6][44] = 0x0000000000001020 # southwest

        result = bishop_ray_attack.legal_bishop_rays(44, pseudo_ray_attacks, occupied_BB)
        expect(result).to eq(0x12214001402)
      end
    end
  end

  context 'when getting all of the rays for a type of piece' do
    describe '#get_legal_rays' do
      subject(:piece_rays) { dummy_chessboard.new }

      it 'generates the set of all possible rays for bishops' do
        pseudo_ray_attacks = Array.new(8) { Array.new(64) }
        pseudo_ray_attacks[0][44] = 0x0080402010000000 # northwest
        pseudo_ray_attacks[2][44] = 0x0000010204000000 # northeast
        pseudo_ray_attacks[4][44] = 0x0000000000000402 # southeast
        pseudo_ray_attacks[6][44] = 0x0000000000001020 # southwest
        pseudo_ray_attacks[0][34] = 0x0000804000000000 # northwest
        pseudo_ray_attacks[2][34] = 0x0204081000000000 # northeast
        pseudo_ray_attacks[4][34] = 0x0000000000108040 # southeast
        pseudo_ray_attacks[6][34] = 0x0000000000408000 # southwest
        piece = 'bishop'
        bitboard = 0x0000000020080000
        occupied = 0x6FCA11A4C011F175

        result = piece_rays.get_legal_rays(piece, bitboard, pseudo_ray_attacks, occupied)

        expect(result).to eq(0x204897214509402)
      end
    end
  end
end