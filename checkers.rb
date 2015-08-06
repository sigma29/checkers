require 'byebug'
require_relative 'piece'
require_relative 'board'

class Checkers
  attr_reader :board
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
      puts "Move sequence: #{move_sequence}"
      board.make_moves(move_sequence)
    rescue InvalidMoveError => e
      puts e.message
      retry
    end
  end

  def opponent
    (current_player == red) ? :black : :red
  end

  def swap_player
    self.current_player = (current_player == red) ? :black : :red
  end

end

class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def move_input
    puts "Enter your desired move sequence"
    gets.chomp
  end
end
