module Mastermind
  class Main
    include Default
    attr_reader :game, :response

    def initialize
      @response = Message.new
    end

    def start
      action = get_input(@response.start.message)
      if supported_actions.keys.include? action
        @game = Game.new(@response)
        @game.method(supported_actions[action]).call
        start if supported_actions[action] =~ /instructions/
      else
        send_message @response.unsupported_game_action.message
        start
      end
    end

    def supported_actions
      {
        'p' => 'play',
        'play' => 'play',
        'q' => 'quit_game',
        'quit' => 'quit_game',
        'i' => 'instructions',
        'instructions' => 'instructions'
      }
    end

  end
end
