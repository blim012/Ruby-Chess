# Generates all possible moves for a piece, assuming that
# the piece is the only piece on the board.
# This data is preloaded before the game begins
module Gen_Pseudo_Moves
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
    n_ray_attacks = gen_directional_rays(-1, 0)
    ne_ray_attacks = gen_directional_rays(-1, 1)
    e_ray_attacks = gen_directional_rays(0, 1)
    se_ray_attacks = gen_directional_rays(1, 1)
    s_ray_attacks = gen_directional_rays(1, 0)
    sw_ray_attacks = gen_directional_rays(1, -1)
    w_ray_attacks = gen_directional_rays(0, -1)

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

  def gen_knight_attacks
    board_bounds = get_board_bounds

    # This offset is added to the indices of board_bounds to account for
    # the sentinel values
    sentinel_offset = 2

    # Used to shift a bit into a knight bitboard
    # Its offset is determined by the values in the board_bounds array to
    # properly set the knight bitboard
    shift = 63

    # Return value
    knight_attacks = []

    8.times do |i|
      8.times do |j|
        x = sentinel_offset + i
        y = sentinel_offset + j
        shift_offset_y_plus_2 = board_bounds[x][y + 2]
        shift_offset_x_plus_2 = board_bounds[x + 2][y]
        shift_offset_y_minus_2 = board_bounds[x][y - 2]
        shift_offset_x_minus_2 = board_bounds[x - 2][y]
        knight_bitboard = 0
        
        unless shift_offset_y_plus_2.nil?
          shift_offset = board_bounds[x - 1][y + 2]
          knight_bitboard |= (1 << (shift - shift_offset)) unless shift_offset.nil?
          shift_offset = board_bounds[x + 1][y + 2]
          knight_bitboard |= (1 << (shift - shift_offset)) unless shift_offset.nil?
        end

        unless shift_offset_x_plus_2.nil?
          shift_offset = board_bounds[x + 2][y - 1]
          knight_bitboard |= (1 << (shift - shift_offset)) unless shift_offset.nil?
          shift_offset = board_bounds[x + 2][y + 1]
          knight_bitboard |= (1 << (shift - shift_offset)) unless shift_offset.nil?
        end

        unless shift_offset_y_minus_2.nil?
          shift_offset = board_bounds[x - 1][y - 2]
          knight_bitboard |= (1 << (shift - shift_offset)) unless shift_offset.nil?
          shift_offset = board_bounds[x + 1][y - 2]
          knight_bitboard |= (1 << (shift - shift_offset)) unless shift_offset.nil?
        end

        unless shift_offset_x_minus_2.nil?
          shift_offset = board_bounds[x - 2][y - 1]
          knight_bitboard |= (1 << (shift - shift_offset)) unless shift_offset.nil?
          shift_offset = board_bounds[x - 2][y + 1]
          knight_bitboard |= (1 << (shift - shift_offset)) unless shift_offset.nil?
        end

        knight_attacks.push(knight_bitboard)
      end
    end

    knight_attacks
  end

  def gen_king_attacks
    board_bounds = get_board_bounds

    # This offset is added to the indices of board_bounds to account for
    # the sentinel values
    sentinel_offset = 2

    # Used to shift a bit into a king bitboard
    # Its offset is determined by the values in the board_bounds array to
    # properly set the king bitboard
    shift = 63

    # Return value
    king_attacks = []

    8.times do |i|
      8.times do |j|
        king_bitboard = 0
        x = sentinel_offset + i
        y = sentinel_offset + j

        nw_shift_offset = board_bounds[x - 1][y - 1]
        n_shift_offset = board_bounds[x][y - 1]
        ne_shift_offset = board_bounds[x + 1][y - 1]
        e_shift_offset = board_bounds[x + 1][y]
        se_shift_offset = board_bounds[x + 1][y + 1]
        s_shift_offset = board_bounds[x][y + 1]
        sw_shift_offset = board_bounds[x - 1][y + 1]
        w_shift_offset = board_bounds[x - 1][y]

        king_bitboard |= (1 << (shift - nw_shift_offset)) unless nw_shift_offset.nil?
        king_bitboard |= (1 << (shift - n_shift_offset)) unless n_shift_offset.nil?
        king_bitboard |= (1 << (shift - ne_shift_offset)) unless ne_shift_offset.nil?
        king_bitboard |= (1 << (shift - e_shift_offset)) unless e_shift_offset.nil?
        king_bitboard |= (1 << (shift - se_shift_offset)) unless se_shift_offset.nil?
        king_bitboard |= (1 << (shift - s_shift_offset)) unless s_shift_offset.nil?
        king_bitboard |= (1 << (shift - sw_shift_offset)) unless sw_shift_offset.nil?
        king_bitboard |= (1 << (shift - w_shift_offset)) unless w_shift_offset.nil?

        king_attacks.push(king_bitboard)
      end
    end

    king_attacks
  end

  def gen_w_pawn_attacks
    gen_pawn_attacks('white')
  end

  def gen_b_pawn_attacks
    gen_pawn_attacks('black')
  end

  private

  def gen_pawn_attacks(color)
    row_offset = (color === 'white' ? -1 : 1)
    starting_row = (color === 'white' ? 6 : 1)

    board_bounds = get_board_bounds
    sentinel_offset = 2
    shift = 63
    pawn_attacks = []

    8.times do |i| 
      8.times do |j|
        pawn_bitboard = 0
        row = sentinel_offset + i
        column = sentinel_offset + j

        nw_shift_offset = board_bounds[row + row_offset][column - 1]
        n_shift_offset = board_bounds[row + row_offset][column]
        ne_shift_offset = board_bounds[row + row_offset][column + 1]

        if i == starting_row
          n_two_shift_offset = board_bounds[row + (row_offset * 2)][column]
          pawn_bitboard |= (1 << (shift - n_two_shift_offset))
        end

        pawn_bitboard |= (1 << (shift - nw_shift_offset)) unless nw_shift_offset.nil?
        pawn_bitboard |= (1 << (shift - n_shift_offset)) unless n_shift_offset.nil?
        pawn_bitboard |= (1 << (shift - ne_shift_offset)) unless ne_shift_offset.nil? 
        
        pawn_attacks.push(pawn_bitboard)
      end
    end

    pawn_attacks
  end

  def gen_directional_rays(row_offset, column_offset)
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
        ray_bitboard = 0
        row = sentinel_offset + i
        column = sentinel_offset + j
        loop do
          row += row_offset
          column += column_offset
          shift_offset = board_bounds[row][column]
          break if shift_offset.nil?
          ray_bitboard |= (1 << (shift - shift_offset))
        end
        directional_rays.push(ray_bitboard)
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