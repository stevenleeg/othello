require './resources/board'
require './resources/ai_player'
require 'byebug'

player, depth_limit, board, opponent_color, timelimit1, timelimit2 = nil

ARGF.each_with_index do |line, line_number|
  # Take in the game initialization string
  if line_number == 0
    _, player_color, depth_limit, timelimit1, timelimit2 = line.split(' ')

    # Convert input to integers
    depth_limit = depth_limit.to_i
    depth_limit = depth_limit == 0 ? 10 : depth_limit
    timelimit1 = timelimit1.to_f / 1000 # Convert ms to s
    timelimit2 = timelimit2.to_f

    # Convert timelimit 1 to a depth value (easier to track)
    # NOTE: These values came from our own experimentation and are relatively
    #       conservative numbers.
    if timelimit1 > 0
      if timelimit1 <= 1
        depth_limit = 1
      elsif timelimit1 <= 4
        depth_limit = 2
      elsif timelimit1 <= 60
        depth_limit = 3
      else
        depth_limit = 4
      end
    end

    # Convert the player color to a constant value
    player_color = \
      player_color == 'B' ? OthelloBoard::SPOT_BLACK : OthelloBoard::SPOT_WHITE
    opponent_color = OthelloBoard::opponent_of(player_color)

    board = OthelloBoard.new
    board.debug_mode = true
    player = AIPlayer.new(board, player_color)

    if player_color == OthelloBoard::SPOT_BLACK
      x, y = player.get_move(depth_limit, timelimit1)
      board.place(x, y, player_color)
      puts board.to_s
    else
      puts board.to_s
    end
    next
  end
  
  # Read in our opponant's next move and respond with our own
  unless line.strip == 'pass'
    x, y = line.split(' ').map(&:to_i)
    if not (added = board.valid_move?(x, y, opponent_color))
      puts 'Invalid move!'
      next
    end
    puts "[INFO] Move adds #{added} points"
    board.place(x, y, opponent_color)
    puts board.to_s
  end

  # Run our move
  move = player.get_move(depth_limit, timelimit1)

  if move == nil
    puts 'pass'
  else
    x, y = move
    board.place(x, y, player.color)
    puts board.to_s
  end
end

