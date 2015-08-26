module Mastermind

  class Message
    attr_reader :message, :status

    def initialize(input = nil)
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
      set_attr(message: "Hmm! You just cheated. The colors generated was: #{color}.", status: :cheated)
    end

    def won(tries, time={})
      set_attr(message: "#{'Congratulations!'.colorize(:green)}\nYou won the game in #{(tries.to_s + ' try'.pluralize(tries)).colorize(:blue)} and #{(time[:mins].to_s + 'm' + time[:secs].to_s + 's').colorize(:blue)}.\nDo you want to (p)lay again or (q)uit or (t)op_players?", status: :won)
    end

    def instructions
      set_attr(message: "I have generated a beginner sequence with four elements made up of:\n#{'(r)ed'.colorize(:red)}, #{'(g)reen'.colorize(:green)}, #{'(b)lue'.colorize(:blue)}, and #{'(y)ellow'.colorize(:yellow)}. Use #{'(q)uit'.colorize(:red)} at any time to end the game.\nWhat's your guess? ", status: :instructions)
    end

    def shorter_input
      set_attr(message: "Your input is too short.".colorize(:red), status: :shorter_input)
    end

    def longer_input
      set_attr(message: "Your input is too long.".colorize(:red), status: :longer_input)
    end

    def start
      set_attr(message: "Welcome to MASTERMIND!\nWould you like to #{'(p)lay'.colorize(:green)}, read the #{'(i)nstructions'.colorize(:blue)}, read a little #{'(b)ackground'.colorize(:yellow)} on Mastermind or #{'(q)uit'.colorize(:red)}?", status: :main_start)
    end

    def exit_game
      set_attr(message: "Thank you for playing Mastermind!\nGoodbye!".colorize(:red), status: :quitted)
    end

    def unsupported_game_action(message: nil, status: nil)
      set_attr(
        message: message || "You entered an unsupported action, try again! ".colorize(:red),
        status: status || :unsupported_action
        )
    end

    def wrong_guess
      set_attr(message: "Your guess was wrong! Guess again: ".colorize(:red), status: :wrong)
    end

    def analyzed_guess(matched_position, included)
      set_attr(message: "You had #{(matched_position.to_s + ' position'.pluralize(matched_position)).colorize(:green)} exactly matched and #{(included.to_s + ' near match'.pluralize(included)).colorize(:blue)}", status: :running)
    end

    def trial_count(trial_count, colors = nil)
      remaining_trials = Game::ALLOWED_TRIALS - trial_count
      if trial_count == 0
        instructions
      elsif(trial_count < Game::ALLOWED_TRIALS)
        set_attr(message: "You have tried #{trial_count.to_s + ' time'.pluralize(trial_count)}. You have #{remaining_trials.to_s + ' attempt'.pluralize(remaining_trials)} left.\nTry again: ", status: :wrong_guess)
      else
        set_attr(message: "You tried, but lost.\nThe color generated was #{colors}.\nWant to try again? (p)lay to start again or (q)uit to exit or (t)op_players to view the top ten players. ".colorize(:red), status: :lost)
      end
    end

    def player
      set_attr(message: "So you would like to play!\nStart by telling me your name: ".colorize(:green), status: :player_name)
    end

    def gameplay_instructions(color_count = 4)
      set_attr(message: "Enter a sequence of #{color_count} colors containing the generated colors e.g RYBG or YGRB.\nIf you enter fewer than #{color_count} or more than #{color_count} colors, you would receive an error message", status: :main_instructions)
    end

    def main_message
      message = <<-EOS
      #{%q{Just a little background on MASTERMIND}.colorize(:red)} Mastermind is a board game with an interesting history (or rather a legend?). Some game books report that it was invented in 1971 by Mordecai Meirowitz, an Israeli postmaster and telecommunications expert. After many rejections by leading toy companies, the rights were obtained by a small British firm, Invicta Plastics Ltd. The firm originally manufactured the game itself, though it has since licensed its manufacture to Hasbro in most of the world. However, Mastermind is just a clever readaptation of an old similar game called 'Bulls and cows' in English, and 'Numerello' in Italian... Actually, the old British game 'Bulls and cows' was somewhat different from the commercial version. It was played on paper, not on a board... Over 50 million copies later, Mastermind is still marketed today!
      The idea of the game is for one player (the code-breaker) to guess the secret code chosen by the other player (the code-maker). The code is a sequence of 4 colored pegs chosen from six colors available. The code-breaker makes a serie of pattern guesses - after each guess the code-maker gives feedback in the form of 2 numbers, the number of pegs that are of the right color and in the correct position, and the number of pegs that are of the correct color but not in the correct position - these numbers are usually represented by small black and white pegs.
      In 1977, the mathematician Donald Knuth demonstrated that the code-breaker can solve the pattern in five moves or less, using an algorithm that progressively reduced the number of possible patterns.
EOS
      set_attr(message: message, status: :background_message)
    end

    def winner(winner, trials, time_taken)
      set_attr(message: "#{winner} completed mastermind in #{trials} #{'guess'.pluralize(trials)} and #{time_taken}", status: :top_players)
    end
  end
end
