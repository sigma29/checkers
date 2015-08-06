require 'byebug'
require 'colorize'
require_relative 'board'

class Piece
  PIECE_DELTAS = {
    :red => [
            [-1, 1],
            [ 1, 1]
          ],
    :black => [
              [ 1,-1],
              [-1,-1]
              ]
            }

  Y_COORD_FOR_KING = {
    :red => 7,
    :black => 0
  }

  JUMP_DISTANCE = 2

  attr_reader :color, :board
  attr_accessor :position
  attr_writer :king

  def initialize(color,position,board,king = false)
    @color, @position, @board, @king = color, position, board, king
    board.add_piece(position,self)
  end

  def dup(new_board)
    Piece.new(color,position,new_board,king?)
  end

  def king?
    @king
  end

  def perform_move(move_sequence)
    raise InvalidMoveError unless valid_move_sequence?(move_sequence)

    perform_move!(move_sequence)
  end

  def inspect
    {
      :position => position,
      :color => color,
      :king => king?
    }.inspect
  end

  def render
    if king?
      color == :red ? "K".colorize(:red) : "K"
    else
      color == :red ? "O".colorize(:red) : "O"
    end
  end

  protected

  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      move = move_sequence.first
      raise InvalidMoveError unless perform_slide(move) || perform_jump(move)
    else
      until move_sequence.empty?
        curr_move = move_sequence.shift
        raise InvalidMoveError unless perform_jump(curr_move)
      end
    end

    true
  end

  private
  def move_diffs
    if king?
      PIECE_DELTAS[:black] + PIECE_DELTAS[:red]
    else
      PIECE_DELTAS[color]
    end
  end

  def move_positions(distance = 1)
    x, y = position
    moves = []

    move_diffs.each do |(dx, dy)|
      new_position = [x + distance * dx, y + distance * dy]
      next unless board.available?(new_position)
      moves << new_position
    end

    moves
  end

  def make_king?
    return false if king?

    _, y = position

    y == Y_COORD_FOR_KING[color]
  end

  def make_move(end_position)
    board[position] = nil
    self.position = end_position
    board[end_position] = self
    self.is_king = true if make_king?

    self
  end

  def valid_move_sequence?(move_sequence)
    begin
      temp_board = board.dup
      mirror_piece = temp_board[position]
      mirror_piece.perform_moves!(move_sequence)
    rescue InvalidMoveError
      false
    else
      true
    end
  end

  def perform_slide(end_position)
    return false unless move_positions.include?(end_position)

    make_move(end_position)

    true
  end

  def perform_jump(end_position)
    return false unless move_positions(JUMP_DISTANCE).include?(end_position)
    midpoint = middle_position(position,end_position)
    return false unless board.has_opponent_piece?(midpoint,color)

    board.remove_piece(midpoint)
    make_move(end_position)

    true
  end

  def middle_position(start_position, end_position)
    start_x, start_y = start_position
    end_x, end_y = end_position
    middle_x = (start_x + end_x) / 2
    middle_y = (start_y + end_y) / 2

    [middle_x, middle_y]
  end


end

class InvalidMoveError < StandardError
end
