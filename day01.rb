# adventofcode 2022
# crushallhumans
# puzzle 1
# 12/1/2022

require "test/unit"
require "pp"



def basic_action(param_set_str, step_two = false)
    c = 0
    greatest = 0

    if param_set_str.kind_of?(Array)
        param_set = param_set_str
    else
        param_set = param_set_str.split("\n")
    end

    elves = [0]
    elves_ordered = [0]
    elves_idx = 0
    plen = param_set.length - 1
    for ii in param_set
        if $DEBUG then pp [ii, elves_idx, c, plen] end
        # had to figure out why the ii.nil/empty check was failing
        #   turns out File.readlines keeps the newlines!
        # => unless you add "chomp:true" to the invokation
        #if $DEBUG
        #    ii.each_byte do |c|
        #        puts "\t" + c.to_s
        #    end
        #end 

        # handle for when the last val in the list is significant
        if c == plen
            i = ii.to_i
            elves[elves_idx] += i
            ii = nil            
        end

        if ii.nil? || ii.empty?
            #if $DEBUG then puts elves_count_tuples[elves_idx] end
            if elves[elves_idx] > greatest
                greatest = elves[elves_idx]
            end
            if step_two
                d = 0
                this_elf = elves[elves_idx]
                finding = true
                until !finding
                    if !elves_ordered[d] || elves_ordered[d] >= this_elf
                        elves_ordered.insert(d, this_elf)
                        finding = false
                    end
                    d += 1
                end
                if $DEBUG then puts elves_ordered end
            end
            elves_idx += 1
            elves[elves_idx] = 0
        else
            i = ii.to_i
            elves[elves_idx] += i
        end
        c += 1
    end
    if !step_two
        return greatest
    else
        return elves_ordered.slice(-3,3).sum()
    end

end


def additional_action(param_set)
    return basic_action(param_set,true)
end




def puzzle_text()
    puts("""--- Day 1: Calorie Counting ---
Santa's reindeer typically eat regular reindeer food, but they need a lot of magical energy to deliver presents on Christmas. For that, their favorite snack is a special type of star fruit that only grows deep in the jungle. The Elves have brought you on their annual expedition to the grove where the fruit grows.

To supply enough magical energy, the expedition needs to retrieve a minimum of fifty stars by December 25th. Although the Elves assure you that the grove has plenty of fruit, you decide to grab any fruit you see along the way, just in case.

Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

The jungle must be too overgrown and difficult to navigate in vehicles or access from the air; the Elves' expedition traditionally goes on foot. As your boats approach land, the Elves begin taking inventory of their supplies. One important consideration is food - in particular, the number of Calories each Elf is carrying (your puzzle input).

The Elves take turns writing down the number of Calories contained by the various meals, snacks, rations, etc. that they've brought with them, one item per line. Each Elf separates their own inventory from the previous Elf's inventory (if any) by a blank line.

For example, suppose the Elves finish writing their items' Calories and end up with the following list:

1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
This list represents the Calories of the food carried by five Elves:

The first Elf is carrying food with 1000, 2000, and 3000 Calories, a total of 6000 Calories.
The second Elf is carrying one food item with 4000 Calories.
The third Elf is carrying food with 5000 and 6000 Calories, a total of 11000 Calories.
The fourth Elf is carrying food with 7000, 8000, and 9000 Calories, a total of 24000 Calories.
The fifth Elf is carrying one food item with 10000 Calories.
In case the Elves get hungry and need extra snacks, they need to know which Elf to ask: they'd like to know how many Calories are being carried by the Elf carrying the most Calories. In the example above, this is 24000 (carried by the fourth Elf).

Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?


--- Part Two ---
By the time you calculate the answer to the Elves' question, they've already realized that the Elf carrying the most Calories of food might eventually run out of snacks.

To avoid this unacceptable situation, the Elves would instead like to know the total Calories carried by the top three Elves carrying the most Calories. That way, even if one of those Elves runs out of snacks, they still have two backups.

In the example above, the top three Elves are the fourth Elf (with 24000 Calories), then the third Elf (with 11000 Calories), then the fifth Elf (with 10000 Calories). The sum of the Calories carried by these three elves is 45000.

Find the top three Elves carrying the most Calories. How many Calories are those Elves carrying in total?
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
        @test_set = """1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"""
    end

    def test_basic_action
        assert_equal(
            24000,
            basic_action(
                @test_set
            )
        )
    end

    def test_additional_action
        assert_equal(
            45000,
            additional_action(
                @test_set
            )
        )
    end


end

