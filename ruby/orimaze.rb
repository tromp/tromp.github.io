module Directions
  UP, RIGHT, DOWN, LEFT = (0..3).to_a
end

class OriMaze
  include Directions
  attr_accessor :width, :height, :size, :exit

  def initialize(width, height, exitrow)
    @width, @height = width, height
    @exit = exitrow * @width
    @size = @width * @height
    @shift = @size - 1
    @hoffset, @voffset = 1 << @shift, @width << @shift
  end

  def parse(s) # parse state string as output by format
    x = i = free = 0
    s.each_byte do |c|
      case c
        when ?|
          x |= (1 << i)
          i += 1
        when ?-, ?=
          i += 1
        when ? , ?.
          free = i
      end
    end
    (free << @shift) | x
  end

  def each_cell(x)
    free = x >> @shift
    @height.times do |i|
      @width.times do |j|
        if free == 0
          yield j,i, ?.
        else
          yield j,i, (x & 1 == 1 ? ?| : ?-)
          x >>= 1
        end
        free -= 1
      end
    end
  end

  def freexy(x)
    free = x >> @shift
    return free%@width, free/@width
  end

  def move(x, dir)
    free = x >> @shift
    lowermask = (freemask = 1 << free) - 1
    freecol = free % @width
    case dir
      when UP
        if free >= @width && x[free - @width] == 1 # can move up
          rotatemask = lowermask - (lowermask >> @width)
          return x - @voffset & ~rotatemask | (x | freemask) >> 1 & rotatemask
        else
          return -1
        end
      when RIGHT
        if freecol < @width - 1 && x[free] == 0 # can move right
          return x + @hoffset
        else
          return -1
        end
      when DOWN
        if free < @size - @width && x[free + @width - 1] == 1# can move down
          rotatemask = ~lowermask - (~lowermask << @width)
          return x + @voffset & ~rotatemask | (x << 1 | freemask) & rotatemask
        else
          return -1
        end
      when LEFT
        if freecol > 0 && x[free - 1] == 0 # can move left
          return x - @hoffset
        else
          return -1
        end
    end
  end

  def solved?(x)
    free = x >> @shift
    free < @exit && x[@exit-1] == 0 || free > @exit && x[@exit] == 0
  end
end

class OriMazePlayer
  require 'tk'
  include Directions
  attr_reader :root, :canvas, :pzl, :pos, :scale, :delta, :history, :eps
  attr_reader :bg, :vcol, :hcol, :freecol

  def bindkey(widget, key, dir, color, dx, dy)
    widget.bind(key) {
      if (newpos = @pzl.move(@pos, dir)) != -1
        bg, freecol = @bg, @freecol
        x, y = @pzl.freexy(@pos)
        x *= @scale; y *= @scale
        x += 10; y += 10
        TkcRectangle.new(@canvas,x,y,x+@scale,y+@scale) { fill bg; outline bg }
        TkcOval.new(@canvas,x+dx,y+dy,x+@scale-dx,y+@scale-dy) { fill color }
        x, y = @pzl.freexy(@pos = newpos)
        x *= @scale; y *= @scale
        x += 10; y += 10
        TkcRectangle.new(@canvas,x,y,x+@scale,y+@scale) { fill bg; outline bg }
        TkcRectangle.new(@canvas,x+@delta,y+@delta,x+@scale-@delta,y+@scale-@delta) { fill freecol }
        if !@history.empty? && dir^@history[-1]==2
          @history.pop
        else
          @history << dir
        end
        n = @history.length
        TkcText.new(@canvas,x+@scale/2,y+@scale/2) { text "#{n}" }
        @root.title("Solved!") if @pzl.solved?(@pos)
      end
    }
  end

  def initialize(width, height, exitrow, puzzle)
    @pzl = OriMaze.new(width, height, exitrow)
    @pos = @pzl.parse(puzzle)
    @scale = 50
    @delta = 10
    @eps = 2
    @history = []
    @bg, @vcol, @hcol, @freecol = "black", "magenta", "green", "white"

    @root = TkRoot.new { title "OriMaze 1.0" }
    root.bind('q') { exit }
    @canvas = TkCanvas.new(root) {
      background "black"
    }.pack
    @pzl.each_cell(@pos) { |x,y,c|
      x *= @scale; y *= @scale
      x += 10; y += 10
      if c == ?.
        color = @freecol
        TkcRectangle.new(@canvas,x+@delta,y+@delta,x+@scale-@delta,y+@scale-@delta) { fill color }
        TkcText.new(@canvas,x+@scale/2,y+@scale/2) { text "GO!" }
      else
        if c == ?-
          dx,dy,color = 0, @delta, @hcol
        else
          dx,dy,color = @delta, 0, @vcol
        end
        TkcOval.new(@canvas,x+dx,y+dy,x+@scale-dx,y+@scale-dy) { fill color }
      end
    }
    bindkey(root, 'Key-Up', UP, @vcol, @delta, @eps)
    bindkey(root, 'Key-Right', RIGHT, @hcol, @eps, @delta)
    bindkey(root, 'Key-Down', DOWN, @vcol, @delta, @eps)
    bindkey(root, 'Key-Left', LEFT, @hcol, @eps, @delta)
    Tk.mainloop
  end
end

OriMazePlayer.new(5,5,0,"||||-\n-||--\n|--|.\n||--|\n|---|")
