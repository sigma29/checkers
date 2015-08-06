require 'byebug'
require_relative 'board'

class Piece
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
end
