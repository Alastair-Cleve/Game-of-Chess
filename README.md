#Chess

![starting_screen](/images/starting_screen.png)

##Description and Instructions

###Explanation of the Game
This is an interactive, two-person game. You are prompted to select a chess
piece with your keyboard (using the arrow keys, for example). After you select
a piece, you are prompted to select where the piece should move. After you
complete your move, the game toggles to the other player. The game continues
until a player is in checkmate or there are no valid moves.

###How to Run
This is an implementation of Chess in Ruby. To play, download this repository,
save it, and use the command line to navigate to the directory where you saved it.

####Ruby
If you are unsure of whether you have Ruby available on your computer, you can
run:

```bash
ruby -v
```

If you have ruby, you should see something like:

```bash
ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-darwin15.0]
```

If you do not have Ruby installed on your computer, go **[here](https://www.ruby-lang.org/en/)**.

####Ruby Gems
If you do not have the `colorize` or `io/console` gems installed on your computer,
run:

```bash
gem install colorize
gem install io/console
```

**Note:** You may have to use the `sudo` command if you do not have root-level
access, as in:

```bash
sudo gem install colorize
sudo gem install io/console
```

You will be asked to authenticate yourself.

####Command to Run
Finally, to play, run:

```bash
ruby Chess.rb
```

Remember that the white pieces move first.

##Technical Implementation

###Gems
The `colorize` gem is used to provide color to the command line. This gem allows
the chess board to be blue and white and the cursor to be red.

In addition, the `io/console` gem is used. This provides the ability to read
keystroke inputs and is what makes the game interactive.

###Architecture
The game's structure includes a `lib/pieces/` directory, which includes files for each
of the game piece classes, such as bishop, rook, and queen. In addition, the
architecture includes a board file that populates the board and keeps track
of the rules. The keystroke input handling lives in the `Cursorable` file, `Display`
is what takes care of the rendering of the board, and `Chess` controls the
interaction with the command line.

Of particular interest are the modules [Slideable][slideable] and [Steppable][steppable].
The point of these modules is to DRY out the code. Categorizing pieces into
pieces that slide (such as queens and rooks) and pieces that step (such as knights)
allowed me to consolidate the common behaviors of those pieces into modules.
The individual pieces then inherit from those modules as needed:

```ruby
class Knight < Piece
  include Steppable
  .
  .
  .
end
```

Also of interest is how I detect when a piece is in check. In the `Piece` file,
I wrote a method `move_into_check`, which creates a duplicate board, makes a
move, and then calls `in_check?` on the `Board` class.

```ruby
def move_into_check?(move)
  new_board = @board.dup
  new_board.move!(@position, move)
  new_board.in_check?(@color)
end
```

The `dup` method (referenced above in `@board.dup`) is written as follows:

```ruby
def dup
  new_board = Board.new(false)
  @grid.flatten.each do |space|
    if space.is_a?(NullPiece)
      NullPiece.new(new_board, space.position)
    else
      space.class.new(new_board, space.position, space.color)
    end
  end

  new_board
end
```

In `dup`, I create a new board. I then iterate over the current grid, and if a
space on the current grid is empty, I instantiate a NullPiece on the duplicate
grid; otherwise, I duplicate the piece. This allows me to duplicate the current
grid without affecting the underlying current grid. Finally, `dup` returns the
the duplicate board, which is used in `move_into_check` above.

##To Dos
- Integrate AI so that players can play individually.
- Implement support for castling.

[slideable]: ./pieces/Slideable.rb
[steppable]: ./pieces/Steppable.rb
