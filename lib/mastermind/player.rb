module Mastermind
  class Player
    include Default
    attr_reader :response, :record
    attr_accessor :name, :trials, :time_taken, :date_played

    def initialize(response, player_data = nil)
      @response = response
      set_attr player_data if player_data
    end

    def set_attr(input)
      @name = input[:name] if input[:name]
      @trials = input[:trials] if input[:trials]
      @time_taken = input[:time_taken] if input[:time_taken]
      @date_played = input[:date_played] if input[:date_played]
    end

    def winner_record
      #implement record saving logic
      @response.winner(@name, time).message
    end

    def time
      if @time_taken
        mins = @time_taken/60
        secs = @time_taken%60
        "#{mins}m#{secs}s"
      end
    end
  end
end
