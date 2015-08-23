require 'spec_helper'

describe Mastermind::Main do
  let(:mastermind_main){Mastermind::Main.new}

  it 'can start new game' do
    # Mastermind::Main.stub(:gets).with('w')

    # mastermind_main.start.should_receive(:puts).with("Welcome to MASTERMIND!\nWould you like to (p)lay, read the (i)nstructions, or (q)uit?").and_return(nil)
    # expect(mastermind_main.start).to receive("Welcome to MASTERMIND!\nWould you like to (p)lay, read the (i)nstructions, or (q)uit?")
  end

end
