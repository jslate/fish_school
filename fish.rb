require 'rubygems'
require 'gosu'
require './angle_range'

class Fish

  attr_reader :x, :y, :angle, :color

  def initialize(window, config)
    @window = window

    @x = config[:x] || rand(@window.width)
    @y = config[:y] || rand(@window.height)
    @angle = config[:angle] || rand(360)


    @repel_zone = config[:repel_zone] || 50
    @parallel_zone = config[:parallel_zone] || 60
    @attract_zone = config[:attract_zone] || 70
    @minumum_moves_between_turns = config[:minumum_moves_between_turns] || 1
    @bounce_off_edges = config[:bounce_off_edges] || true
    @speed = config[:speed] || 1
    @field_of_vision = config[:field_of_vision] || 270
    @search_frequency = config[:search_frequency] || 50
    @unpredictability = config[:unpredictability]  || 0 # 0 - 1000 scale
    @color = config[:color] || 'yellow'

    @image = Gosu::Image.new(@window, "media/#{@color}-fish.png", false)

    @moves_since_turned = 0
    @just_turned = false
    @scattering = false
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

  def move(fishes)

    if (0..@unpredictability).include?(rand(1000))
      turn_to rand(360)
    else
      deal_with_edge
      closest_fish = get_closest_fish(fishes)
      see(closest_fish) if closest_fish && can_turn?
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

  def deal_with_edge
    if @bounce_off_edges
      if @x > @window.width && AngleRange.new(0, 180).include?(@angle)
        @angle = 270 - (@angle - 90)
      end
      if @x < 0  && AngleRange.new(180, 0).include?(@angle)
        @angle = 90 - (@angle - 270)
      end
      if @y < 0 && AngleRange.new(270, 90).include?(@angle)
        @angle = 180 - (@angle - 360)
      end
      if @y > @window.height && AngleRange.new(90, 270).include?(@angle)
        @angle = 360 - (@angle - 180)
      end
    else
      @x %= @window.width
      @y %= @window.height
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



