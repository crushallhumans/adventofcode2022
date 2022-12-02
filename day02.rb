# frozen_string_literal: true

# adventofcode 2022
# crushallhumans
# puzzle 2
# 12/2/2022

require 'test/unit'

def basic_action(param_set, step_two = false)
  # z scissors y paper x rock
  # reverse results by position, value at [5]
  #  0: win, 1: draw, 2: lose
  mapping = {'Z' => ['Y','Z','X',3,6,2], 'Y' => ['X','Y','Z',2,3,1], 'X' => ['Z','X','Y',1,0,0], 'A' => 'X', 'B' => 'Y', 'C' => 'Z'}
  game_score = 0
  param_set.each do |ii|
    oppo_move, self_move = ii.split(' ')

    if !step_two
      match_score = mapping[self_move][3]
      if mapping[self_move][0] == mapping[oppo_move] # win
        match_score += 6
      elsif mapping[oppo_move] == self_move #draw
        match_score += 3
      end
    
      pp [oppo_move, self_move, match_score] if $DEBUG
    else
      # x lose y draw z win
      oppo_move_find_result = mapping[oppo_move]
      match_score = mapping[self_move][4] # win lose or draw
      self_move_correct = mapping[oppo_move_find_result][mapping[self_move][5]] # find correct self move
      match_score += mapping[self_move_correct][3] # value of choice

      pp [oppo_move, self_move, oppo_move_find_result, self_move_correct, mapping[self_move_correct], mapping[oppo_move_find_result], match_score] if $DEBUG
    end

    game_score += match_score
  end
  game_score

end

def additional_action(param_set)
  basic_action(param_set,true)
end


def puzzle_text()
  p = <<~'HEREDOC'
  --- Day 2: Rock Paper Scissors ---
  The Elves begin to set up camp on the beach. To decide whose tent gets to be closest to the snack storage, a giant Rock Paper Scissors tournament is already in progress.

  Rock Paper Scissors is a game between two players. Each game contains many rounds; in each round, the players each simultaneously choose one of Rock, Paper, or Scissors using a hand shape. Then, a winner for that round is selected: Rock defeats Scissors, Scissors defeats Paper, and Paper defeats Rock. If both players choose the same shape, the round instead ends in a draw.

  Appreciative of your help yesterday, one Elf gives you an encrypted strategy guide (your puzzle input) that they say will be sure to help you win. "The first column is what your opponent is going to play: A for Rock, B for Paper, and C for Scissors. The second column--" Suddenly, the Elf is called away to help with someone's tent.

  The second column, you reason, must be what you should play in response: X for Rock, Y for Paper, and Z for Scissors. Winning every time would be suspicious, so the responses must have been carefully chosen.

  The winner of the whole tournament is the player with the highest score. Your total score is the sum of your scores for each round. The score for a single round is the score for the shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors) plus the score for the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won).

  Since you can't be sure if the Elf is trying to help you or trick you, you should calculate the score you would get if you were to follow the strategy guide.

  For example, suppose you were given the following strategy guide:

  A Y
  B X
  C Z
  This strategy guide predicts and recommends the following:

  In the first round, your opponent will choose Rock (A), and you should choose Paper (Y). This ends in a win for you with a score of 8 (2 because you chose Paper + 6 because you won).
  In the second round, your opponent will choose Paper (B), and you should choose Rock (X). This ends in a loss for you with a score of 1 (1 + 0).
  The third round is a draw with both players choosing Scissors, giving you a score of 3 + 3 = 6.
  In this example, if you were to follow the strategy guide, you would get a total score of 15 (8 + 1 + 6).

  What would your total score be if everything goes exactly according to your strategy guide?
  HEREDOC
  puts p
end

def z_actual_problem()
  filename_script = File.basename(__FILE__)
  puts (filename_script)
  filename = filename_script.split(/\./)[0]
  dirname = File.dirname(__FILE__)
  inputname = '%s/inputs/%s_input.txt' % [dirname,filename]
  puts inputname
  input_set = File.readlines(inputname, chomp:true)

  ret = basic_action(input_set)
  puts ('Part 1: ' + ret.to_s)

  ret = additional_action(input_set)
  puts ('Part 2: ' + ret.to_s)
  return 0
end

$DEBUG = false
$PROBLEM_TEST = false
$DEBUG = true if ARGV[0] == 'DEBUG' || ARGV[1] == 'DEBUG'
if ARGV[0] == 'PUZZLE'
  puzzle_text
  exit
end
if ARGV[0] == 'GO'
  z_actual_problem
  exit
end

class TestSimpleNumber < Test::Unit::TestCase
  def setup
    @test_set = 'A Y
B X
C Z'
  end

  def test_basic_action
    assert_equal(
      15,
      basic_action(
        @test_set.split("\n")
      )
    )
  end

  def test_additional_action
    assert_equal(
      12,
      additional_action(
        @test_set.split("\n")
      )
    )
  end


end

