module Mastermind
  class Game
    alias_method :old_actions, :actions
    attr_reader :game_save_data
    alias_method :old_get_player, :get_player
    alias_method :new_old_play, :play

    def get_player
      old_get_player
      check_if_user_has_saved_game
    end

    def check_if_user_has_saved_game
      @game_save_data ||= SaveGame.new
      player = @game_save_data.fetch_player(@player.name)
      if player
        input = get_input(@response.message_if_user_has_saved_game.message)
        continue_saved_game(player) if ['y', 'yes'].include? input
      end
    end

    def continue_saved_game(player)
      @player = player
      load_saved_game
    end

    def actions
      new_actions = { 'pause' => 'play_later',
        'pl' => 'play_later'
      }
      action_s = old_actions
      action_s = old_actions.merge(new_actions) unless @trial_count >= ALLOWED_TRIALS
      action_s
    end

    def play_later
      @player.save_game(@time_started, @colors, @trial_count)
    end

    def load_saved_game
      @trial_count = @player.guesses_at_pause_count
      @colors = @player.color_combo
      @character_count = @colors.length
      time_used = @player.time_started - @player.time_at_game_save
      @time_started = Time.now.to_i - time_used
      shuffle_colors_hash
      instructions
    end
  end

  class Message
    def continue_later
      set_attr(message: "Can't play again?\nYou can continue later", status: :paused)
    end

    def message_if_user_has_saved_game
      set_attr(message: "You currently have a game saved.\nWould you like to continue?\nEnter (y) for Yes\nEnter (n) for No!", status: :has_saved_game)
    end

    # def message_if_user_continues_saved_game
    #   set_attr(message: "")
    # end
  end

  class Player
    attr_reader :save_game_worker, :time_started, :color_combo, :guesses_at_pause_count, :time_at_game_save
    alias_method :old_to_h, :to_h

    def save_game(*game_data)
      @save_game_worker ||= SaveGame.new
      make_save_attr(game_data[0], game_data[1], game_data[2]) unless game_data.empty?
      @save_game_worker.save_record(self)

    end

    def make_save_attr(time_started, color_combo, guesses_at_pause_count)
      @time_started = time_started
      @color_combo = color_combo
      @guesses_at_pause_count = guesses_at_pause_count
      @time_at_game_save = Time.now.to_i
    end

    def to_h
      player = old_to_h
      player[:time_started] = @time_started
      player[:color_combo] = @color_combo
      player[:guesses_at_pause_count] = @guesses_at_pause_count
      player[:time_at_game_save] = @time_at_game_save
      player
    end

    def set_save_attr(game_data = {})
      # check if game_data is a game or a hash
      @name = game_data[:name]
      @time_started = game_data[:time_started]
      @color_combo = game_data[:color_combo]
      @guesses_at_pause_count = game_data[:guesses_at_pause_count]
      @time_at_game_save = game_data[:time_at_game_save]
      @guesses = @time_taken = nil
    end
  end
end
