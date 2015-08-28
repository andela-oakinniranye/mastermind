require 'mastermind'

module Mastermind

  # include Helper

  # module Helper
  #   def get_input(message)
  #     # puts "Whatever it is"
  #     message
  #   end
  #
  #   def send_message(message)
  #
  #   end
  # end

  class Main
    alias_method :old_play, :play
    def play
      level = get_input(@response.level_select.message).to_i
      @game.play(level)
    end
  end

  class Game
    attr_reader :level

    # alias_method :old_initialize, :initialize
    alias_method :old_play, :play

    def play(level = 1)
      level = 1 if level < 1
      level = 3 if level > 3
      convert_level(level)

      old_play
    end

    def convert_level(level = 1)
      # @character_count = 4 + (2 * (level - 1))
      color_count = 4 + (1 * (level - 1))
      #this ought not be, however useful for the simple gem
      #which basically uses the generates colors based on the arrays
      #if colors were repeated the commented method above would have been better

      @character_count = color_count
      additional_colors = {'O' => '(o)range',
                          'P' => '(p)urple',
                          'C' => '(c)yan',
                          'V' => '(v)iolet',
                          'I' => '(i)ndigo',
                          'A' => '(a)mber'
                          }
      @@all_colors_hash.merge!(additional_colors)
      @@color_array = @@all_colors_hash.keys.sample(color_count)
    end

    def generate_colors
      @colors = @@color_array.sample(@character_count)
      @color_values_from_all_colors_array = @colors.map{|color| @@all_colors_hash[color] }
      @color_values_from_all_colors_array.shuffle!
    end

    def instructions
      send_message(@response.instructions(@color_values_from_all_colors_array).message) if @colors
      @response.message
    end


    def get_game_input
      input = get_input(@response.trial_count(@trial_count, @colors.join ,@color_values_from_all_colors_array).message)
      input
    end

  end

  class Message
    alias_method :old_trial_count, :trial_count

    def level_select
      set_attr(message: "To start the game select a level you would like to play:\nEnter (1) for Beginner,\nEnter (2) for Intermediate,\nEnter (3) for Advanced.", status: :level_select)
    end

    def trial_count(trial_count, correct_sequence, colors = nil)
      remaining_trials = Game::ALLOWED_TRIALS - trial_count
      if trial_count == 0
        instructions(colors)
      else
        old_trial_count(trial_count, correct_sequence)
      end
    end

  end
end
