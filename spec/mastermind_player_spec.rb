require 'spec_helper'

describe Mastermind::Player do
  let(:mastermind_message){Mastermind::Message.new}
  let(:mastermind_player){Mastermind::Player.new(mastermind_message)}

  before(:each) do
    mastermind_player.stub(:get_input){"TestUser"}
    mastermind_player.stub(:send_message){}
  end

  it 'correctly sets name of the user' do
    mastermind_player.name = mastermind_player.get_input

    expect(mastermind_player.name).to eq "TestUser"
  end

  it 'correctly sets all attributes with a hash' do
    date = Date.today
    mastermind_player_attrs = {name: 'TestUser', trials: 10, time_taken: 3306, date_played: date}
    mastermind_player.set_attr(mastermind_player_attrs)

    expect(mastermind_player.name).to eq 'TestUser'
    expect(mastermind_player.trials).to be 10
    expect(mastermind_player.time_taken).to be 3306
    expect(mastermind_player.date_played).to be date
  end

  it 'correctly sets the attributes when passed at initialization' do
    date = Date.today
    mastermind_player_attrs = {name: 'TestUser', trials: 10, time_taken: 3306, date_played: date}
    mastermind_player = Mastermind::Player.new(mastermind_message, mastermind_player_attrs)

    expect(mastermind_player.name).to eq 'TestUser'
    expect(mastermind_player.trials).to be 10
    expect(mastermind_player.time_taken).to be 3306
    expect(mastermind_player.date_played).to be date
  end

  it 'correctly formats the time when the time method is called' do
    mastermind_player.time_taken = 3306

    expect(mastermind_player.time).to eq "55m6s"
  end

  it 'correctly sets the player record message, that would be used when the player is amongst the top 10' do
    date = Date.today
    mastermind_player_attrs = {name: 'TestUser', trials: 10, time_taken: 3306, date_played: date}
    mastermind_player.set_attr(mastermind_player_attrs)

    expect(mastermind_player.winner_record).to eq "TestUser completed mastermind in 55m6s"
  end
end
