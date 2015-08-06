require 'byebug'
require_relative 'piece'

class Board
  BOARD_SIZE = 8
  COLOR_ROWS = {
    :red => [ 0, 1, 2],
    :black => [5, 6, 7]
  }
  CHECKER_POSITIONS = [
    [1, 3, 5, 7],
    [0, 2, 4, 6]
  ]
  def self.on_board?(pos)
    pos.all? { |coordinate| coordinate.between?(0, BOARD_SIZE - 1) }
  end

  attr_accessor :grid

  def initialize(setup = false)
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    setup_board if setup
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

  def can_capture?(color)
    color_pieces = pieces.select {|piece| piece.color == color}
    color_pieces.any? {|piece| piece.can_capture?}
  end

  def setup_board
    COLOR_ROWS.each do |color, rows|
      rows.each do |row|
        if row % 2 == 0
          checker_positions = CHECKER_POSITIONS[0]
        else
          checker_positions = CHECKER_POSITIONS[1]
        end
        checker_positions.each do |column|
          position = [column, row]
          self[position] = Piece.new(color, position, self)
        end
      end
    end

    self
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
