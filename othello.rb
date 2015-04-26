require './resources/board'
require 'byebug'

board = OthelloBoard.new
#puts board.to_s

board.place(3, 2, OthelloBoard::SPOT_BLACK)
puts board.to_s

board.place(2, 2, OthelloBoard::SPOT_WHITE)
puts board.to_s

