require './lib/move.rb'

module Castle
  @w_king_side = true
  @b_king_side = true
  @w_queen_side = true
  @b_queen_side = true

  # Determines if a given move is a castle
  def castle_move?(move)
    return false unless move.piece == :king
    if move.color == :white
      return false unless move.from_offset == 60 && 
                          (move.to_offset == 62 || move.to_offset == 58)
    else
      return false unless move.from_offset == 4 && 
                          (move.to_offset == 6 || move.to_offset == 2)
    end
    true
  end

  def castleable?(move, occupied_BB, enemy_threat_BB)
    side = get_castle_side(move)
    if side == :king_side
      if move.color == :white
        return false if @w_king_side == false
      else
        return false if @b_king_side == false
      end
    else
      if move.color == :white
        return false if @w_queen_side == false
      else
        return false if @b_queen_side == false
      end
    end

    king_BB = (move.color == :white ? 0x8 : 0x0800000000000000)
    castle_move_BB = 0x3600000000000036
    castle_move_BB &= (move.color == :white ? 0x36 : 0x3600000000000000)
    castle_move_BB &= (side == :king_side ? 0x0600000000000006 : 0x3000000000000030)
    return false unless occupied_BB & castle_move_BB == 0
    return false unless enemy_threat_BB & (castle_move_BB | king_BB) == 0
    true
  end

  def remove_castleable(castle_side, color)
    if castle_side == :king_side
      if color == :white
        @w_king_side = false
      else
        @b_king_side = false
      end
    else
      if color == :white
        @w_queen_side = false
      else
        @b_queen_side = false
      end
    end
  end

  def set_castle_attr(move)
    side = get_castle_side
    @king_src = (move.color == :white ? 60 : 4)
    @king_dest = (side == :king_side ? @king_src + 2 : @king_src - 2)
    set_rook_castle_attr(side, move.color)
  end

  def get_king_castle_move(color)
    Move.new(@king_src, @king_dest, :king, color)
  end

  def get_rook_castle_move
    Move.new(@rook_src, @rook_dest, :rook, color)
  end

  private

  def get_castle_side(move)
    if move.color == :white
      return move.to_offset == 62 ? :king_side : :queen_side
    else
      return side = (move.to_offset == 6 ? :king_side : :queen_side)
    end
  end

  def set_rook_castle_attr(side, color)
    if color == :white
      if side == :king_side
        @rook_src = 63
        @rook_dest = 61
      else
        @rook_src = 56
        @rook_dest = 59
      end
    else
      if side == :king_side
        @rook_src = 7
        @rook_dest = 5
      else
        @rook_src = 0
        @rook_dest = 3
      end
    end
  end
end