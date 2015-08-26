require 'spec_helper'

describe Mastermind::TopTen do
  let(:mastermind_top_ten){Mastermind::TopTen.new}

  before(:each) do
    date = Date.today
    12.times{
      mastermind_top_ten.add_record name: 'TestUser', guesses: (1..30).to_a.sample, time_taken: (20..500).to_a.sample, date_played: date
    }
  end

  after(:each) do
    File.delete(mastermind_top_ten.file_name)
  end

  it 'should exist' do
    expect(mastermind_top_ten)
  end

  it 'should be able to fetch top_ten records' do
    expect(mastermind_top_ten.top_ten_records.count).to be 10
  end

  it 'should be able to add record and automatically sort to check if in the top ten' do
    date = Date.today
    mastermind_record_attrs = {name: 'TestUser', guesses: 1, time_taken: 2, date_played: date}
    mastermind_top_ten.add_record(mastermind_record_attrs)

    expect(mastermind_top_ten.top_ten_records.first).to eq mastermind_record_attrs
  end

  it 'should always return a player record when fetch/fetch_all is called' do
    expect(mastermind_top_ten.fetch(1)).to be_a Mastermind::Player
    expect(mastermind_top_ten.fetch_all.first).to be_a Mastermind::Player
  end

  it 'should always be arranged' do
    expect(mastermind_top_ten.top_ten_records.first[:guesses]).to be <= mastermind_top_ten.top_ten_records.last[:guesses]
  end

end
