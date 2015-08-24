module Mastermind
  module Default
    def send_message(message)
      puts message
    end

    def get_input(message)
      send_message message
      input = gets.chomp
      input
    end
  end
end
