require_relative 'board'
require_relative 'piece'

class FutureMovesTree
  def self.construct_move_tree(piece, board)
    curr_pos = piece.position
    curr_node = FutureMovesTree.new(board,piece,:generation => 1)
    puts curr_node.inspect
    extend_move_tree(curr_node)

    curr_node
  end

  def self.extend_move_tree(parent)
    curr_pos = parent.piece.position
    parent.piece.jump_positions.each do |jump_pos|
      temp_board = parent.board.dup
      mirror_piece = parent.board[curr_pos]
      mirror_piece.perform_jump(jump_pos)
      child_node = FutureMovesTree.new(temp_board,mirror_piece)
      parent.add_child(child_node)
      puts child_node.inspect
      extend_move_tree(child_node)
    end
  end

  attr_reader :parent,:board,:piece
  attr_accessor :children, :generation

  def initialize(board,piece,options = {})
    @board, @piece = board, piece
    @children = []
    @generation = options[:generation]
    @parent = options[:parent]
  end

  def add_child(child_move)
    self.children << child_move
    child_move.generation == generation + 1
  end

end
