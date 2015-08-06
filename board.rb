require 'byebug'
require_relative 'piece'

class Board
  BOARD_SIZE = 8
  def self.on_board?(pos)
    pos.all? { |coordinate| coordinate.between?(0, BOARD_SIZE - 1) }
  end

  attr_accessor :grid

  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
  end

  def add_piece(pos,piece)
    self[pos] = piece
  end

  def remove_piece(pos)
    self[pos] = nil
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos,value)
    x,y = pos
    grid[x][y] = value
  end

  def empty?(pos)
    self[pos] == nil
  end

  def available?(pos)
    Board.on_board?(pos) && empty?(pos)
  end

  def has_opponent_piece?(pos,color)
    !empty?(pos) && self[pos].color != color
  end



end
