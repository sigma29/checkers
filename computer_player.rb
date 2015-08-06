require 'byebug'


class ComputerPlayer
  attr_reader :color, :board

  def initialize(color,board)
    @color = color
    @board = board
  end

  def move_input
    move_sequence = []

    if board.can_capture?(color)
      jumpable_pieces = board.color_pieces(color).select(&:can_capture?)
      piece = jumpable_pieces.sample
      move_sequence << piece.position
      #randomly choose a jump direction
      move_sequence << piece.jump_positions.sample

    else
      slideable_pieces = board.color_pieces(color).select(&:can_slide?)
      piece = slideable_pieces.sample
      move_sequence << piece.position
      #randomly choose a slide direction
      move_sequence << piece.move_positions.sample

    end


    move_sequence
  end
end
