require './lib/ray_attack.rb'

describe Ray_Attack do
  let(:dummy_chessboard) { Class.new { include Ray_Attack } }

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

  end
end