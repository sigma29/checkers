require_relative 'board'
require_relative 'piece'
require_relative 'checkers'
#require_relative 'computer_player'

# c = Checkers.new
# c.play
b = Board.new
k1 = Piece.new(:red,[5,4],b,true)
p1 = Piece.new(:black,[6,3],b)
p2 = Piece.new(:black, [6,1],b)
b.render
tree = FutureMovesTree.construct_move_tree(k1,b)
