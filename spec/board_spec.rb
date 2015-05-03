require 'spec_helper'
require 'byebug'

describe OthelloBoard do
  before :each do
    @board = OthelloBoard.new
  end

  describe '#new' do
    it 'creates a new board' do
      expect(@board).to be_instance_of(OthelloBoard)
    end
    
    it 'places initial board structure' do
      expect(@board.get(3, 3)).to equal(OthelloBoard::SPOT_WHITE)
      expect(@board.get(4, 3)).to equal(OthelloBoard::SPOT_BLACK)
      expect(@board.get(4, 4)).to equal(OthelloBoard::SPOT_WHITE)
      expect(@board.get(3, 4)).to equal(OthelloBoard::SPOT_BLACK)
    end
  end

  describe '#clone' do
    it 'returns a new board' do
      cloned = @board.clone
      expect(cloned).to be_instance_of(OthelloBoard)
    end

    it 'deep clones the board' do
      cloned = @board.clone

      @board.get(3, 3)
      cloned.mark(3, 3, OthelloBoard::SPOT_BLACK)

      expect(@board.get(3, 3)).to equal(OthelloBoard::SPOT_WHITE)
      expect(cloned.get(3, 3)).to equal(OthelloBoard::SPOT_BLACK)
    end
  end

  it 'Deals with walls correctly' do
    @board.mark_points([[5, 2], [3, 7], [3, 2], [7, 6], [5, 4], [5, 7], [5, 6], [4, 7]], OthelloBoard::SPOT_WHITE)
    @board.mark_points([[2, 3], [4, 4], [2, 4], [3, 4], [3, 3], [7, 4], [6, 5], [3, 6], [7, 3], [6, 3], [5, 3], [4, 3], [0, 5], [1, 5], [2, 5], [3, 5], [4, 5], [5, 5]], OthelloBoard::SPOT_BLACK)

    @board.place(1, 4, OthelloBoard::SPOT_WHITE)

    expect(@board.get(0, 5)).to be(OthelloBoard::SPOT_BLACK)
  end
end

