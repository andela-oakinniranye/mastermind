module Mastermind
  class SaveGame
    attr_reader :datastore, :game_file, :saved_record
    SAVE_GAME_FILE = 'game_file.yml'
    def initialize(datastore: Datastore::YmlStore.instance, game_file: SAVE_GAME_FILE)
      @datastore = datastore
      @game_file = game_file

      @datastore.filename=@game_file
      load_records
    end

    def load_records
      @save_record = fetch_all_records || []
      @save_record.flatten!
      @save_record
    end

    def save_record(player)
      if player.is_a? Player
        player = player.to_h
      elsif player.is_a? Hash
        player
      else
        raise ArgumentError, 'Invalid player'
      end
      @datastore.save(@game_file, player, 'a+')
      load_records
    end

    def fetch_all_records
     @save_record = @datastore.fetch_multiple_records @game_file
     @save_record
    end

    def fetch_player(player_name)
      if player_name.is_a? Integer
        record = @save_record[player_name - 1]
      elsif player_name.is_a? String
        record = @save_record.select{ |record|
          record[:name].downcase == player_name.downcase
        }.first
      end
      return set_player_attr(record) if record
      false
    end

    def set_player_attr(record)
      player = Player.new
      player.set_save_attr(record)

      remove_data_from_save_record(record)
      player
    end

    def remove_data_from_save_record(record)
      @save_record.delete(record)
      save
    end

    def save
      @datastore.save(@game_file, @save_record)
    end

    def fetch_record(user_name)

    end
  end
end
