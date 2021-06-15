require './lib/dir8.rb'

# Generates legal ray attacks based on the current pieces on the board
module Ray_Attack
  include Dir8
  
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