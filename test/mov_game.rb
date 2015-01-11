require 'gosu'
require_relative '../lib/minigl'
include AGL

class MyGame < Game
  def initialize
    super 800, 600, false

    @obj = GameObject.new(0, 0, 50, 50, :square)
    # @obj.max_speed.x = 3
    @obsts = [
      Block.new(0, 600, 800, 1, false),
      Block.new(-1, 0, 1, 600, false),
      Block.new(800, 0, 1, 600, false),
      # Block.new(375, 550, 50, 50, true),
      # Block.new(150, 200, 20, 300, false),
      # Block.new(220, 300, 100, 20, true),
      # Block.new(485, 490, 127, 10, false),
    ]
    @ramps = [
      Ramp.new(200, 550, 200, 50, true),
      Ramp.new(400, 340, 200, 210, true),
      Ramp.new(600, 40, 200, 300, true),
    ]
  end

  def update
    KB.update

    forces = Vector.new(0, 0)
    if @obj.bottom
      forces.y -= 15 if KB.key_pressed?(Gosu::KbSpace)
      if KB.key_down?(Gosu::KbLeft)
        forces.x -= 1
      elsif @obj.speed.x < 0
        @obj.speed.x *= 0.8
      end
      if KB.key_down?(Gosu::KbRight)
        forces.x += 1
      elsif @obj.speed.x > 0
        @obj.speed.x *= 0.8
      end
    else
      forces.x -= 0.2 if KB.key_down?(Gosu::KbLeft)
      forces.x += 0.2 if KB.key_down?(Gosu::KbRight)
    end
    @obj.move(forces, @obsts, @ramps)

    # puts @obj.bottom
  end

  def draw
    @obj.draw
    @obsts.each do |o|
      draw_quad o.x, o.y, 0xffffffff,
                o.x + o.w, o.y, 0xffffffff,
                o.x + o.w, o.y + o.h, 0xffffffff,
                o.x, o.y + o.h, 0xffffffff, 0
    end
    @ramps.each do |r|
      draw_triangle r.left ? r.x + r.w : r.x, r.y, 0xffffffff,
                    r.x + r.w, r.y + r.h, 0xffffffff,
                    r.x, r.y + r.h, 0xffffffff, 0
    end
  end
end

MyGame.new.show