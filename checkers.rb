require 'byebug'
require_relative 'piece'
require_relative 'board'

class Checkers
  attr_reader :board, :red, :black
  attr_accessor :current_player

  def initialize
    @board = Board.new(true)
    @red = HumanPlayer.new(:red)
    @black = HumanPlayer.new(:black)
    @current_player = @black
  end

  def play

    until board.lost?(current_player.color)
      board.render
      take_turn
      swap_player
    end

    puts "#{opponent.color.upcase} won!"
  end

  private

  def take_turn
    begin
      move_sequence = current_player.move_input
      board.make_moves(move_sequence, current_player.color)
    rescue InvalidMoveError => e
      puts e.message
      retry
    end
  end

  def opponent
    (current_player == red) ? black : red
  end

  def swap_player
    self.current_player = (current_player == red) ? black : red
  end

end

class HumanPlayer
  attr_reader :color

  def initialize(color,board)
    @color = color
    #board passed for duck typing
  end

  def move_input
    puts "#{color.capitalize}, enter a move sequence in the format x,y:x,y:x,y"
    position_chunks = gets.chomp.split(":")
    move_sequence = []

    position_chunks.each do |chunk|
      begin
        x, y = chunk.split(",").map { |coord| Integer(coord)}
      rescue ArgumentError
        raise InvalidMoveError
      else
        move_sequence << [x,y]
      end
    end

    move_sequence
  end
end
