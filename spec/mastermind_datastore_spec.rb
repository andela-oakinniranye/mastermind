require 'spec_helper'

describe Mastermind::Datastore do

  let(:mastermind_datastore){Mastermind::Datastore.instance}
  let(:file){'data_store'}

  after(:each) do
    File.delete(file)
  end

  it 'should be able to create if not exist' do
    mastermind_datastore.create_file_if_not_exist file

    expect(File.exists? file).to be true
  end

  it 'should be able to save yml files' do
    record = []
    date = Date.today
    12.times{
      record <<  {name: 'TestUser', guesses: (1..30).to_a.sample, time_taken: (20..500).to_a.sample, date_played: date }
    }
    mastermind_datastore.save_yml record, file

    file_content = File.open(file, 'r')
    expect(file_content.read).to include 'TestUser'
  end

  it 'should be able to load file with data stored in yml' do
    record = []
    date = Date.today
    12.times{
      record <<  {name: 'TestUser', guesses: (1..30).to_a.sample, time_taken: (20..500).to_a.sample, date_played: date }
    }
    mastermind_datastore.save_yml record, file

    data = mastermind_datastore.fetch_yml file

    expect(data).to eq record
  end

  it 'should be able to persist data to database' do
    skip
  end
end
