require 'spec_helper'

describe Mastermind::Message do
  let(:mastermind_message){Mastermind::Message.new}
  let(:colors){['(r)ed', '(g)reen', '(b)lue', '(y)ellow']}

  it 'correctly sets attributes' do
    mastermind_message.set_attr(message: 'You win!', status: :won)

    expect(mastermind_message.message).to eq('You win!')
    expect(mastermind_message.status).to be(:won)
  end

  it 'has message for a new game' do
    message = "Welcome to MASTERMIND!\nWould you like to #{'(p)lay'.colorize(:green)}, read the #{'(i)nstructions'.colorize(:blue)}, read a little #{'(b)ackground'.colorize(:yellow)} on Mastermind or #{'(q)uit'.colorize(:red)}?"
    mastermind_message.start

    expect(mastermind_message.message).to eq message
  end

  it 'has message for the number of trials' do
    mastermind_message.trial_count(5, colors)

    expect(mastermind_message.message).to eq "You have tried 5 times. You have 7 attempts left.\nTry again: "
  end

  it 'can get instruction message' do
    mastermind_message.instructions(colors)

    expect(mastermind_message.message).to include "I have generated a beginner sequence with"
  end
end
