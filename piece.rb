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
  end

  def is_king?
    @is_king
  end

  def move_diffs
    if is_king?
      UP_DELTAS + DOWN_DELTAS
    else
      PIECE_DELTAS[color]
    end
  end
end
