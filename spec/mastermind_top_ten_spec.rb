require 'spec_helper'

describe Mastermind::TopTen do
  let(:mastermind_message){Mastermind::Message.new}
  let(:mastermind_player){Mastermind::Player.new(mastermind_message)}

  before(:each) do
    mastermind_player.stub(:get_input){"TestUser"}
    mastermind_player.stub(:send_message){}
  end

end
