module Mastermind
  class Game
    include Default
    attr_reader :colors, :trial_count, :response, :character_count, :player, :top_ten_record
    ALLOWED_TRIALS = 12
    @@color_array = %w{ R G B Y }

    def initialize(response, character_count = 4, top_ten_record: TopTen.new)
      @response = response
      @character_count = character_count
      @top_ten_record = top_ten_record
    end

    def generate_colors
      @colors = @@color_array.sample(@character_count)
    end

    def analyze_guess(current_guess)
      current_guess = current_guess.upcase.split('')
      current_sprint = Hash.new(0)
      current_guess.each_with_index{ |value, index|
        if value == @colors[index]
          current_sprint[:match_position] += 1
        elsif @colors.include? value
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

    def play
      get_player if @player.nil?
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
      until @trial_count > ALLOWED_TRIALS || @response.status == :won
        input = get_input(@response.trial_count(@trial_count, @colors.join).message)
        if actions.keys.include? input
          method(actions[input]).call
          break unless actions[input] =~ /instructions/
        else
          next if too_short?(input)
          next if too_long?(input)
          @trial_count += 1
          analyzed = analyze_guess(input)
          break if check_correct?(analyzed)
          send_message(@response.analyzed_guess(analyzed[:match_position], analyzed[:almost_match]).message)
        end
      end
      play_again_or_quit
    end

    def play_again_or_quit
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

      supported_actions = {'p' => 'play', 'play' => 'play', 'q' => 'quit_game', 'quit' => 'quit_game', 'top_players' => 'top_players', 't' => 'top_players'}
      action_s = action_s.merge(supported_actions) if @trial_count >= ALLOWED_TRIALS || @response.status == :won

      action_s
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
      @time_taken = Time.now.to_i - start_time
      time = {}
      time[:mins] = @time_taken/60
      time[:secs] = @time_taken%60

      save_if_top_ten

      @response.won(@trial_count, time)
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
    end
  end
end
