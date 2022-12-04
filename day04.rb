# adventofcode 2022
# crushallhumans
# puzzle 4
# 12/4/2022

require "test/unit"
require "pp"
require 'set'

def ppd(var)
    if $DEBUG 
        pp var
    end
end

def basic_action(param_set, step_two = false)
    c = 0
    elf_assignments = []
    num_contains = 0
    for ii in param_set
        pair_sets = []
        a,b = ii.split(',')
        [a,b].each do |i|
            aa,bb = i.split('-')
            r = Range.new(aa,bb)
            pair_sets.append(r.to_set)
        end
        if step_two
            if (pair_sets[0] == pair_sets[1] ||
                pair_sets[0].intersect?(pair_sets[1]) || 
                pair_sets[1].intersect?(pair_sets[0]))
                num_contains += 1
            end
        else
            if (pair_sets[0] == pair_sets[1] ||
                pair_sets[0].proper_subset?(pair_sets[1]) || 
                pair_sets[1].proper_subset?(pair_sets[0]))
                num_contains += 1
            end
        end
#        ppd [ii,pair_sets]
        elf_assignments.append(pair_sets)
    end
#    ppd elf_assignments
    num_contains
end


def additional_action(param_set)
    basic_action(param_set, true)
end




def puzzle_text()
    puts("""--- Day 4: Camp Cleanup ---
Space needs to be cleared before the last supplies can be unloaded from the ships, and so several Elves have been assigned the job of cleaning up sections of the camp. Every section has a unique ID number, and each Elf is assigned a range of section IDs.

However, as some of the Elves compare their section assignments with each other, they've noticed that many of the assignments overlap. To try to quickly find overlaps and reduce duplicated effort, the Elves pair up and make a big list of the section assignments for each pair (your puzzle input).

For example, consider the following list of section assignment pairs:

2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
For the first few pairs, this list means:

Within the first pair of Elves, the first Elf was assigned sections 2-4 (sections 2, 3, and 4), while the second Elf was assigned sections 6-8 (sections 6, 7, 8).
The Elves in the second pair were each assigned two sections.
The Elves in the third pair were each assigned three sections: one got sections 5, 6, and 7, while the other also got 7, plus 8 and 9.
This example list uses single-digit section IDs to make it easier to draw; your actual list might contain larger numbers. Visually, these pairs of section assignments look like this:

.234.....  2-4
.....678.  6-8

.23......  2-3
...45....  4-5

....567..  5-7
......789  7-9

.2345678.  2-8
..34567..  3-7

.....6...  6-6
...456...  4-6

.23456...  2-6
...45678.  4-8
Some of the pairs have noticed that one of their assignments fully contains the other. For example, 2-8 fully contains 3-7, and 6-6 is fully contained by 4-6. In pairs where one assignment fully contains the other, one Elf in the pair would be exclusively cleaning sections their partner will already be cleaning, so these seem like the most in need of reconsideration. In this example, there are 2 such pairs.

In how many assignment pairs does one range fully contain the other?

--- Part Two ---
It seems like there is still quite a bit of duplicate work planned. Instead, the Elves would like to know the number of pairs that overlap at all.

In the above example, the first two pairs (2-4,6-8 and 2-3,4-5) don't overlap, while the remaining four pairs (5-7,7-9, 2-8,3-7, 6-6,4-6, and 2-6,4-8) do overlap:

5-7,7-9 overlaps in a single section, 7.
2-8,3-7 overlaps all of the sections 3 through 7.
6-6,4-6 overlaps in a single section, 6.
2-6,4-8 overlaps in sections 4, 5, and 6.
So, in this example, the number of overlapping assignment pairs is 4.

In how many assignment pairs do the ranges overlap?

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
        @test_set = '2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8'
    end

    def test_basic_action
        assert_equal(
            2,
            basic_action(
                @test_set.split("\n")
            )
        )
    end

    def test_additional_action
        assert_equal(
            2,
            additional_action(
                @test_set.split("\n")
            )
        )
    end


end

