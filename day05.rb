# adventofcode 2022
# crushallhumans
# puzzle 5
# 12/5/2022

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
    raw_stacks = []
    instruction_params = param_set.dup
    param_set.each do |ii|
        raw_stack = []
        if ii.empty? || ii == ''
            instruction_params.shift()
            break
        end
        j = 1
        while j < ii.length do
            raw_stack.append(ii[j])
            j += 4
        end
        raw_stacks.append(raw_stack)
        instruction_params.shift()
        c += 1
    end
    ppd raw_stacks

    len = raw_stacks.pop()
    num_stacks = len.pop().to_i

    stacks = Array.new(num_stacks){[]}
    ppd stacks

    d = 0
    raw_stacks.reverse.each do |ii|
        (0..num_stacks-1).each do |jj|
            ppd jj
            j = ii[jj]
            if j != ' '
                stacks[jj].append(j)
            end
        end
        d += 1
    end

    ppd stacks

    ppd instruction_params

    instruction_params.each do |ii|
        move_amt, open_col, shut_col = ii.match(/^move (\d+) from (\d+) to (\d+)/).captures
        ppd [move_amt, open_col, shut_col]
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
        @test_set = '    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2'
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

