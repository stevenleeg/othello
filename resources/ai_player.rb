class AIPlayer
  attr_reader :color, :debug_mode

  def initialize(board, color)
    @board = board
    @color = color
  end
  
  def generate_move
    moves = legal_moves.sort { |x, y| x[:score] <=> y[:score] }

    return moves.first[:point]
  end

  private
  def legal_moves
    if @color = OthelloBoard::SPOT_BLACK
      opponent_points = @board.white_points
    else
      opponent_points = @board.black_points
    end

    moves = []
    opponent_points.each do |point|
      x, y = point

      enumerator = Proc.new do |points, direction|
        return if points.length == 0

        x, y = points.first
        if @board.get(x, y) != OthelloBoard::SPOT_OPEN
          next
        end

        if added = @board.valid_move?(x, y, @color)
          moves << { point: [x, y], score: added }
        end
      end

      @board.enumerate_around(x, y, enumerator, 1)
    end

    return moves
  end
end

