require './lib/searchable.rb'

module Nonray_Attack
  include Searchable

  def knight_threats(knight_bitboard, knight_attacks)
    nonray_nonpawn_threats(knight_bitboard, knight_attacks)
    #squares.reduce(0) { |threat_BB, square| threat_BB |= knight_attacks[square] }
  end

  def pawn_threats(pawn_bitboard, pawn_attacks)
    threats = {}
    squares = find_squares(pawn_bitboard)
    squares.each do |square|
      square_to_BB = 1 << (63 - square)
      # Clear the entire column of the square of pawn attack you're examining
      forward_move_mask = pawn_attacks[square] & get_pawn_column_mask(square)
      pawn_threat = pawn_attacks[square] ^ forward_move_mask
      threats[square_to_BB] = pawn_threat
    end
    threats
    #squares.reduce(0) do |threat_BB, square| 
    #  forward_move_mask = pawn_attacks[square] & get_pawn_column_mask(square)
    #  threat_BB |= pawn_attacks[square] ^ forward_move_mask
    #end
  end

  def king_threats(king_bitboard, king_attacks)
    nonray_nonpawn_threats(king_bitboard, king_attacks)
    #squares.reduce(0) { |threat_BB, square| threat_BB |= king_attacks[square] }
  end

  def get_pawn_column_mask(square)
    shift_offset = 63 - square
    column = shift_offset % 8
    column_mask = 0
    8.times do
      column_mask |= 1 << column
      column += 8
    end
    column_mask
  end

  private

  def nonray_nonpawn_threats(bitboard, attacks)
    threats = {}
    squares = find_squares(bitboard)
    squares.each do |square|
      square_to_BB = 1 << (63 - square) 
      threats[square_to_BB] = attacks[square]
    end
    threats
  end
end