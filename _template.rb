# adventofcode 2022
# crushallhumans
# puzzle N
# 12/N/2022

require 'test/unit'
require 'pp'
require 'set'

def ppd(var)
  if $DEBUG 
    pp var
  end
end



def basic_action(param_set, step_two = false)
  c = 0
  for ii in param_set
    c += 1
  end
  if step_two
    c += 1
  end
  c
end


def additional_action(param_set)
  basic_action(param_set, true)
end




def puzzle_text()
  puts("""
""")
end

def z_actual_problem()
  filename_script = File.basename(__FILE__)
  puts (filename_script)
  filename = filename_script.split(/\./)[0]
  dirname = File.dirname(__FILE__)
  inputname = "%s/inputs/%s_input.txt" % [dirname,filename]
  puts inputname
  input_set = File.readlines(inputname, chomp:true)

  ret = basic_action(input_set)
  puts ("Part 1: " + ret.to_s)

  ret = additional_action(input_set)
  puts ("Part 2: " + ret.to_s)
  return 0
end



$DEBUG = false
$PROBLEM_TEST = false
if ARGV[0] == 'DEBUG' || ARGV[1] == 'DEBUG'
  $DEBUG = true
end
if ARGV[0] == 'PUZZLE'
  puzzle_text()
  exit()
end
if ARGV[0] == 'GO'
  z_actual_problem()
  exit()
end


class TestSimpleNumber < Test::Unit::TestCase
  def setup
    @test_set = 'a
b
c'
  end

  def test_basic_action
    assert_equal(
      3,
      basic_action(
        @test_set.split("\n")
      )
    )
  end

  def test_additional_action
    assert_equal(
      4,
      additional_action(
        @test_set.split("\n")
      )
    )
  end


end

