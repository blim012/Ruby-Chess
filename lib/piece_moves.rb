module Piece_Moves
  # Ray directions
  NORTH_WEST = 0
  NORTH = 1
  NORTH_EAST = 2
  EAST = 3
  SOUTH_EAST = 4
  SOUTH = 5
  SOUTH_WEST = 6
  WEST = 7

  def gen_ray_attacks
    # returned as the container of all ray attacks
    # format: ray_attacks[8][64] for 8 directions and 64 squares
    ray_attacks = []

    nw_ray_attacks = gen_directional_rays(-1, -1)
    n_ray_attacks = gen_directional_rays(0, -1)
    ne_ray_attacks = gen_directional_rays(1, -1)
    e_ray_attacks = gen_directional_rays(1, 0)
    se_ray_attacks = gen_directional_rays(1, 1)
    s_ray_attacks = gen_directional_rays(0, 1)
    sw_ray_attacks = gen_directional_rays(-1, 1)
    w_ray_attacks = gen_directional_rays(-1, 0)

    ray_attacks.push(nw_ray_attacks)
    ray_attacks.push(n_ray_attacks)
    ray_attacks.push(ne_ray_attacks)
    ray_attacks.push(e_ray_attacks)
    ray_attacks.push(se_ray_attacks)
    ray_attacks.push(s_ray_attacks)
    ray_attacks.push(sw_ray_attacks)
    ray_attacks.push(w_ray_attacks)

    ray_attacks
  end

  private

  def gen_directional_rays(x_move, y_move)
    board_bounds = get_board_bounds

    # This offset is added to the indices of board_bounds to account for
    # the sentinel values
    sentinel_offset = 2

    # Used to shift a bit into a ray bitboard
    # Its offset is determined by the values in the board_bounds array to
    # properly set the ray bitboard
    shift = 63

    # Return value
    directional_rays = []

    8.times do |i|
      8.times do |j|
        ray = 0
        square = [i + sentinel_offset, j + sentinel_offset] # [x, y]
        loop do
          square[0] += x_move
          square[1] += y_move
          shift_offset = board_bounds[square[0]][square[1]]
          break if shift_offset.nil?
          ray |= (1 << (shift - shift_offset))
        end
        directional_rays.push(ray)
      end
    end

    directional_rays
  end

  def get_board_bounds
    [[nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, 0,   1,   2,   3,   4,   5,   6,   7,   nil, nil],
    [nil, nil, 8,   9,   10,  11,  12,  13,  14,  15,  nil, nil],
    [nil, nil, 16,  17,  18,  19,  20,  21,  22,  23,  nil, nil],
    [nil, nil, 24,  25,  26,  27,  28,  29,  30,  31,  nil, nil],
    [nil, nil, 32,  33,  34,  35,  36,  37,  38,  39,  nil, nil],
    [nil, nil, 40,  41,  42,  43,  44,  45,  46,  47,  nil, nil],
    [nil, nil, 48,  49,  50,  51,  52,  53,  54,  55,  nil, nil],
    [nil, nil, 56,  57,  58,  59,  60,  61,  62,  63,  nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]]
  end
end