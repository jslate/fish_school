require './game_window'


yellows = {
  :fish_count => 10,
  :color => 'yellow',
  :repel_zone => 50,
  :parallel_zone => 70,
  :attract_zone => 90,
  :minumum_moves_between_turns => 10,
  :bounce_off_edges => false,
  :speed => 1,
  :field_of_vision => 270,
  :search_frequency => 50,
  :unpredictability => 0 # 0 - 1000 scale
}

greens = {
  :fish_count => 15,
  :color => 'green',
  :repel_zone => 50,
  :parallel_zone => 80,
  :attract_zone => 200,
  :minumum_moves_between_turns => 10,
  :bounce_off_edges =>true,
  :speed => 2,
  :field_of_vision => 270,
  :search_frequency => 50,
  :unpredictability => 0 # 0 - 1000 scale
}

purples = {
  :fish_count => 15,
  :color => 'purple',
  :repel_zone => 40,
  :parallel_zone => 60,
  :attract_zone => 120,
  :minumum_moves_between_turns => 5,
  :bounce_off_edges =>true,
  :speed => 4,
  :field_of_vision => 270,
  :search_frequency => 50,
  :unpredictability => 0 # 0 - 1000 scale
}

window = GameWindow.new([purples, greens, yellows])
window.show