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
    @current_player = black_player
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

end
