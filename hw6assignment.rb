# University of Washington, Programming Languages, Homework 6, hw6runner.rb
# Seçkin KÜKRER

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = All_Pieces +
                  [
                    rotations([[0, 0], [0, 1], [1, 0], [1, 1], [2, 1]]), # First piece.
                    rotations([[0, 0], [1, 0], [2, 0], [3, 0], [4, 0]]), # Second piece.
                    rotations([[0, 0], [0, 1], [1, 1]])
                  ]

  # For Cheating
  Cheat_Piece = [
    [[0,0]]
  ]

  # Next Piece implementation
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  # Cheat Piece implementation
  def self.cheat_piece (board)
    MyPiece.new(Cheat_Piece, board)
  end

end

class MyBoard < Board
  # Initializer implementation
  def initialize (game)
    super(game)
    @current_block = MyPiece.next_piece(self)
  end

  # Rotation for 180 degree
  def rotate_U
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  # Store Current for the improper usage of index on the locations
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.size - 1)).each{|index|
      current = locations[index]
      @grid[current[1] + displacement[1]][current[0] + displacement[0]] =
        @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  # Cheating addition
  def next_piece
    if @cheat
      @current_block = MyPiece.cheat_piece(self)
      @cheat = false
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  # Cheating, board implementation
  def cheat_next
    if !@cheat and @score >= 100
      @score -= 100
      @cheat = true
    end
  end
end

class MyTetris < Tetris

  # Since we can't use the parent's method to manage with our little change.
  # We have to implement the whole function with proper Initialization.
  # You can avoid it by changing the Parent's Design with proper
  # Class-Based Oriented Programming principles.
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  # Desired key bindings for enhanced game
  def key_bindings
    super
    @root.bind('u', proc {@board.rotate_U})
    @root.bind('c', proc {@board.cheat_next})
  end

end
