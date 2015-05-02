require 'spec_helper'

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
end

