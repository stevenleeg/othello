class OthelloBoard
  attr_accessor :debug_mode, :board, :white_points, :black_points
  ##
  # Constants
  #

  # Represent various states of spots on the board (used in @board)
  SPOT_OPEN = 0
  SPOT_BLACK = 1
  SPOT_WHITE = 2

  # Compass directions
  #     NW  N  NE
  #      W  S  E
  #     SW  S  SE
  DIRECTION_NORTH     = 0
  DIRECTION_NORTHEAST = 1
  DIRECTION_EAST      = 2
  DIRECTION_SOUTHEAST = 3
  DIRECTION_SOUTH     = 4
  DIRECTION_SOUTHWEST = 5
  DIRECTION_WEST      = 6
  DIRECTION_NORTHWEST = 7
  DIRECTIONS = [0, 1, 2, 3, 4, 5, 6, 7]

  # Initialize the board's starting configuration
  def initialize(empty = false)
    @white_points = []
    @black_points = []
    return if empty

    @board = []
    8.times do
      col = []
      8.times do
        col << SPOT_OPEN
      end
      @board << col
    end

    # Add the starting pieces
    mark(3, 3, SPOT_WHITE)
    mark(4, 3, SPOT_BLACK)
    mark(4, 4, SPOT_WHITE)
    mark(3, 4, SPOT_BLACK)
  end

  ##
  # Getter/setters
  #
  def mark_points(points, player)
    points.each do |point|
      x, y = point

      mark(x, y, player)
    end
  end
  
  def mark(x, y, val)
    @board[y][x] = val

    if val == SPOT_BLACK
      @black_points << [x, y]
      @white_points.delete [x, y]
    elsif val == SPOT_WHITE
      @white_points << [x, y]
      @black_points.delete [x, y]
    end
  end

  def get(x, y)
    @board[y][x]
  end

  
  # Places a piece of the color given by the player argument (should be of type
  # SPOT_BLACK or SPOT_WHITE) onto the board and scans around the point, 
  # flipping pieces in streaks.
  #
  # This basically does what you (as a human) would do while placing a piece on
  # the board. Use this instead of mark if you're making moves.
  def place(place_x, place_y, player)
    opponent = OthelloBoard::opponent_of(player)

    mark(place_x, place_y, player)

    adds_points = 0
    flipper = Proc.new do |points, direction|
      streak = []
      reached_player = false
      points.each_with_index do |point, i|
        x, y = point

        # If we see an opponant we add it to their streak (basically a list of
        # points that we're going to later flip if we run into our own color
        # later in the scan). If we ever run into an open spot we just stop, as
        # there's no flipping we'd need to do.
        spot = get(x, y)
        case spot
        when opponent
          streak << point
        when SPOT_OPEN
          streak = []
          break
        when player
          reached_player = true
          break
        end
      end

      # Flip over all of the spots in the streak
      if streak.length > 0 and reached_player
        streak.map do |point|
          adds_points += 1
          mark(point[0], point[1], player)
        end
      end
    end

    enumerate_around(place_x, place_y, flipper)

    return adds_points
  end

  # Given a point and a player return an integer (the number of flips that
  # would result from the move) if the move is valid or false if the move
  # is invalid.
  def valid_move?(start_x, start_y, player)
    return false if get(start_x, start_y) != SPOT_OPEN

    # Counts the total flips that would result from this move
    flips = 0

    opponent = OthelloBoard::opponent_of(player)
    enumerator = Proc.new do |points, direction|
      # Counts the total flips that would result from this direction
      temp_flips = 0
      points.each do |point|
        x, y = point

        case get(x, y)
        when opponent
          temp_flips += 1
        when SPOT_OPEN
          temp_flips = 0
          break
        when player
          flips += temp_flips
          break
        end
      end
    end
    enumerate_around(start_x, start_y, enumerator)

    if flips == 0
      return false
    else
      return flips
    end
  end

  # Takes in a proc and iterates through spots in each direction from the
  # starting point.
  def enumerate_around(start_x, start_y, func, i = 0)
    movements = {
      DIRECTION_NORTH:     [ 0, -1],
      DIRECTION_NORTHEAST: [ 1, -1],
      DIRECTION_EAST:      [ 1,  0],
      DIRECTION_SOUTHEAST: [ 1,  1],
      DIRECTION_SOUTH:     [ 0,  1],
      DIRECTION_SOUTHWEST: [-1,  1],
      DIRECTION_WEST:      [-1,  0],
      DIRECTION_NORTHWEST: [-1, -1]
    }

    movements.each do |direction, movements|
      x, y, points = start_x + movements[0], start_y + movements[1], []
      until (x < 0 or x > 7) or (y < 0 or y > 7) or (i != 0 && points.length == i)
        points << [x, y]
        x += movements[0]
        y += movements[1]
      end
      func.call(points, direction)
    end
  end

  ##
  # Debugging/helper methods
  #
  def to_s
    open = '[ ]'
    marked_black = '[B]'
    marked_white = '[W]'

    str = "   0   1   2   3   4   5   6   7\n"
    @board.each_with_index do |row, x|
      str += "#{x} "
      row.each do |space|
        case space
        when SPOT_OPEN
          str += "#{open} "
        when SPOT_BLACK
          str += "#{marked_black} "
        when SPOT_WHITE
          str += "#{marked_white} "
        end
      end

      str += "\n"
    end

    str += "White: #{@white_points.length}\n"
    str += "Black: #{@black_points.length}\n" 
    str += "White Points: #{@white_points}\n"
    str += "Black Points: #{@black_points}\n"

    str
  end

  def clone
    b = OthelloBoard.new(true)
    b.board = Marshal.load(Marshal.dump(@board))
    b.white_points = Marshal.load(Marshal.dump(@white_points))
    b.black_points = Marshal.load(Marshal.dump(@black_points))

    return b
  end

  ##
  # Class methods
  #
  def self.spot_to_s(val)
      case val
      when SPOT_WHITE
        return 'SPOT_WHITE'
      when SPOT_BLACK
        return 'SPOT_BLACK'
      when SPOT_OPEN
        return 'SPOT_OPEN'
      end
  end

  def self.opponent_of(player)
    (player == SPOT_BLACK) ? SPOT_WHITE : SPOT_BLACK
  end
end
