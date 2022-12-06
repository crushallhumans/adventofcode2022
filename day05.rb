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
    ppd ii
    while j < ii.length do
      ppd [j,ii[j]]
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
      if !j.nil? && j != ' '
        stacks[jj].append(j)
      end
    end
    d += 1
  end

  ppd stacks

  ppd instruction_params

  instruction_params.each do |ii|
    move_amt, open_col, shut_col = ii.match(/^move (\d+) from (\d+) to (\d+)/).captures.map{|i| i.to_i}
    open_col -= 1
    shut_col -= 1
    ppd [move_amt, open_col, shut_col]
    d = 0
    if step_two
      #stacks[shut_col].append(stacks[open_col].pop(move_amt))
      n = stacks[open_col].pop(move_amt)
      if n.is_a? (String)
        n = [n]
      end
      n.each {|nn| stacks[shut_col].append(nn)}
    else
      (0..move_amt-1).each do |j|
        ppd "%d, %d: moving 1 from %d to %d" % [d, j, open_col,shut_col]
        stacks[shut_col].append(stacks[open_col].pop())
        ppd stacks
        d += 1
      end
    end
  end

  ppd stacks
  c = ''
  stacks.each do |i|
    c += i.pop()
  end

  c
end


def additional_action(param_set)
  basic_action(param_set, true)
end




def puzzle_text()
  puts("""--- Day 5: Supply Stacks ---
The expedition can depart as soon as the final supplies have been unloaded from the ships. Supplies are stored in stacks of marked crates, but because the needed supplies are buried under many other crates, the crates need to be rearranged.

The ship has a giant cargo crane capable of moving crates between stacks. To ensure none of the crates get crushed or fall over, the crane operator will rearrange them in a series of carefully-planned steps. After the crates are rearranged, the desired crates will be at the top of each stack.

The Elves don't want to interrupt the crane operator during this delicate procedure, but they forgot to ask her which crate will end up where, and they want to be ready to unload them as soon as possible so they can embark.

They do, however, have a drawing of the starting stacks of crates and the rearrangement procedure (your puzzle input). For example:

    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
In this example, there are three stacks of crates. Stack 1 contains two crates: crate Z is on the bottom, and crate N is on top. Stack 2 contains three crates; from bottom to top, they are crates M, C, and D. Finally, stack 3 contains a single crate, P.

Then, the rearrangement procedure is given. In each step of the procedure, a quantity of crates is moved from one stack to a different stack. In the first step of the above rearrangement procedure, one crate is moved from stack 2 to stack 1, resulting in this configuration:

[D]        
[N] [C]    
[Z] [M] [P]
 1   2   3 
In the second step, three crates are moved from stack 1 to stack 3. Crates are moved one at a time, so the first crate to be moved (D) ends up below the second and third crates:

        [Z]
        [N]
    [C] [D]
    [M] [P]
 1   2   3
Then, both crates are moved from stack 2 to stack 1. Again, because crates are moved one at a time, crate C ends up below crate M:

        [Z]
        [N]
[M]     [D]
[C]     [P]
 1   2   3
Finally, one crate is moved from stack 1 to stack 2:

        [Z]
        [N]
        [D]
[C] [M] [P]
 1   2   3
The Elves just need to know which crate will end up on top of each stack; in this example, the top crates are C in stack 1, M in stack 2, and Z in stack 3, so you should combine these together and give the Elves the message CMZ.

After the rearrangement procedure completes, what crate ends up on top of each stack?


--- Part Two ---
As you watch the crane operator expertly rearrange the crates, you notice the process isn't following your prediction.

Some mud was covering the writing on the side of the crane, and you quickly wipe it away. The crane isn't a CrateMover 9000 - it's a CrateMover 9001.

The CrateMover 9001 is notable for many new and exciting features: air conditioning, leather seats, an extra cup holder, and the ability to pick up and move multiple crates at once.

Again considering the example above, the crates begin in the same configuration:

    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 
Moving a single crate from stack 2 to stack 1 behaves the same as before:

[D]        
[N] [C]    
[Z] [M] [P]
 1   2   3 
However, the action of moving three crates from stack 1 to stack 3 means that those three moved crates stay in the same order, resulting in this new configuration:

        [D]
        [N]
    [C] [Z]
    [M] [P]
 1   2   3
Next, as both crates are moved from stack 2 to stack 1, they retain their order as well:

        [D]
        [N]
[C]     [Z]
[M]     [P]
 1   2   3
Finally, a single crate is still moved from stack 1 to stack 2, but now it's crate C that gets moved:

        [D]
        [N]
        [Z]
[M] [C] [P]
 1   2   3
In this example, the CrateMover 9001 has put the crates in a totally different order: MCD.

Before the rearrangement process finishes, update your simulation so that the Elves know where they should stand to be ready to unload the final supplies. After the rearrangement procedure completes, what crate ends up on top of each stack?


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
      'CMZ',
      basic_action(
        @test_set.split("\n")
      )
    )
  end

  def test_additional_action
    assert_equal(
      'MCD',
      additional_action(
        @test_set.split("\n")
      )
    )
  end


end

