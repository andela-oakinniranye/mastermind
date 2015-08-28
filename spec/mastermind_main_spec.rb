require 'spec_helper'

describe Mastermind::Main do
  let(:mastermind_main){Mastermind::Main.new}
  let(:mastermind_message){Mastermind::Message.new}

  before(:each) do
    allow(mastermind_main).to receive(:send_message).and_return(nil)
  end

  it 'sets the response attribute' do
    expect(mastermind_main.response).to be_a Mastermind::Message
  end

  it 'can quit main' do
    allow(mastermind_main).to receive(:get_input).and_return('q')

    mastermind_main.start

    expect(mastermind_main.response.message).to eq(mastermind_message.exit_game.message)
  end

  it 'can get the instructions' do
    skip
    allow(mastermind_main).to receive(:get_input).and_return('i')
    mastermind_main.start
  end

end
