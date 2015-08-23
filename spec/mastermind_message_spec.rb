require 'spec_helper'

describe Mastermind::Message do
  let(:mastermind_message){Mastermind::Message.new}

  it 'correctly sets attributes' do
    mastermind_message.set_attr(message: 'You win!', status: :won)

    expect(mastermind_message.message).to eq('You win!')
    expect(mastermind_message.status).to be(:won)
  end

  it 'has message for a new game' do
    message = "Welcome to MASTERMIND!\nWould you like to (p)lay, read the (i)nstructions, or (q)uit?"
    mastermind_message.start

    expect(mastermind_message.message).to eq message
  end

  it 'has message for the number of trials' do
    mastermind_message.trial_count(5)

    expect(mastermind_message.message).to eq "You have tried 5 time(s). You have 7 trial(s) left.\nTry again: "
  end

  it 'has message for exhausted limits' do
    mastermind_message.trial_count(12)

    expect(mastermind_message.message).to eq "You tried, but lost! Want to try again? "
  end

  it 'can get instruction message' do
    mastermind_message.instructions

    expect(mastermind_message.message).to eq "I have generated a beginner sequence with four elements made up of:\n(r)ed, (g)reen, (b)lue, and (y)ellow. Use (q)uit at any time to end the game.\nWhat's your guess? "
  end
end
