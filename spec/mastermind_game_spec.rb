require 'spec_helper'

module Mastermind
  class Game
    def generate_test_colors
      @character_count = 4
      @colors = 'RRGB'
    end
  end
end

describe Mastermind::Game do
  let(:mastermind_message){Mastermind::Message.new}
  let(:mastermind_game){Mastermind::Game.new(mastermind_message)}
  # include_context 'rake'
  # let(:get_input) { stub('rrgb')}

  it 'can analyze inputs passed to it' do
    mastermind_game.play
    guess_analysis = mastermind_game.analyze_guess('RBGB')

    expect(guess_analysis).to be_a Hash
  end

  it 'can correctly analyze the guess' do
    mastermind_game.generate_test_colors
    guess_analysis = mastermind_game.analyze_guess('RRGB')
    expect(guess_analysis[:match_position].length).to be 4
    expect(guess_analysis[:almost_match].length).to be 4
  end

  it 'does not have any color set until play is called' do
    expect(mastermind_game.colors).to eq nil

    mastermind_game.play

    expect(mastermind_game.colors.length).to be 4
  end

  it 'generate random colors' do
    mastermind_game.generate_colors

    expect(mastermind_game.colors.length).to be 4;
  end

  it 'generate test colors' do
    mastermind_game.generate_test_colors

    expect(mastermind_game.colors).to eq 'RRGB';
  end

  it 'can get gameplay instruction message' do
    expect(mastermind_game.instructions).to eq "I have generated a beginner sequence with four elements made up of:\n(r)ed, (g)reen, (b)lue, and (y)ellow. Use (q)uit at any time to end the game.\nWhat's your guess? "
  end

  it 'can start a new game' do
    mastermind_game.play

    expect(mastermind_game.colors.length).to be 4
  end

  it 'can quit started game' do
    mastermind_game.play
    message = mastermind_game.quit_game

    expect(mastermind_game.colors).to eq []
    expect(message).to eq mastermind_message.exit_game.message
  end

  it 'changes the colors at every call to play' do
    mastermind_game.play
    color_1 = mastermind_game.colors
    mastermind_game.play
    color_2 = mastermind_game.colors

    expect(color_1).to_not eq color_2
  end

  it 'has method:won to set when game is won' do
    mastermind_game.won(Time.now.to_i)

    expect(mastermind_game.response.status).to eq :won
    expect(mastermind_game.response.message).to include "Congratulations!\nYou won the game"
  end

  it 'can win game when guessed color is the color generated' do
    mastermind_game.generate_test_colors
    analyzed = mastermind_game.analyze_guess('RRGB')

    expect(mastermind_game.check_correct?(analyzed)).to be true
  end

  it 'can try to guess colors' do
    color_array = %w{ R G B Y }
    color_guesses = []
    12.times{
      colors = ''
      4.times{ colors << color_array.sample }
      color_guesses << colors
    }

    mastermind_game.stub(:get_input){color_guesses.sample}

    mastermind_game.game_process

    expect(mastermind_game.response.message)
  end

  it 'sends a response if sequence is longer' do
    mastermind_game.stub(:get_input){"RYBGY"}

    mastermind_game.game_process

    expect(mastermind_game.response.message).to eq("Your input is too long.")
    expect(mastermind_game.response.status).to eq :longer_input
  end

  it 'sends a response if sequence is longer' do
    mastermind_game.stub(:get_input){"RY"}

    mastermind_game.game_process

    expect(mastermind_game.response.message).to eq("Your input is too short.")
    expect(mastermind_game.response.status).to eq :shorter_input
  end
end
