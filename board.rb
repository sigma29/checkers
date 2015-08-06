require 'byebug'
require_relative 'piece'

class Board
  BOARD_SIZE = 8
  def self.on_board?(pos)
    pos.all? { |coordinate| coordinate.between?(0, BOARD_SIZE - 1) }
  end

  attr_accessor :grid

  def initialize(setup = false)
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

  def dup
    new_board = Board.new
    pieces.each {|piece| piece.dup(new_board)}

    new_board
  end

  def add_piece(pos,piece)
    self[pos] = piece
  end

  def remove_piece(pos)
    self[pos] = nil
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

  def pieces
    grid.flatten.compact
  end

  def render
    display_board = grid.transpose.reverse
    display_board.each_with_index do |row, row_num|
      print "#{BOARD_SIZE - row_num - 1}  "
      row.each do |element|
        if element
          print " #{element.render} "
        else
          print " _ "
        end
      end
      print "\n"
    end
    puts "    0  1  2  3  4  5  6  7"
  end

end
