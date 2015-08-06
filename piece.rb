require 'byebug'
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

end
