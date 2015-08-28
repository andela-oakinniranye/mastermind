module Mastermind
  class TopTen
    attr_reader :top_ten_records, :player_records, :file_name, :response
    FILE_NAME = 'topten.yaml'
    MAXIMUM_TOP = 10

    def initialize(response: nil, file_name: FILE_NAME, storage: Datastore::YmlStore.instance)
      @response = response || Message.new
      @file_name = file_name
      @datastore = storage

      @datastore.create_file_if_not_exist @file_name
      load_top_ten
    end

    def load_top_ten
      @top_ten_records = @datastore.fetch_yml(@file_name) || []
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
      @datastore.save_top_ten @file_name, @top_ten_records
      load_top_ten
    end

  end
end
