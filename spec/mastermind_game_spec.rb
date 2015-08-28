require 'spec_helper'

describe Mastermind::Game do
  let(:mastermind_message){Mastermind::Message.new}
  let(:mastermind_game){Mastermind::Game.new(mastermind_message)}

  before(:each) do
    allow(mastermind_game).to receive(:generate_colors).and_return(mastermind_game.generate_test_colors)
    allow(mastermind_game).to receive(:get_input).and_return('RRGB')
    allow(mastermind_game).to receive(:send_message).and_return(nil)
  end

  it 'can analyze inputs passed to it' do
    mastermind_game.generate_colors
    guess_analysis = mastermind_game.analyze_guess('RBGB')

    expect(guess_analysis).to be_a Hash
  end

  it 'can correctly analyze the guess' do
    mastermind_game.generate_test_colors
    guess_analysis = mastermind_game.analyze_guess('RRGB')
    expect(guess_analysis[:match_position]).to be 4
    expect(guess_analysis[:almost_match]).to be 0
  end

  it 'always ensures that the matched position and almost match are 4 for colors included in the colors' do
    mastermind_game.generate_colors
    guess_analysis = mastermind_game.analyze_guess('RRGB')
    guess_analysis_2 = mastermind_game.analyze_guess('TTTT')

    expect(guess_analysis[:match_position]).to be 4
    expect(guess_analysis[:almost_match]).to be 0
    expect(guess_analysis[:match_position] + guess_analysis[:almost_match]).to be 4
    expect(guess_analysis_2[:match_position] + guess_analysis_2[:almost_match]).to be 0
  end

  it 'does not have any color set until play is called' do
    mastermind_game = Mastermind::Game.new(mastermind_message)
    allow(mastermind_game).to receive(:send_message).and_return(nil)

    expect(mastermind_game.colors).to eq nil

    allow(mastermind_game).to receive(:game_process).and_return(nil)
    allow(mastermind_game).to receive(:get_input).and_return('RRGB')

    mastermind_game.play

    expect(mastermind_game.colors.length).to be 4
  end

  it 'generate random colors' do
    mastermind_game.generate_colors

    expect(mastermind_game.colors.length).to be 4;
  end

  it 'generate test colors' do
    mastermind_game.generate_test_colors

    expect(mastermind_game.colors).to eq 'RRGB'.split('');
  end

  it 'can get gameplay instruction message' do
    expect(mastermind_game.instructions).to include "I have generated a beginner sequence with"
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
    mastermind_game = Mastermind::Game.new(mastermind_message)
    allow(mastermind_game).to receive(:get_input).and_return('RRGB')
    allow(mastermind_game).to receive(:send_message).and_return(nil)
    allow(mastermind_game).to receive(:game_process).and_return(nil)

    mastermind_game.play
    color_1 = mastermind_game.colors
    mastermind_game.play
    color_2 = mastermind_game.colors

    expect(color_1).to_not eq color_2
  end

  it 'has method:won to set when game is won' do
    allow(mastermind_game.top_ten_record).to receive(:add_record).and_return(nil)

    mastermind_game.get_player
    mastermind_game.won(Time.now.to_i)

    expect(mastermind_game.response.status).to eq :won
    expect(mastermind_game.response.message).to include "#{'Congratulations!'.colorize(:green)}\nYou won the game in"
  end

  it 'can win game when guessed color is the color generated' do
    allow(mastermind_game).to receive(:won).and_return(Time.now.to_i)

    mastermind_game.generate_test_colors
    analyzed = mastermind_game.analyze_guess('RRGB')

    expect(mastermind_game.check_correct?(analyzed)).to be true
  end

  it 'can try to guess colors' do
    allow(mastermind_game).to receive(:get_input).and_return('RRGB')
    mastermind_game.play

    expect(mastermind_game.response.message).to include("#{'Congratulations!'.colorize(:green)}\nYou won the game in")
  end

  it 'can cheat while playing the game' do
    allow(mastermind_game).to receive(:get_input).and_return('c')

    mastermind_game.play

    expect(mastermind_game.response.status).to be :cheated
    expect(mastermind_game.response.message).to include "Hmm! You just cheated. The colors generated were: #{mastermind_game.colors.join}."
  end

  it 'sends a response if sequence is longer' do
    allow(mastermind_game).to receive(:get_input).and_return('RGGYY')

    mastermind_game.too_long?(mastermind_game.get_input)

    expect(mastermind_game.response.message).to eq("Your input is too long.".colorize(:red))
    expect(mastermind_game.response.status).to eq :longer_input
  end

  it 'sends a response if sequence is shorter' do
    allow(mastermind_game).to receive(:get_input).and_return('RY')

    mastermind_game.too_short?(mastermind_game.get_input)

    expect(mastermind_game.response.message).to eq("Your input is too short.".colorize(:red))
    expect(mastermind_game.response.status).to eq :shorter_input
  end

end
