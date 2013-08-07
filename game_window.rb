require './fish'

class GameWindow < Gosu::Window

  HEIGHT = 768
  WIDTH = 1024


  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Fish"
    @background_image = Gosu::Image.new(self, "media/ocean.png", true)
    @fishes = []
    @time_to_scatter = false
  end

  def add_fish(fish)
    @fishes << fish
  end

  def update
    @fishes.each do |fish|
      fish.scatter if @time_to_scatter
      fish.move(@fishes, self)
    end
    @time_to_scatter = false
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @fishes.each do |fish|
      fish.draw
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    elsif id == Gosu::KbSpace
      @time_to_scatter = true
    end
  end

end

module ZOrder
  Background, Fish = *0..1
end
