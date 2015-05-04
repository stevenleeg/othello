require './resources/board'
require './resources/ai_player'

def run_game(depth_limit)
  times = []
  board = OthelloBoard.new
  black = AIPlayer.new(board, OthelloBoard::SPOT_BLACK)
  white = AIPlayer.new(board, OthelloBoard::SPOT_WHITE)
  puts "Running game on depth #{depth_limit}"

  while true
    # Black makes a move
    stopwatch = Time.now
    move = black.get_move(depth_limit)
    times << Time.now - stopwatch

    if move == nil
      almost_end = true
    else
      x, y = move
      board.place(x, y, black.color)
    end

    # White makes a move
    stopwatch = Time.now
    move = white.get_move(depth_limit)
    times << Time.now - stopwatch

    if move == nil and almost_end == true
      puts "Stats for depth #{depth_limit}"
      puts "\tMax: #{times.max}"
      puts "\tMin: #{times.min}"
      puts "\tAve: #{times.reduce(:+) / times.length.to_f}"
      break
    else
      x, y = move
      board.place(x, y, white.color)
    end
  end
end

(1..10).each do |i|
  run_game i
end

