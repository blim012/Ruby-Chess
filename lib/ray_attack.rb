require './lib/dir8.rb'
require './lib/bb_to_square.rb'

# Generates legal ray attacks based on the current pieces on the board
module Ray_Attack
  include Dir8
  include BB_To_Square

  #Returns all legal ray attacks for all pieces in a hash                                                                                                                                                                                                             
  def get_all_ray_attacks(piece_BB, color_BB, pseudo_ray_attacks, occupied_BB)
    white_occupied = color_BB[:white] & occupied_BB
    black_occupied = color_BB[:black] & occupied_BB
    white_bishop = piece_BB[:bishop] & white_occupied
    white_rook = piece_BB[:rook] & white_occupied
    white_queen = piece_BB[:queen] & white_occupied
    black_bishop = piece_BB[:bishop] & black_occupied
    black_rook = piece_BB[:rook] & black_occupied
    black_queen = piece_BB[:queen] & black_occupied

    white_rays = {}
    white_rays[:bishop] = get_legal_rays('bishop', white_bishop, pseudo_ray_attacks, occupied_BB)
    white_rays[:rook] = get_legal_rays('rook', white_rook, pseudo_ray_attacks, occupied_BB)
    white_rays[:queen] = get_legal_rays('queen', white_queen, pseudo_ray_attacks, occupied_BB)

    black_rays = {}
    black_rays[:bishop] = get_legal_rays('bishop', black_bishop, pseudo_ray_attacks, occupied_BB)
    black_rays[:rook] = get_legal_rays('rook', black_rook, pseudo_ray_attacks, occupied_BB)
    black_rays[:queen] =  get_legal_rays('queen', black_queen, pseudo_ray_attacks, occupied_BB)

    legal_ray_attacks = { white: white_rays, black: black_rays }
  end

  def get_legal_rays(piece, bitboard, pseudo_ray_attacks, occupied_BB)
    ray_legal_lambda = -> square { self.send("legal_#{piece}_rays", square, pseudo_ray_attacks, occupied_BB) }
    rays = []
    squares = find_squares(bitboard)
    squares.each { |square| rays.push(ray_legal_lambda.call(square)) }
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