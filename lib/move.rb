# move: { 
#         from_offset: offset, 
#         to_offset: offset, 
#         piece: symbol,
#         color: symbol,
#         cap_piece: symbol,
#         cap_color: symbol
#       }

class Move
  attr_accessor :from_offset, :to_offset, :piece, :color, :cap_piece, :cap_color

  def initialize(from_offset, to_offset, piece, color, cap_piece = nil, cap_color = nil)
    @from_offset = from_offset
    @to_offset = to_offset
    @piece = piece
    @color = color
    @cap_piece = cap_piece
    @cap_color = cap_color
  end
end