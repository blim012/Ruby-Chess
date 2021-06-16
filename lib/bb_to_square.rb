# Associates each set bit in a bitboard to a square
module BB_To_Square
  def find_squares(bitboard)
    squares = []
    until bitboard == 0 do
      lsb = bitboard & -bitboard 
      bitboard ^= lsb
      square = 64 - lsb.bit_length
      squares.push(square)
    end
    squares
  end
end