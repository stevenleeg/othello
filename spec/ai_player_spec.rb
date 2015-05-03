require 'spec_helper'

describe AIPlayer do
  before :each do
    @board = OthelloBoard.new
    @player = AIPlayer.new(@board, OthelloBoard::SPOT_BLACK)
  end

  it 'can make a move in a corner' do
    white_points = [
      [2, 1], [2, 5],
      [3, 2],
      [4, 2], [4, 3],
      [5, 2], [5, 4],
      [6, 2], [6, 5],
      [7, 2]
    ]

    black_points = [
      [2, 4],
      [3, 3],
      [3, 4],
      [4, 4],
      [5, 3],
    ]

    @board.mark_points(white_points, OthelloBoard::SPOT_WHITE)
    @board.mark_points(black_points, OthelloBoard::SPOT_BLACK)

    x, y = @player.generate_move
  end

  describe '#legal_moves' do
    it 'produces a list of legal moves on the base board' do
      moves = @player.legal_moves 0, @board
      moves.map! {|x| x[:point] }

      expect(moves).to contain_exactly([3, 2], [2, 3],
                                       [5, 4], [4, 5])
    end
  end
end

