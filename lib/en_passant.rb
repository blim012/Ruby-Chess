module En_Passant
  def en_passant_cap_square
    @en_passant_cap_square ||= 0 
  end

  def en_passant_pawn_square
    @en_passant_pawn_square ||= 0
  end

  def en_passantable?(move) 
    return false unless move.piece == :pawn
    return false unless (move.from_offset - move.to_offset).abs == 16
    true
  end

  def set_en_passantable_attr(move)
    take_offset = (move.color == :white ? 8 : -8)
    @en_passant_cap_square = move.to_offset + take_offset
    @en_passant_pawn_square = move.to_offset
  end

  def update_en_passantable(move)
    return set_en_passantable_attr(move) if en_passantable?(move)
    @en_passant_cap_square = 0
    @en_passant_pawn_square = 0
  end

  def get_en_passant_cap_square_BB
    1 << (63 - en_passant_cap_square)
  end

  def get_en_passant_pawn_square_BB
    1 << (63 - en_passant_pawn_square)
  end
end