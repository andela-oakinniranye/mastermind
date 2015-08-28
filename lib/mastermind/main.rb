module Mastermind
  class Main
    include Helper
    attr_reader :game, :response

    def initialize
      @response = Message.new
    end

    def start
      action = get_input(@response.start.message)
      if supported_actions.keys.include? action
        @game ||= Game.new(@response)
        method(supported_actions[action]).call
      else
        send_message @response.unsupported_game_action.message
      end
        start if supported_actions[action] =~ /instructions|background/ || @response.status == :unsupported_action
    end

  private
    def instructions
      send_message(@response.gameplay_instructions.message)
    end

    def background
      send_message(@response.main_message.message)
    end

    def play
      @game.play
    end

    def quit_game
      @game.quit_game
    end

    def supported_actions
      {
        'p' => 'play',
        'play' => 'play',
        'q' => 'quit_game',
        'quit' => 'quit_game',
        'i' => 'instructions',
        'instructions' => 'instructions',
        'b' => 'background',
        'background' => 'background'
      }
    end
  end
end
