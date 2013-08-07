require 'rubygems'
require 'gosu'
require './angle_range'

class Fish

  attr_accessor :x, :y, :angle, :color, :repel_zone, :parallel_zone, :attract_zone, :minumum_moves_between_turns,
                :bounce_off_edges, :speed, :field_of_vision, :search_frequency, :unpredictability, :image

  def self.add_to_window(window, count, &block)
    fishes = 1.upto(count).map do
      fish = Fish.new
      fish.x = rand(window.width)
      fish.y = rand(window.height)
      fish.angle = rand(360) + 1
      fish.color = 'yellow'
      fish.repel_zone = 30
      fish.parallel_zone = 90
      fish.attract_zone = 120
      fish.minumum_moves_between_turns = 10
      fish.bounce_off_edges = true
      fish.speed = 4
      fish.field_of_vision = 270
      fish.search_frequency = 50
      fish.unpredictability = 0
      block.call(fish)
      fish.image = Gosu::Image.new(window, "media/#{fish.color}-fish.png", false)
      window.add_fish(fish)
    end
  end

  def initialize
    @moves_since_turned = 0
    @just_turned = false
    @scattering = false
    @moves_since_scattered = 0
  end

  def see(closest_fish)

    if (closest_fish.color != @color)
      turn_away(closest_fish)
    else
      case get_distance(closest_fish)
      when 0..@repel_zone
        turn_away(closest_fish)
      when @repel_zone+1..@parallel_zone
        unless @angle == closest_fish.angle
          turn_to closest_fish.angle
        end
      when @parallel_zone+1..@attract_zone
        turn_to Gosu::angle(@x, @y, closest_fish.x, closest_fish.y)
      else
        if @moves_since_turned >= @search_frequency
          turn_to rand(360)
        end
      end
    end
  end

  def turn_away(other_fish)
    relative_angle = Gosu::angle(@x, @y, other_fish.x, other_fish.y)
    if (relative_angle < @angle)
      while can_see(other_fish)
        turn(-1)
      end
    else
      while can_see(other_fish)
        turn(1)
      end
    end
  end

  def scatter
    @scattering = true
  end

  def move(fishes, window)

    if @scattering
      @moves_since_scattered += 1
      turn_to rand(360) if @moves_since_scattered == 1
      deal_with_edge(window)
      if @moves_since_scattered == 300
        @scattering = false
        @moves_since_scattered = 0
      end
    else
      if (0..@unpredictability).include?(rand(1000))
        turn_to rand(360)
      else
        deal_with_edge(window)
        closest_fish = get_closest_fish(fishes)
        see(closest_fish) if closest_fish && can_turn?
      end

    end

    @angle = AngleRange::normalize(@angle)

    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)

    if @just_turned
      @moves_since_turned = 0
      @just_turned = false
    else
      @moves_since_turned += 1
    end
  end

  def can_turn?
    @moves_since_turned >= @minumum_moves_between_turns
  end

  def turn(degrees)
    @angle += degrees
    @just_turned = true
  end

  def turn_to(angle)
    @angle = angle
    @just_turned = true
  end

  def deal_with_edge(window)
    if @bounce_off_edges
      if @x > window.width && AngleRange.new(0, 180).include?(@angle)
        turn_to(270 - (@angle - 90))
      end
      if @x < 0  && AngleRange.new(180, 0).include?(@angle)
        turn_to(90 - (@angle - 270))
      end
      if @y < 0 && AngleRange.new(270, 90).include?(@angle)
        turn_to(180 - (@angle - 360))
      end
      if @y > window.height && AngleRange.new(90, 270).include?(@angle)
        turn_to(360 - (@angle - 180))
      end
    else
      @x %= window.width
      @y %= window.height
    end
  end

  def get_closest_fish(fishes)
    closest_fish = nil
    fishes.each do |fish|
      if (!fish.equal?(self) && can_see(fish))
        if (!closest_fish || (closest_fish && get_distance(fish) < get_distance(closest_fish)))
          closest_fish = fish
        end
      end
    end
    closest_fish
  end

  def get_distance(fish)
    Gosu::distance(@x, @y, fish.x, fish.y)
  end

  def can_see(fish)
    relative_angle = Gosu::angle(@x, @y, fish.x, fish.y)
    AngleRange.new(@angle - @field_of_vision / 2, @angle + @field_of_vision / 2).include?(relative_angle)
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Fish, @angle)
  end

end



