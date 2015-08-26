require "pry"
# require 'rspec-mocks'
require 'mastermind'


module Mastermind
  class Game
    def generate_test_colors
      @character_count = 4
      @colors = ['R', 'R', 'G', 'B']
    end
  end
  class TopTen
    FILE_NAME = 'topten_test.yaml'
  end
end
