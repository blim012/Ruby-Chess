require './lib/dir8.rb'
require './lib/searchable.rb'

# Generates legal ray attacks based on the current pieces on the board
module Ray_Attack
  include Dir8
  include Searchable

  def get_legal_rays(piece, bitboard, pseudo_ray_attacks, occupied_BB)
    all_threats = {}
    ray_legal_lambda = -> square { self.send("legal_#{piece}_rays", square, pseudo_ray_attacks, occupied_BB) }
    squares = find_squares(bitboard)
    squares.each do |square|
      square_to_BB = 1 << (63 - square)
      all_threats[square_to_BB] = ray_legal_lambda.call(square) 
    end
    all_threats
    #squares.reduce(0) { |rays, square| rays |= ray_legal_lambda.call(square) }
  end

  def legal_rook_rays(square, pseudo_ray_attacks, occupied_BB)
    threats = {}
    threats[NORTH] = gen_upper_ray(pseudo_ray_attacks[NORTH][square], occupied_BB)
    threats[WEST] = gen_upper_ray(pseudo_ray_attacks[WEST][square], occupied_BB) 
    threats[SOUTH] = gen_lower_ray(pseudo_ray_attacks[SOUTH][square], occupied_BB) 
    threats[EAST] = gen_lower_ray(pseudo_ray_attacks[EAST][square], occupied_BB)
    threats
  end

  def legal_bishop_rays(square, pseudo_ray_attacks, occupied_BB)
    threats = {}
    threats[NORTHWEST] = gen_upper_ray(pseudo_ray_attacks[NORTHWEST][square], occupied_BB) 
    threats[NORTHEAST] = gen_upper_ray(pseudo_ray_attacks[NORTHEAST][square], occupied_BB) 
    threats[SOUTHWEST] = gen_lower_ray(pseudo_ray_attacks[SOUTHWEST][square], occupied_BB) 
    threats[SOUTHEAST] = gen_lower_ray(pseudo_ray_attacks[SOUTHEAST][square], occupied_BB)
    threats
  end

  def legal_queen_rays(square, pseudo_ray_attacks, occupied_BB)
    rook_threats = legal_rook_rays(square, pseudo_ray_attacks, occupied_BB)
    bishop_threats = legal_bishop_rays(square, pseudo_ray_attacks, occupied_BB)
    rook_threats.merge(bishop_threats)
  end

  def gen_upper_ray(ray, occupied_BB)
    lsb = ray & occupied_BB
    lsb &= -lsb
    lsb | (ray & (lsb - 1))
  end

  def gen_lower_ray(ray, occupied_BB)
    mask = ray & occupied_BB
    return ray if mask == 0
    msb = (1 << mask.bit_length - 1)
    msb | (ray & (msb ^ -msb))
  end
end