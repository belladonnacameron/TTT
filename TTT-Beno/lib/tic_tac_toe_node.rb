require_relative 'tic_tac_toe'

class TicTacToeNode

  attr_reader :board
  attr_accessor :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = Board.new
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  
  def losing_node?(evaluator)
  end
  
  def winning_node?(evaluator)
  end
  
  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    children = []
    # iterate through all empty? positions on board instance
    (0..2).each do |row|
      (0..2).each do |col|
        pos = [row, col]
        # can't move here if pos isn't empty
        next if board.empty?(pos) 
        # for each empty pos create a new node by duping the board
        new_board = board.dup
        # add a next_mover_mark in the position
        new_board[pos] = next_mover_mark
        # alternate next_mover_mark so players switch properly
        if next_mover_mark == :x
          next_mover_mark = :o
        else
          next_mover_mark = :x
        end
        # set prev_move_pos to the position you just marked
        prev_move_pos = pos
        # add new child instance to children array
        children < TicTacToeNode.new(new_board,next_mover_mark, prev_move_pos)
    end
    # return nodes representing all potential game states one move after current the node
    children
  end
end
