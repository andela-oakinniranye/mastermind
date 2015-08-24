module Mastermind
  class Game
    include Default
    attr_reader :colors, :trial_count, :response, :character_count
    @@color_array = %w{ R G B Y }

    def initialize(response, character_count = 4)
      @response = response
      @character_count = character_count
    end

    def generate_colors
      @character_count = character_count
      @colors = []
      @character_count.times{
        @colors << @@color_array.sample
      }
    end

    def analyze_guess(current_guess)
      current_guess = current_guess.upcase.split('')
      current_sprint = {match_position: [], almost_match: []}
      current_guess.each_with_index{ |value, index|
        current_sprint[:match_position] << true if value == @colors[index]
        current_sprint[:almost_match] << true if @colors.include? value
      }

      current_sprint
    end

    def play
      generate_colors
      @response.start.message
      @trial_count = 0
      @time_started = Time.now.to_i

      game_process
    end

    def too_short?(input)
      if input.length < @character_count
        send_message(@response.shorter_input.message)
        true
      end
    end

    def too_long?(input)
      if input.length > @character_count
        send_message(@response.longer_input.message)
        true
      end
    end

    def game_process
      until @response.status == :won
        input = get_input(@response.trial_count(@trial_count).message)
        if actions.keys.include? input
          method(actions[input]).call
          break if actions[input] =~ /quit|cheat/
        else
          next if too_short?(input)
          next if too_long?(input)
          @trial_count += 1
          analyzed = analyze_guess(input)
          break if check_correct?(analyzed)
          send_message(@response.analyzed_guess(analyzed[:match_position].length, analyzed[:almost_match].length).message)
        end
      end
      play_again_or_quit
    end

    def play_again_or_quit
      if @response.status == :won
        input = get_input(@response.message)
        supported_actions = {'p' => 'play', 'play' => 'play', 'q' => 'quit_game', 'quit' => 'quit_game'}
        method(supported_actions[input]).call if supported_actions.keys.include? input
      end
    end

    def check_correct?(analysis)
      if analysis[:match_position].length == @character_count
        won(@time_started)
        true
      end
    end

    def actions
      {
        'q' => 'quit_game',
        'quit' => 'quit_game',
        'i' => 'instructions',
        'instructions' => 'instructions',
        'c' => 'cheat',
        'cheat' => 'cheat'
      }
    end

    def instructions
      send_message(@response.instructions.message)
      @response.message
    end

    def quit_game
      @trial_count = 0
      @colors = []
      send_message(@response.exit_game.message)
      @response.message
    end

    def won(start_time)
      time_diff = Time.now.to_i - start_time
      time = {}
      time[:mins] = time_diff/60
      time[:secs] = time_diff%60
      @response.won(@trial_count, time)
    end

    def cheat
      @response.cheat(@colors.join).message
    end
  end
end
