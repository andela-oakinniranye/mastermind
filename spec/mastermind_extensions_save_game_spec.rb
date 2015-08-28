require 'spec_helper'

describe Mastermind::SaveGame do
  let(:test_file){ 'save_game_test.yml' }
  let(:mastermind_save_game){ Mastermind::SaveGame.new(game_file: test_file) }
  let(:time_started){ Time.now.to_i - 200 }
  let(:player){ {name: 'TestUser', time_started: time_started, color_combo: 'RRYGB'.split(''), guesses_at_pause_count: 6, time_at_game_save: Time.now.to_i} }

  after(:each) do
    File.delete(test_file) if File.exists? test_file
  end

  it 'should be able to save player data or hash passed to it' do
    mastermind_save_game.save_record(player)

    expect(File.exists? test_file).to be true
  end

  it 'should be able to correctly fetch player data' do
    number_of_records_to_add = 12
    number_of_records_to_add.times{ mastermind_save_game.save_record(player) }
    unique_record = {name: 'JackDummy', time_started: time_started, color_combo: 'RRYGB'.split(''), guesses_at_pause_count: 6, time_at_game_save: Time.now.to_i}
    mastermind_save_game.save_record(unique_record)

    expect(mastermind_save_game.fetch_player('jackdummy').name).to eq unique_record[:name]
  end

  it 'should be able to correctly fetch player data with an id' do
    number_of_records_to_add = 12
    number_of_records_to_add.times{ mastermind_save_game.save_record(player) }
    unique_record = {name: 'JackDummy', time_started: time_started, color_combo: 'RRYGB'.split(''), guesses_at_pause_count: 6, time_at_game_save: Time.now.to_i}
    mastermind_save_game.save_record(unique_record)

    player = mastermind_save_game.fetch_player(13)
    expect(player.name).to eq unique_record[:name]
    expect(player).to be_a Mastermind::Player
  end

  it 'should not overwrite the file when new record is added' do
    number_of_records_to_add = 12
    number_of_records_to_add.times{ mastermind_save_game.save_record(player) }

    expect(mastermind_save_game.fetch_all_records.count).to eq number_of_records_to_add
  end

end
