class AIPlayer
  attr_reader :color, :debug_mode

  def initialize(board, color)
    @board = board
    @color = color
  end

  ## Haven't actually tested this last part yet since I need to create the Minimax function

  # Finds the best move out of all legal moves
  # by comparing scores of minimax trees against each other
  def get_move
  	moves = legal_moves

  	max_player = true
  	best_move = 0
  	best_score = -999999999 

  	# Base cases: 0 legal moves - Pass
  	#             1 Legal move  - Return move

  	if moves == nil
  		return nil
  	elsif moves.length == 1
  		return moves.last[:point]
  	else
			
			for i in 0..moves.length

				# Append new state to the list of states.  Add a score to that specified state
			end

			# States.length should be the same as moves.length
			assert_equal(moves.length, states.length, 'Error: Number of possible states is not equal to the number of legal moves')

			for i in 0..states.length
				# Use Minimax to find the best move
				# TO DO - Use ARGF depth argument for depth
				score = minimax(4, states.at(i), max_player)  # Using depth of 4 as temporary for now. 

				if score > best_score
					best_score = score
					best_move = i
				end
			end 
		end

		return moves.at(best_move)[:point]
  end

  def minimax(depth, board, maximizing_player)
  	# Base Case: only one move possible
  	if depth == 0
  		#Return Score
  	end




  end

  def generate_move
    moves = legal_moves.sort { |x, y| x[:score] <=> y[:score] }

    return moves.last[:point]
  end

  private
  def legal_moves
    if @color = OthelloBoard::SPOT_BLACK
      opponent_points = @board.white_points
    else
      opponent_points = @board.black_points
    end

    moves = []
    opponent_points.each do |point|
      x, y = point

      enumerator = Proc.new do |points, direction|
        next if points.length == 0

        x, y = points.first
        if @board.get(x, y) != OthelloBoard::SPOT_OPEN
          next
        end

        if added = @board.valid_move?(x, y, @color)
          moves << { point: [x, y], score: added }
        end
      end

      @board.enumerate_around(x, y, enumerator, 1)
    end

    return moves
  end
end

