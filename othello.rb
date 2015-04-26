require './resources/board'
require './resources/ai_player'
require 'byebug'

board = OthelloBoard.new
board.debug_mode = true
player = nil
opponent_color = nil

ARGF.each_with_index do |line, line_number|
  puts board.to_s

  # Take in the game initialization string
  if line_number == 0
    _, player_color, depth_limit, timelimit1, timelimit2 = line.split(' ')

    # Convert the player color to a constant value
    player_color = \
      player_color == 'B' ? OthelloBoard::SPOT_BLACK : OthelloBoard::SPOT_WHITE
    opponent_color = \
      player_color == 'W' ? OthelloBoard::SPOT_BLACK : OthelloBoard::SPOT_WHITE

    player = AIPlayer.new(board, player_color)

    if player_color == OthelloBoard::SPOT_BLACK
      # TODO: If the player is black then make the first move
    end
    next
  end
  
  # Read in our opponant's next move and respond with our own
  x, y = line.split(' ').map(&:to_i)
  board.place(x, y, opponent_color)
end

