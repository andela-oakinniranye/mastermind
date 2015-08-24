module Mastermind

  class Message
    attr_reader :message, :status

    def initialize(input = nil)
      #  if input
      if input
        set_attr input
      else
        start
      end
    end

    def set_attr(input)
      @message = input[:message]
      @status = input[:status]
      self
    end

    def cheat(color)
      set_attr(message: "Hmm! You just cheated. The colors generated was: #{color}", status: :ended)
    end

    def won(tries, time={})
      set_attr(message: "Congratulations!\nYou won the game in #{tries} tr[y|ies] and #{time[:mins]}m#{time[:secs]}s.\nDo you want to (p)lay again or (q)uit?", status: :won)
    end

    def instructions
      set_attr(message: "I have generated a beginner sequence with four elements made up of:\n(r)ed, (g)reen, (b)lue, and (y)ellow. Use (q)uit at any time to end the game.\nWhat's your guess? ", status: :unknown)
    end

    def shorter_input
      set_attr(message: "Your input is too short.", status: :shorter_input)
    end

    def longer_input
      set_attr(message: "Your input is too long.", status: :longer_input)
    end

    def start
      set_attr(message: "Welcome to MASTERMIND!\nWould you like to (p)lay, read the (i)nstructions, or (q)uit?", status: :started)
    end

    def exit_game
      set_attr(message: "Thank you for playing Mastermind!\nGoodbye!", status: :quitted)
    end

    def unsupported_game_action(message: nil, status: nil)
      set_attr(
        message: message || "You entered an unsupported action, try again! ",
        status: status || @status
        )
    end

    def wrong_guess
      set_attr(message: "Your guess was wrong! Guess again: ", status: :wrong)
    end

    def analyzed_guess(matched_position, included)
      set_attr(message: "You had #{matched_position} position(s) exactly matched and #{included} close match(es)", status: :running)
    end

    def trial_count(trial_count)
      if trial_count == 0
        instructions
      else
        set_attr(message: "You have tried #{trial_count} time(s).\nTry again: ", status: :running)
      end
    end

    def winner_record(winner, time_taken)
      set_attr(message: "#{winner} completed mastermind in #{time_taken}", status: :unknown)
    end
  end
end
