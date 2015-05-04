require './resources/board'
require './resources/ai_player'

player, depth_limit, board, opponent_color, timelimit1, timelimit2, time_remaining, game_type = nil

ARGF.each_with_index do |line, line_number|
  # Take in the game initialization string
  if line_number == 0
    game_type, player_color, depth_limit, timelimit1, timelimit2 = line.split(' ')

    # Convert input to integers
    depth_limit = depth_limit.to_i
    depth_limit = depth_limit == 0 ? 10 : depth_limit
    timelimit1 = timelimit1.to_f / 1000 # Convert ms to s
    timelimit2 = timelimit2.to_i
    time_remaining = timelimit2

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
      stopwatch = Time.now
      x, y = player.get_move(depth_limit, timelimit1)
      time_remaining -= (stopwatch - Time.now) * 1000
      board.place(x, y, player_color)
      puts "#{x} #{y}"

      puts board.to_s if game_type == 'text'
    else
      puts board.to_s if game_type == 'text'
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
    board.place(x, y, opponent_color)
    puts board.to_s if game_type == 'text'
  end

  # Are we out of time?
  if timelimit2 > 0 and time_remaining <= 0
    puts 'pass'
    next
  end

  # Run our move
  stopwatch = Time.now
  move = player.get_move(depth_limit, timelimit1)

  if timelimit2 > 0
    time_remaining -= (Time.now - stopwatch) * 1000

    # Did we go over during this turn?
    if time_remaining <= 0
      puts 'pass'
      next
    end
    puts "#{time_remaining} left"
  end

  if move == nil
    puts 'pass'
  else
    x, y = move
    board.place(x, y, player.color)
    puts "#{x} #{y}"
    puts board.to_s if game_type == 'text'
  end
end

