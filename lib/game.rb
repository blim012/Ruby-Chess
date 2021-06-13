require './lib/chessboard.rb'

game = Chessboard.new
game.print_king_moves_at_square(14)

puts ''

game.print_king_moves_at_square(63)
