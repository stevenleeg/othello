class AIPlayer
  attr_reader :color, :debug_mode

 	##
  # Constant
  #

  # Definining Infinity Values to be used in Minimax algorithm
  NEGATIVE_INFINITY = -1/0.0
  POSITIVE_INFINITY = 1/0.0

  def initialize(board, color)
    @board = board
    @color = color
  end

  # Temporary shit to test board cloning.  Will delete soon

  def print_clone
  	#clone = @board.clone
  	clone = Marshal.load(Marshal.dump(@board)) 
  	clone.place(1, 1, @color)
  	puts "Clone WP: #{clone.white_points}"
  	puts "Clone BP: #{clone.black_points}"
  end

  ## Haven't actually tested this last part yet since I need to create the Minimax function

  # Root of Minimax search tree.  Looks at all possible
  # AI moves, runs the minimax algorithm on each tree and
  # chooses 
  def get_move
  	moves = legal_moves

  	max_player = false
  	best_move = 0
  	best_score = NEGATIVE_INFINITY

  	# Base cases: 0 legal moves - Pass
  	#             1 Legal move  - Return move

  	if moves.nil?
  		return nil
  	elsif moves.length == 1
  		return moves.last[:point]
  	else
			
  		states = []

			for i in 0..moves.length
				clone = Marshal.load(Mashal.dump(@board)) # TEMPORARY UNTIL WE CAN FIX CLONE METHOD
				x_point, y_point = moves.at(i)[:point].first, moves.at(i)[:point].last
				clone.place(x_point, y_point, @color)
				states << { state: clone, score: moves.at(i)[:score] }
				# Append new state to the list of states.  Add a score to that specified state
			end

			# States.length should be the same as moves.length
			assert_equal(moves.length, states.length, 'Error: Number of possible states is not equal to the number of legal moves')

			for i in 0..states.length
				# Use Minimax to find the best move
				# TO DO - Use ARGF depth argument for depth
				score = minimax(4, states.at(i), max_player)  # Using depth of 4 as temporary for now. 

				# Assign the best move equal to the current index so we can reference it later
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
  		# Return Score
  		return board[:score]
  	end

  	# If the tree is looking at the AI player's moves
  	if maximizing_player
  		best_score = NEGATIVE_INFINITY



  	else # We are looking at the human player's moves
  		best_score = POSITIVE_INFINITY

  	end	

  end

  def generate_move
    moves = legal_moves.sort { |x, y| x[:score] <=> y[:score] }
    return moves.last[:point]
  end


  ## TODO: Add parameter for legal_moves so we can generate legal moves for the player too

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

