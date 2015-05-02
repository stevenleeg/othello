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
  	moves = legal_moves(0, @board)

  	max_player = true
  	best_move = 0
  	best_score = NEGATIVE_INFINITY

  	# Base cases: 0 legal moves - Pass
  	#             1 Legal move  - Return move

  	if moves.empty?
  		return nil
  	elsif moves.length == 1
  		return moves.last[:point]
  	else
			
      puts "moves.length: #{moves.length}"
      #puts "legal moves: #{moves}"
      #exit 0

  		states = []

			for i in 0..moves.length-1
				clone = Marshal.load(Marshal.dump(@board)) # TEMPORARY UNTIL WE CAN FIX CLONE METHOD
				x_point, y_point = moves.at(i)[:point].first, moves.at(i)[:point].last
				clone.place(x_point, y_point, @color)
        puts clone.to_s
				states << { state: clone, score: moves.at(i)[:score] }
				# Append new state to the list of states.  Add a score to that specified state
			end

			# States.length should be the same as moves.length
			#assert_equal(moves.length, states.length, 'Error: Number of possible states is not equal to the number of legal moves')

			for i in 0..states.length-1
        puts "Moving to AI Move: #{i}"
				# Use Minimax to find the best move
				# TO DO - Use ARGF depth argument for depth
				score = minimax(2, states.at(i), max_player)  # Using depth of 4 as temporary for now. 

				# Assign the best move equal to the current index so we can reference it later
				if score > best_score
					best_score = score
					best_move = i
				end
			end 
		end

		return moves.at(best_move)[:point]
  end

  def minimax(depth, current_board, maximizing_player)
    puts "call minimax(#{depth}, current_board, maximizing_player: #{maximizing_player})"
  	# Base Case: only one move possible
  	if depth == 0
      puts "depth = 0, retuning board score"
  		return current_board[:score]
  	end

  	# If the tree is looking at the AI player's moves
  	if maximizing_player

      puts "maximizing_player, current_board:"
      puts "#{current_board[:state].to_s}"

  		best_score = NEGATIVE_INFINITY

      # ERROR: Legal Moves is not generating moves for the player
      # Generates possible moves for the human player
      opponent_moves = legal_moves(1, current_board[:state])
      puts "maximizing_player, legal_moves: #{legal_moves(1, current_board[:state])}"

      if opponent_moves.empty?
        puts "Maximizing_Player: No moves for !"
        return current_board[:score]
      else
        # Generate possible board states for the human player's moves
        for i in 0..opponent_moves.length-1
          clone = Marshal.load(Marshal.dump(current_board[:state]))
          x_point, y_point = opponent_moves.at(i)[:point].first, opponent_moves.at(i)[:point].last
          if @color = OthelloBoard::SPOT_BLACK
            clone.place(x_point, y_point, OthelloBoard::SPOT_WHITE)
          else
            clone.place(x_point, y_point, OthelloBoard::SPOT_BLACK)
          end
          clone_board = { state: clone, score: opponent_moves.at(i)[:score] }
          generated_score = minimax(depth-1, clone_board, !maximizing_player)
          best_score = [best_score, generated_score].max
        end
      end

      return best_score

    # We are looking at the Human player's moves
  	else 
  		best_score = POSITIVE_INFINITY
      # Generates possible moves for the AI player
      puts "minimizing_player, current_board:"
      puts "#{current_board[:state].to_s}"
      opponent_moves = legal_moves(0, current_board[:state])

      if opponent_moves.nil?
        return current_board[:score]
      else
        for i in 0..opponent_moves.length-1
          clone = Marshal.load(Marshal.dump(current_board[:state]))
          x_point, y_point = opponent_moves.at(i)[:point].first, opponent_moves.at(i)[:point].last
          clone.place(x_point, y_point, @color)
          clone_board = { state: clone, score: opponent_moves.at(i)[:score] }

          generated_score = minimax(depth-1, clone_board, maximizing_player)
          best_score = [best_score, generated_score].min
        end
      end

      return best_score
  	end	

  end

  def generate_move
    moves = legal_moves(0, @board).sort { |x, y| x[:score] <=> y[:score] }
    return moves.last[:point]
  end


  ## ERROR: Generating duplicate points...
  # Generates legal moves for the specified player
  # Takes in an integer and the current board state:
  #   0 - AI Player
  #   1 - Human Player

  private
  def legal_moves(player, board)

    # If AI specified, generate moves based on player points
    if player == 0
      if @color = OthelloBoard::SPOT_BLACK
        opponent_points = board.white_points
      else
        opponent_points = board.black_points
      end
    # If player specified, generate moves based on AI points
    else
      if @color = OthelloBoard::SPOT_BLACK
        opponent_points = board.black_points
      else
        opponent_points = board.white_points
      end
    end

    moves = []
    opponent_points.each do |point|
      x, y = point

      enumerator = Proc.new do |points, direction|
        next if points.length == 0

        x, y = points.first
        if board.get(x, y) != OthelloBoard::SPOT_OPEN
          next
        end

        if added = board.valid_move?(x, y, @color)
          #if !moves[:point].include? [x, y]
          moves << { point: [x, y], score: added }
          #end
        end
      end

      board.enumerate_around(x, y, enumerator, 1)
    end

    return moves
  end
end

