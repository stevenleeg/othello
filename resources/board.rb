class OthelloBoard
  attr_accessor :debug_mode
  attr_reader :white_count, :black_count
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
  def initialize
    @board = []
    8.times do
      col = []
      8.times do
        col << SPOT_OPEN
      end
      @board << col
    end

    @black_count, @white_count = 0, 0

    # Add the starting pieces
    mark(3, 3, SPOT_WHITE)
    mark(4, 3, SPOT_BLACK)
    mark(4, 4, SPOT_WHITE)
    mark(3, 4, SPOT_BLACK)

  end

  ##
  # Getter/setters
  #
  def mark(x, y, val)
    @board[y][x] = val

    if val == SPOT_BLACK
      @black_count += 1
    elsif val == SPOT_WHITE
      @white_count += 1
    end

    if debug_mode
      puts "[INFO] Marked #{x}, #{y} as #{OthelloBoard.spot_to_s(val)}"
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
    mark(place_x, place_y, player)

    opponent = (player == SPOT_BLACK) ? SPOT_WHITE : SPOT_BLACK
    flipper = Proc.new do |points, direction|
      streak = []
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
          break
        end
      end

      # Flip over all of the spots in the streak
      if streak.length > 0
        streak.map { |point| mark(point[0], point[1], player) }
      end
    end

    if debug_mode
      puts "[INFO] Placing #{OthelloBoard.spot_to_s(player)} on (#{place_x}, #{place_y})"
      enumerate_around(place_x, place_y, flipper)
      puts self.to_s
    else
      enumerate_around(place_x, place_y, flipper)
    end
  end

  # Takes in a proc and iterates through spots in each direction from the
  # starting point.
  def enumerate_around(start_x, start_y, func)
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
      until (x < 0 or x > 7) or (y < 0 or y > 7)
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

    str += "Whites: #{@white_count}"
    str += "\nBlacks: #{@black_count}" 

    str
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
end

