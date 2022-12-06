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
    ppd param_set

    # header or message block length
    n = step_two ? 14 : 4 
    last_n = []

    param_set.each_char do |i|
        signal_found = false
        last_n.append(i)
        ppd [i,last_n]

        # enough chars in the hopper to check for marker
        if c >= n-1
            # optimistic!
            signal_found = true
            check_hash = {}
            d = 0

            # check each char from rear of array
            last_n.reverse_each do |j|
                ppd [d, j,check_hash]

                # if we already have the key, it's not the marker
                if check_hash.key?(j)
                    ppd [j,'repeats']
                    signal_found = false
                    break
                end

                check_hash[j] = true

                # always break out after last n chars checked
                if d >= n-1
                    ppd [d,signal_found]
                    break
                end
                d += 1
            end
        end

        # final breakout if signal found
        if signal_found
            ppd [c,'found at']
            break
        end

        # don't keep the whole charray, chop it down to n*2 from the rear
        if last_n.length > n*2
            chopp = -1 * ((n*2) - 1)
            last_n = last_n[chopp..]
        end
        c += 1
    end

    # answer is operating counter + 1
    c + 1
end


def additional_action(param_set)
    basic_action(param_set, true)
end




def puzzle_text()
    puts("""--- Day 6: Tuning Trouble ---
The preparations are finally complete; you and the Elves leave camp on foot and begin to make your way toward the star fruit grove.

As you move through the dense undergrowth, one of the Elves gives you a handheld device. He says that it has many fancy features, but the most important one to set up right now is the communication system.

However, because he's heard you have significant experience dealing with signal-based systems, he convinced the other Elves that it would be okay to give you their one malfunctioning device - surely you'll have no problem fixing it.

As if inspired by comedic timing, the device emits a few colorful sparks.

To be able to communicate with the Elves, the device needs to lock on to their signal. The signal is a series of seemingly-random characters that the device receives one at a time.

To fix the communication system, you need to add a subroutine to the device that detects a start-of-packet marker in the datastream. In the protocol being used by the Elves, the start of a packet is indicated by a sequence of four characters that are all different.

The device will send your subroutine a datastream buffer (your puzzle input); your subroutine needs to identify the first position where the four most recently received characters were all different. Specifically, it needs to report the number of characters from the beginning of the buffer to the end of the first such four-character marker.

For example, suppose you receive the following datastream buffer:

mjqjpqmgbljsphdztnvjfqwrcgsmlb
After the first three characters (mjq) have been received, there haven't been enough characters received yet to find the marker. The first time a marker could occur is after the fourth character is received, making the most recent four characters mjqj. Because j is repeated, this isn't a marker.

The first time a marker appears is after the seventh character arrives. Once it does, the last four characters received are jpqm, which are all different. In this case, your subroutine should report the value 7, because the first start-of-packet marker is complete after 7 characters have been processed.

Here are a few more examples:

bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 5
nppdvjthqldpwncqszvftbrmjlhg: first marker after character 6
nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 10
zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 11
How many characters need to be processed before the first start-of-packet marker is detected?

--- Part Two ---
Your device's communication system is correctly detecting packets, but still isn't working. It looks like it also needs to look for messages.

A start-of-message marker is just like a start-of-packet marker, except it consists of 14 distinct characters rather than 4.

Here are the first positions of start-of-message markers for all of the above examples:

mjqjpqmgbljsphdztnvjfqwrcgsmlb: first marker after character 19
bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 23
nppdvjthqldpwncqszvftbrmjlhg: first marker after character 23
nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 29
zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 26
How many characters need to be processed before the first start-of-message marker is detected?

""")
end

def z_actual_problem()
    filename_script = File.basename(__FILE__)
    puts (filename_script)
    filename = filename_script.split(/\./)[0]
    dirname = File.dirname(__FILE__)
    inputname = "%s/inputs/%s_input.txt" % [dirname,filename]
    puts inputname
    input_set = File.readlines(inputname, chomp:true).pop()

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
        @test_set = [
            ['mjqjpqmgbljsphdztnvjfqwrcgsmlb',7,19],
            ['bvwbjplbgvbhsrlpgdmjqwftvncz',5,23],
            ['nppdvjthqldpwncqszvftbrmjlhg',6,23],
            ['nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg',10,29],
            ['zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw',11,26]
        ]
    end

    def test_basic_action
        @test_set.each do |i|
            assert_equal(
                i[1],
                basic_action(
                    i[0]
                )
            )
        end
    end

    def test_additional_action
        @test_set.each do |i|
            assert_equal(
                i[2],
                additional_action(
                    i[0]
                )
            )
        end
    end


end

