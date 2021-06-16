require './lib/dir8.rb'
require './lib/bb_to_square.rb'

# Generates legal ray attacks based on the current pieces on the board
module Ray_Attack
  include Dir8
  include BB_To_Square

  def get_legal_rays(piece, bitboard, pseudo_ray_attacks, occupied_BB)
    ray_legal_method = -> square { self.send("legal_#{piece}_rays", square, pseudo_ray_attacks, occupied_BB) }
    rays = []
    squares = find_squares(bitboard)
    squares.each { |square| rays.push(ray_legal_method.call(square)) }
    rays
  end

  def legal_rook_rays(square, pseudo_ray_attacks, occupied_BB)
    gen_upper_ray(pseudo_ray_attacks[NORTH][square], occupied_BB) |
    gen_upper_ray(pseudo_ray_attacks[WEST][square], occupied_BB) |
    gen_lower_ray(pseudo_ray_attacks[SOUTH][square], occupied_BB) |
    gen_lower_ray(pseudo_ray_attacks[EAST][square], occupied_BB)
  end

  def legal_bishop_rays(square, pseudo_ray_attacks, occupied_BB)
    gen_upper_ray(pseudo_ray_attacks[NORTHWEST][square], occupied_BB) |
    gen_upper_ray(pseudo_ray_attacks[NORTHEAST][square], occupied_BB) |
    gen_lower_ray(pseudo_ray_attacks[SOUTHWEST][square], occupied_BB) |
    gen_lower_ray(pseudo_ray_attacks[SOUTHEAST][square], occupied_BB)
  end

  def legal_queen_rays(square, pseudo_ray_attacks, occupied_BB)
    legal_rook_rays(square, pseudo_ray_attacks, occupied_BB) |
    legal_bishop_rays(square, pseudo_ray_attacks, occupied_BB)
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