module Mastermind
  class TopTen
    attr_reader :top_ten_records, :player_records, :file_name, :response
    FILE_NAME = 'topten.yaml'
    MAXIMUM_TOP = 10

    def initialize(response: nil, file_name: FILE_NAME)
      @response = response || Message.new
      @file_name = file_name

      create_file_if_not_exist file_name
      load_top_ten
    end

    def create_file_if_not_exist(file_name)
      File.open(file_name, 'w') unless File.exists? file_name
    end

    def load_top_ten
      @top_ten_records = ::YAML::load_file(@file_name) || []
      arrange_top_ten
      fetch_all
    end

    def add_record(player)
      if player.is_a? Player
        player = player.to_h
      elsif player.is_a? Hash
        player
      else
        raise ArgumentError, 'Unsupported Player Value'
      end
      @top_ten_records << player
      arrange_top_ten
      save
    end

    def arrange_top_ten
      @top_ten_records.sort!{ |x, y|
          [x[:guesses], x[:time_taken]] <=> [y[:guesses], y[:time_taken]]
      }
      @top_ten_records = @top_ten_records.slice(0, MAXIMUM_TOP)
    end

    def fetch_all
      @player_records = []
      @top_ten_records.each{ |val|
        @player_records << fetch(val)
      }
      @player_records
    end

    def fetch number_or_hash
      if number_or_hash.is_a? Hash
        record = number_or_hash
      elsif number_or_hash.is_a? Integer
        record = @top_ten_records[number_or_hash - 1]
      end
      player = Player.new(player: record)
      player
    end

    def save
      File.open(@file_name, 'w') do |yml_data|
        YAML.dump @top_ten_records, yml_data
      end
      load_top_ten
    end

  end
end
