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
      src_dest = get_input
      move = @board.generate_move(src_dest, @color)
      next if move.nil?
      next unless @board.legal_move?(move)
      @board.make_move(move)
      if @board.in_check?(@color)
        puts 'Invalid move, king is in check'
        @board.undo_move
      else
        switch_color
      end
    end

    puts "#{@color} wins!"
  end

  private

  def get_input
    input = nil
    while input.nil?
      print "#{@color}, enter your move: " 
      input = check_input(gets.chomp.downcase)
    end
    [convert_to_sqaure(input[0, 2]), convert_to_sqaure(input[2, 4])]
  end

  def check_input(input)
    return nil if input.downcase.gsub(/\s+/, '').match(/[a-h][1-8][a-h][1-8]/).nil?
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
