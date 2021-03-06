require_relative '../lib/minigl'
include MiniGL

class MyGame < GameWindow
  def initialize
    super 800, 600, false

    # @img = Res.img :img1
    @obj1 = GameObject.new 10, 10, 80, 80, :img1, Vector.new(-10, -10)
    @obj2 = Sprite.new 400, 0, :img1
    @obj3 = GameObject.new 4, 50, 24, 24, :check, Vector.new(-4, -4), 2, 4
    @obj3.set_animation 1
    @objs = []
    8.times { @objs << GameObject.new(384, 284, 32, 32, :check, Vector.new(0, 0), 2, 4) }
    @flip = nil

    @font1 = Res.font :font1, 20
    @font2 = Res.font :font1, 50
    @writer1 = TextHelper.new @font1, 5
    @writer2 = TextHelper.new @font2, 5
    @btn = Button.new(10, 560, @font1, 'Test', :btn, 0x008000, 0x808080, 0xffffff, 0xff9980, true, false, 0, 4, 0, 0, 'friends') { |x| puts "hello #{x}" }
    @btn.enabled = false
    @chk =
      ToggleButton.new(x: 40, y: 300, font: @font1, text: 'Click me', img: :check, center_x: false, margin_x: 36, params: 'friends') { |c, x|
        puts "hello #{x}, checked: #{c}"
      }
    @txt = TextField.new(x: 10, y: 520, font: @font1, img: :text, margin_x: 15, margin_y: 5, max_length: 16, locale: 'PT-BR')
    @txt.visible = false

    @pb = ProgressBar.new(5, 240, 200, 20, 0xff0000, 0x00ff00, 3456, 70, 0, 0, @font1, 0xff000080)
    @ddl = DropDownList.new(5, 270, @font1, nil, nil, ['olá amigos', 'opção 2', 'terceira'], 0, 3, 150, 25, 0, 0x808080, 0xffffff, 0xffff00) { |a, b|
      puts "mudou de #{a} para #{b}"
    }

    @eff = Effect.new(100, 100, :check, 2, 4, 10, nil, nil, '1')

    @angle = 0
  end

  def needs_cursor?
    true
  end

  def update
    KB.update
    @obj1.y -= 1 if KB.key_held? Gosu::KbUp
    @obj1.x += 1 if KB.key_down? Gosu::KbRight
    @obj1.y += 1 if KB.key_held? Gosu::KbDown
    @obj1.x -= 1 if KB.key_down? Gosu::KbLeft
    @btn.set_position rand(700), rand(550) if KB.key_pressed? Gosu::KbSpace
    @btn.enabled = !@btn.enabled if KB.key_pressed? Gosu::KbLeftControl
    @chk.checked = false if KB.key_pressed? Gosu::KbEscape
    @chk.enabled = !@chk.enabled if KB.key_pressed? Gosu::KbRightControl
    @txt.visible = !@txt.visible if KB.key_pressed? Gosu::KbReturn
    @txt.enabled = !@txt.enabled if KB.key_pressed? Gosu::KbLeftAlt
    @txt.locale = 'en-us' if KB.key_pressed? Gosu::KbX
    @txt.locale = 'pt-br' if KB.key_pressed? Gosu::KbC
    @pb.visible = !@pb.visible if KB.key_pressed? Gosu::KbE
    @ddl.enabled = !@ddl.enabled if KB.key_pressed? Gosu::KbQ
    @ddl.visible = !@ddl.visible if KB.key_pressed? Gosu::KbW

    @pb.increase 1 if KB.key_down? Gosu::KbD
    @pb.decrease 1 if KB.key_down? Gosu::KbA
    @pb.percentage = 0.5 if KB.key_pressed? Gosu::KbS
    @pb.value = 10000 if KB.key_pressed? Gosu::KbZ

    @ddl.value = 'olá amigos' if KB.key_pressed? Gosu::Kb1
    @ddl.value = 'segunda' if KB.key_pressed? Gosu::Kb2
    @ddl.value = 'terceira' if KB.key_pressed? Gosu::Kb3

    Mouse.update
    if Mouse.double_click? :left
      @obj1.x = Mouse.x + 10
      @obj1.y = Mouse.y + 10
    end
    if Mouse.button_released? :right
      if @flip.nil?; @flip = :horiz
      else; @flip = nil; end
    end
    if Mouse.button_down? :left
      @angle += 1
    end

    @btn.update
    @chk.update
    @txt.update
    @ddl.update

    @eff.update

    @objs.each_with_index do |o, i|
      o.move_free(i * 45, 3)
    end
  end

  def draw
    clear 0xabcdef

    # @img.draw_rot 400, 100, 0, @angle, 1, 1
    @obj1.draw color: 0x33ff33, angle: (@angle == 0 ? nil : @angle)
    @obj2.draw angle: (@angle == 0 ? nil : @angle), scale_x: 0.5, scale_y: 1.4
    @obj3.draw flip: @flip
    @objs.each { |o| o.draw }
    @writer1.write_line text: 'Testing effect 1', x: 400, y: 260, color: 0xffffff, effect: :border
    @writer2.write_line 'Second effect test', 400, 280, :center, 0xffffff, 255, :border, 0xff0000, 2
    @writer2.write_line 'Text with shadow!!', 400, 340, :center, 0xffff00, 255, :shadow, 0, 2, 0x80
    @writer1.write_breaking "Testing multiple line text.\nThis should draw text "\
                            'across multiple lines, respecting a limit width. '\
                            'Furthermore, the text must be right-aligned.',
                            780, 450, 300, :right, 0xff0000, 255, 1

    @ddl.draw 0x80, 1
    @btn.draw 0xcc
    @chk.draw
    @txt.draw
    @pb.draw 0x66

    @eff.draw
  end
end

MyGame.new.show
