module Mastermind
  class Game
    include Helper
    attr_reader :colors, :trial_count, :response, :character_count, :player, :top_ten_record
    ALLOWED_TRIALS = 12
    @@all_colors_hash = { 'R' => '(r)ed',
                          'G' => '(g)reen',
                          'B' => '(b)lue',
                          'Y' => '(y)ellow'
                        }
    @@color_array = @@all_colors_hash.keys # %w{ R G B Y }

    def initialize(response, character_count = 4, top_ten_record: TopTen.new)
      @response = response
      @character_count = character_count
      @top_ten_record = top_ten_record
    end

    def play
      generate_colors
      @trial_count = 0
      get_player if @player.nil?
      @response.start.message
      @time_started = Time.now.to_i

      game_process
    end

    def generate_colors
      @colors = @@color_array.sample(@character_count)
      shuffle_colors_hash
    end

    def shuffle_colors_hash
      @color_values_from_all_colors_array = @colors.map{|color| @@all_colors_hash[color] }
      @color_values_from_all_colors_array.shuffle!
    end

    def game_process
      until @response.status == :won || @response.status == :lost || @trial_count >= ALLOWED_TRIALS
        input = get_game_input
        if actions.keys.include? input
          method(actions[input]).call
          break unless actions[input] =~ /instructions/
        else
          next if the_input_is_too_long_or_too_short?(input)
          @trial_count += 1
          analyzed = analyze_guess(input)
          break if check_correct?(analyzed)
          send_message(@response.analyzed_guess(analyzed[:match_position], analyzed[:almost_match]).message)
        end
      end
      what_do_you_want_to_do_next
    end

    def analyze_guess(current_guess)
      current_guess = current_guess.upcase.split('')
      current_sprint = Hash.new(0)
      current_guess.each_with_index{ |value, index|
        if value == @colors[index]
          current_sprint[:match_position] += 1
        elsif @colors.include? value
          # near matches should be a counter that
          # counts the unique elements in the colors array
          current_sprint[:almost_match] += 1
        end
      }
      current_sprint
    end

    def get_player
      @player ||= Player.new
      player = Hash.new(nil)
      while player[:name].nil? || player[:name].empty?
        player_name = get_input(@response.player.message)
        player[:name] = player_name
        @player.set_attr player
      end
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

    def the_input_is_too_long_or_too_short?(input)
      true if too_long?(input) || too_short?(input)
    end

    def what_do_you_want_to_do_next
      loser_play_again_or_quit if @response.status == :lost || @trial_count >= ALLOWED_TRIALS
      winner_play_again_or_quit if @response.status == :won
    end

    def get_game_input
      input = get_input(@response.trial_count(@trial_count, @colors.join, @color_values_from_all_colors_array).message)
      input
    end

    def loser_play_again_or_quit
      input = get_game_input
      method(actions[input]).call if actions.keys.include? input
    end

    def winner_play_again_or_quit
      if @response.status == :won
        input = get_input(@response.message)
        method(actions[input]).call if actions.keys.include? input
      end
    end

    def check_correct?(analysis)
      if analysis[:match_position] == @character_count
        won(@time_started)
        true
      end
    end

    def actions
      action_s = {
        'q' => 'quit_game',
        'quit' => 'quit_game',
        'i' => 'instructions',
        'instructions' => 'instructions',
        'c' => 'cheat',
        'cheat' => 'cheat'
      }

      supported_actions = {'p' => 'play', 'play' => 'play', 'top_players' => 'top_players', 't' => 'top_players'}
      action_s = action_s.merge(supported_actions) if @trial_count >= ALLOWED_TRIALS || @response.status == :won

      action_s
    end

    def instructions
      send_message(@response.instructions(@color_values_from_all_colors_array).message)
      @response.message
    end

    def quit_game
      @trial_count = 0
      @colors = []
      send_message(@response.exit_game.message)
      @response.message
    end

    def won(start_time)
      @time_taken = Time.now.to_i - start_time
      time = {}
      time[:mins] = @time_taken/60
      time[:secs] = @time_taken%60

      save_if_top_ten

      @response.won(@trial_count, time)
    end

    def lost

    end

    def save_if_top_ten
      game_attr = {time_taken: @time_taken, guesses: @trial_count, date_played: Date.today}
      @player.set_attr game_attr

      @top_ten_record.add_record(@player)
    end

    def cheat
      send_message(@response.cheat(@colors.join).message)
      @response.message
    end

    def top_players
      @top_ten_record.fetch_all.each{ |player|
        send_message(player.winner_response)
      }

      game_process
    end

    private

  end
end
