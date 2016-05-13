require_relative 'Piece'
require_relative 'Slideable'

class Bishop < Piece
  include Slideable
  attr_reader :color
  attr_accessor :position

  def initialize(board, position, color)
    super
  end

  def move_dir
    diagonal_dir
  end

  def to_s
    color == :white ? "\u2657 " : "\u265D "
  end

end
