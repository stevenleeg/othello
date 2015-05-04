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
  def get_move(depth = 3)
    moves = legal_moves(@color, @board)

    # If we have 0 moves, pass. 1 moves, poop that out.
    if moves.empty?
      return nil
    elsif moves.length == 1
      return moves.first[:point]
    end

    moves.map do |move|
      clone = @board.clone
      x, y = move[:point]
      score = clone.place(x, y, @player)

      minimax(
        depth: depth,
        board: clone,
        score: score,
        player: OthelloBoard::opponent_of(@player)
      )
      
      { point: move[:point], score: score }
    end

    moves.sort! { |x, y| x[:score] <=> y[:score] }
    return moves.last[:point] # TODO
  end

  def minimax(options = {})
    puts "[INFO] minimax(depth: #{options[:depth]})"
    if options[:depth] == 0
      puts "[INFO] Depth 0. Returning score #{options[:score]}"
      return options[:score]
    end

    moves = legal_moves(options[:player], options[:board])
    if moves.length == 0
      puts "[INFO] Out of moves. Returning score #{options[:score]}"
      return options[:score]
    end

    scores = []
    moves.each do |move|
      scratch = options[:board].clone
      x, y = move[:point]
      new_score = scratch.place(x, y, options[:player])
      # Stop if we can't legally place this move
      next unless new_score == false

      new_score *= (@player == options[:player]) ? 1 : -1

      scores << minimax(
        depth: options[:depth] - 1,
        board: scratch,
        score: options[:score] + new_score,
        player: OthelloBoard::opponent_of(options[:player])
      )
    end

    scores.sort!
    if @player == options[:player]
      # Maximize
      puts "[INFO] Got em. Returning max score #{scores.last}"
      scores.last
    else
      # Minimixing player minimizes
      puts "[INFO] Got em. Returning min score #{scores.first}"
      scores.first
    end
  end

  def generate_move
    moves = legal_moves(@color, @board).sort { |x, y| x[:score] <=> y[:score] }
    return moves.last[:point]
  end


  ## ERROR: Generating duplicate points...
  # Generates legal moves for the specified player
  # Takes in an integer and the current board state:
  #   0 - AI Player
  #   1 - Human Player

  def legal_moves(player, board)
    opp = OthelloBoard.opponent_of(player)
    if opp == OthelloBoard::SPOT_BLACK
      opponent_points = board.black_points
    else
      opponent_points = board.white_points
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
          moves << { point: [x, y], score: added }
        end
      end

      board.enumerate_around(x, y, enumerator, 1)
    end

    return moves
  end
end

