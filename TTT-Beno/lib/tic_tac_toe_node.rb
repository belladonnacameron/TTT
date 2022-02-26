require_relative 'tic_tac_toe'

class TicTacToeNode

  attr_reader :board, :next_mover_mark
  attr_accessor :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
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
      self.children.all? { |child| child.losing_node?(evaluator) }
    else
      # Recursive case 2 (opponent's turn)
      self.children.any? { |child| child.losing_node?(evaluator) }
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
      self.children.any? { |child| child.winning_node?(evaluator) }
    else
      # Recursive case 2 (opponent's turn)
      self.children.all? { |child| child.winning_node?(evaluator) }
    end
  end
  
  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    children_arr = []
    # iterate through all empty? positions on board instance
    (0..2).each do |row|
      (0..2).each do |col|
        pos = [row, col]
        next unless board.empty?(pos) # can't move here if pos isn't empty
        # for each empty pos create a new node by duping the board
        new_board = board.dup
        # add a next_mover_mark in the position
        new_board[pos] = self.next_mover_mark
        # alternate next_mover_mark so players switch properly
        next_mover_mark = (self.next_mover_mark == :x ? :o : :x)
        # set prev_move_pos to the position you just marked
        self.prev_move_pos = pos
        # add new child instance to children array
        children_arr << TicTacToeNode.new(new_board, next_mover_mark, prev_move_pos)
      end
    end
    # return nodes representing all potential game states one move after current the node
    children_arr
  end

end