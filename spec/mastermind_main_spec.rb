require 'spec_helper'

describe Mastermind::Main do
  let(:mastermind_main){Mastermind::Main.new}
  let(:mastermind_message){Mastermind::Message.new}

  before(:each) do
    # mastermind_main.stub(:get_input){''}
    mastermind_main.stub(:send_message){}
  end

  it 'sets the response attribute' do
    expect(mastermind_main.response).to be_a Mastermind::Message
  end

  it 'can quit main' do
    mastermind_main.stub(:get_input){'q'}
    # mastermind_main.game.stub(:get_input){mastermind_main.game.colors}
    mastermind_main.start

    expect(mastermind_main.response.message).to eq(mastermind_message.exit_game.message)
  end

  it 'can get the instructions' do
    skip
    mastermind_main.stub(:get_input){['i', 'w'].sample}
    mastermind_main.start
  end

end
