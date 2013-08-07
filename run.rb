require './game_window'

window = GameWindow.new()

Fish.add_to_window(window, 30) do |fish|
  fish.color = 'green'
end

Fish.add_to_window(window, 10) do |fish|
  fish.color = 'yellow'
  fish.speed = 3
  fish.repel_zone = 50
  fish.parallel_zone = 60
  fish.attract_zone = 70
end

Fish.add_to_window(window, 10) do |fish|
  fish.color = 'purple'
  fish.speed = 3
  fish.repel_zone = 80
  fish.parallel_zone = 100
  fish.attract_zone = 110
end

window.show
