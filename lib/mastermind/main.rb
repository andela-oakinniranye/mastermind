module Mastermind
  class Main
    attr_reader :game

    def initialize
      @response = Message.new
    end

    def start
      actions
    end

private
    def actions
      puts @response.start.message

      supported_actions = {
        'p' => 'play',
        'play' => 'play',
        'q' => 'quit_game',
        'quit' => 'quit_game',
        'i' => 'instructions',
        'instructions' => 'instructions'
      }

      action = gets.chomp.downcase
      if supported_actions.keys.include? action
        @game = Game.new(@response)
        @game.method(supported_actions[action]).call
        @game = nil if action =~ /q|quit/
      else
        puts @response.unsupported_game_action.message
        actions
      end
    end
  end
end
