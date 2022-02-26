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
    # Base case: game is over and...
    if board.over? 
      # If winner is the opponent, this is a losing node.
      # If winner is nil or us, this is not a losing node.
      return board.won? && board.winner != evaluator
      ## refactored ##
      # if board.over? && board.winner == evaluator || board.winner.nil?
      # return false 
      # else
      #   return true
      # end
    end
    # Recursive case 1 (our turn, all child nodes are losers)
    if self.next_mover_mark == evaluator
      self.children.all? { |child| losing_node?(child) }
    else
      # Recursive case 2 (opponent's turn)
      self.children.any? { |child| losing_node?(child) }
    end
  end
  
  def winning_node?(evaluator)
    # Base case: the board is over AND
    if board.over?
      # If winner is us, this is a winning node.
      # If winner is nil or the opponent, this is not a winning node.
      return board.won? && board.winner == evaluator
    end
    # Recursive case 1 (our turn, have a winning child node)
    if self.next_mover_mark == evaluator
      self.children.any? { |child| winning_node?(child) }
    else
      # Recursive case 2 (opponent's turn)
      self.children.all? { |child| winning_node?(child) }
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
        new_board[pos] = self.next_mover_mark
        # alternate next_mover_mark so players switch properly
        if self.next_mover_mark == :x
          self.next_mover_mark = :o
        else
          self.next_mover_mark = :x
        end
        # set prev_move_pos to the position you just marked
        self.prev_move_pos = pos
        # add new child instance to children array
        children < TicTacToeNode.new(new_board,next_mover_mark, prev_move_pos)
    end
    # return nodes representing all potential game states one move after current the node
    children
  end
end
