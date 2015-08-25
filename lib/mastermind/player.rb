module Mastermind
  class Player
    include Default
    attr_reader :record, :name, :guesses, :time_taken, :date_played
    # attr_accessor :name, :trials, :time_taken, :date_played

    def initialize(response: nil, player: nil)
      @response = response || Message.new
      set_attr player if player
    end

    def set_attr(input)
      @name = input[:name] if input[:name]
      @guesses = input[:guesses] if input[:guesses]
      @time_taken = input[:time_taken] if input[:time_taken]
      @date_played = input[:date_played] if input[:date_played]
    end

    def winner_response
      @response.winner(@name, @guesses, time).message
    end

    def time
      if @time_taken
        mins = @time_taken/60
        secs = @time_taken%60
        "#{mins}m#{secs}s"
      end
    end

    def to_h
      player = Hash.new(nil)
      player[:name] = @name
      player[:guesses] = @guesses
      player[:time_taken] = @time_taken
      player[:date_played] = @date_played
      player
    end
  end
end
