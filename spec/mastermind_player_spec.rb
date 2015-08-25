require 'spec_helper'

describe Mastermind::Player do
  let(:mastermind_message){Mastermind::Message.new}
  let(:mastermind_player){Mastermind::Player.new(response: mastermind_message)}

  before(:each) do
    allow(mastermind_player).to receive(:get_input).and_return('TestUser')
    allow(mastermind_player).to receive(:send_message).and_return(nil)
  end

  it 'correctly sets name of the user' do
    data = {}
    data[:name] = mastermind_player.get_input
    mastermind_player.set_attr data

    expect(mastermind_player.name).to eq "TestUser"
  end

  it 'correctly sets all attributes with a hash' do
    date = Date.today
    mastermind_player_attrs = {name: 'TestUser', guesses: 10, time_taken: 3306, date_played: date}
    mastermind_player.set_attr(mastermind_player_attrs)

    expect(mastermind_player.name).to eq 'TestUser'
    expect(mastermind_player.guesses).to be 10
    expect(mastermind_player.time_taken).to be 3306
    expect(mastermind_player.date_played).to be date
  end

  it 'correctly sets the attributes when passed at initialization' do
    date = Date.today
    mastermind_player_attrs = {name: 'TestUser', guesses: 10, time_taken: 3306, date_played: date}
    mastermind_player = Mastermind::Player.new(response: mastermind_message, player: mastermind_player_attrs)

    expect(mastermind_player.name).to eq 'TestUser'
    expect(mastermind_player.guesses).to be 10
    expect(mastermind_player.time_taken).to be 3306
    expect(mastermind_player.date_played).to be date
  end

  it 'correctly formats the time when the time method is called' do
    data = {}
    data[:time_taken] = 3306
    mastermind_player.set_attr data

    expect(mastermind_player.time).to eq "55m6s"
  end

  it 'correctly sets the player record message, that would be used when the player is amongst the top 10' do
    date = Date.today
    mastermind_player_attrs = {name: 'TestUser', guesses: 10, time_taken: 3306, date_played: date}
    mastermind_player.set_attr(mastermind_player_attrs)

    expect(mastermind_player.winner_response).to eq "TestUser completed mastermind in 10 guesses and 55m6s"
  end

  it 'turns data to a Hash when #to_h is called on the object' do
    date = Date.today
    mastermind_player_attrs = {name: 'TestUser', guesses: 10, time_taken: 3306, date_played: date}
    mastermind_player.set_attr(mastermind_player_attrs)

    mastermindplayerhash = mastermind_player.to_h
    expect(mastermindplayerhash).to be_a Hash
    expect(mastermindplayerhash).to eq mastermind_player_attrs
  end
end
