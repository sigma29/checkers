require 'byebug'
require 'colorize'
require_relative 'board'

class Piece
  UP_DELTAS = [
    [-1, 1],
    [ 1, 1]
  ]
  DOWN_DELTAS = [
    [ 1,-1],
    [-1,-1]
  ]
  PIECE_DELTAS = {
    :red => UP_DELTAS,
    :black => DOWN_DELTAS
  }

  Y_COORD_FOR_KING = {
    :red => 7,
    :black => 0
  }

  attr_reader :color, :board
  attr_accessor :position
  attr_writer :is_king

  def initialize(color,position,board)
    @color, @position, @board = color, position, board
    @is_king = false
    board.add_piece(position,self)
  end

  def is_king?
    @is_king
  end

  def perform_slide(end_pos)
    return false unless slide_positions.include?(end_pos)

    board[position] = nil
    self.position = end_pos
    board[end_pos] = self
    self.is_king = true if make_king?

    true
  end

  #private

  def move_diffs
    if is_king?
      UP_DELTAS + DOWN_DELTAS
    else
      PIECE_DELTAS[color]
    end
  end

  def slide_positions
    x, y = position

    move_diffs.each_with_object([]) do |(dx, dy), moves|
      new_pos = [x + dx, y + dy]
      next unless board.available?(new_pos)
      moves << new_pos
    end
  end

  def jump_positions
    x, y = position

    move_diffs.each_with_object([]) do |(dx, dy), moves|
      middle_pos = [x + dx, y + dy]
      new_pos = [x + 2 * dx, y + 2 * dy]
      next unless board.available?(new_pos)
      next unless board.has_opponent_piece?(middle_pos,color)
      moves << new_pos
    end
  end

  def make_king?
    return false if is_king?

    _, y = position

    y == Y_COORD_FOR_KING[color]
  end

  def inspect
    {
      :position => position,
      :color => color,
      :is_king => is_king?
    }.inspect
  end

  def render
    if is_king?
      color == :red ? "K".colorize(:red) : "K"
    else
      color == :red ? "O".colorize(:red) : "O"
    end
  end

end
