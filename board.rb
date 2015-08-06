require 'byebug'
require_relative 'piece'

class Board
  BOARD_SIZE = 8
  attr_accessor :grid

  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos,value)
    x,y = pos
    grid[x][y] = value
  end
  
end
