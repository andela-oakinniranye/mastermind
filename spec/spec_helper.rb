require "pry"
# require 'rspec-mocks'
require 'mastermind'


module Mastermind
  class Game
    def generate_test_colors
      @character_count = 4
      @colors = ['R', 'R', 'G', 'B']
      @color_values_from_all_colors_array = @colors.map{|color| @@all_colors_hash[color] }
      @color_values_from_all_colors_array.shuffle!
    end
  end
  class TopTen
    FILE_NAME = 'topten_test.yaml'
  end
end
