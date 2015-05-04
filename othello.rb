require './resources/board'
require './resources/ai_player'
require 'byebug'

player, board, opponent_color = nil

ARGF.each_with_index do |line, line_number|
  # Take in the game initialization string
  if line_number == 0
    _, player_color, depth_limit, timelimit1, timelimit2 = line.split(' ')

    # Convert the player color to a constant value
    player_color = \
      player_color == 'B' ? OthelloBoard::SPOT_BLACK : OthelloBoard::SPOT_WHITE
    opponent_color = OthelloBoard::opponent_of(player_color)

    board = OthelloBoard.new
    board.debug_mode = true
    player = AIPlayer.new(board, player_color)

    if player_color == OthelloBoard::SPOT_BLACK
      x, y = player.generate_move
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
  x, y = player.generate_move
  board.place(x, y, player.color)
  puts board.to_s
end

