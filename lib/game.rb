require './lib/chessboard.rb'

game = Chessboard.new
game.print_knight_moves_at_square(27)

puts ''

game.print_knight_moves_at_square(56)
