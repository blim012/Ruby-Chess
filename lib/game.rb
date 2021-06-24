require './lib/chessboard.rb'

class Game
  def initialize
    @board = Chessboard.new
    @color = :white
    @letter_to_column = {}
    ('a'..'h').zip((0..7)).each { |pair| @letter_to_column[pair[0]] = pair[1] }
  end

  def play
    loop do
      @board.print_board
      break if @board.checkmate?(@color)
      break if @board.stalemate?(@color)
      src_dest = get_input
      move = @board.generate_move(src_dest, @color)
      next if move.nil?
      next unless @board.move_piece(move)
      @board.promotion(@color)
      switch_color
    end

    switch_color
    puts "#{@color} wins!"
  end

  private

  def get_input
    input = nil
    loop do
      print "#{@color}, enter your move: " 
      input = check_input(gets.chomp.downcase)
      break unless input.nil?
    end
    [convert_to_sqaure(input[0, 2]), convert_to_sqaure(input[2, 4])]
  end

  def check_input(input)
    input = input.downcase.gsub(/\s+/, '')
    input = convert_castle_to_move(input)
    return input unless input.match(/[a-h][1-8][a-h][1-8]/).nil?
    puts 'Invalid move, try again' 
    nil
  end

  def convert_castle_to_move(input)
    case input
    when 'ck'
      return (@color == :white ? 'e1g1' : 'e8g8')
    when 'cq'
      return (@color == :white ? 'e1c1' : 'e8c8')
    end
    input
  end

  def convert_to_sqaure(coord)
    column = @letter_to_column[coord[0]]
    row = 8 - coord[1].to_i
    (row * 8) + column
  end

  def switch_color
    @color = (@color == :white ? :black : :white)
  end
end

game = Game.new
game.play
