require 'byebug'
require_relative 'piece'
require_relative 'board'

class Checkers
  attr_reader :board
  attr_accessor :current_player

  def initialize()
    @board = Board.new(true)
    @red_player = HumanPlayer.new(:red)
    @black_player = HumanPlayer.new(:black)
    @current_player = black_player
  end
end

class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end
  
end
