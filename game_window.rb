require './fish'

class GameWindow < Gosu::Window

  HEIGHT = 768
  WIDTH = 1024
  
  
  def initialize(fish_configs)
    super(WIDTH, HEIGHT, false)
    self.caption = "Fish"
    @background_image = Gosu::Image.new(self, "media/ocean.png", true)
    @fishes = []
    #@fish_arrays = []
    fish_configs.each do |config|
      #fishes = []
      config[:fish_count].times { @fishes << Fish.new(self, config) }
      #@fish_arrays << fishes
    end
  end
  
  def update
    @fishes.each do |fish|
      fish.move(@fishes) 
    end 
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
    end
  end
  
end

module ZOrder
  Background, Fish = *0..1
end
