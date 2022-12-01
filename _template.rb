# adventofcode 2022
# crushallhumans
# puzzle N
# 12/N/2022

require "test/unit"
require "pp"



def basic_action(param_set)
    c = 99999
    greater_than = 0
    for ii in param_set
        i = ii.to_i
        if i > c
            greater_than += 1
        end
        c = i
    end
    return greater_than
end


def additional_action(param_set)
    c = 0
    d = 0

    window_len = 2
    sums = []

    # build windowed sums: for each index of param_set, count forward to window_len, summing
    (0..param_set.length).step(1) do |i|
        if $DEBUG then puts i end
        isum = 0
        (c..c+window_len).step(1) do |jj|
            unless param_set[jj].nil? 
                j = param_set[jj].to_i
                if $DEBUG then puts "\t%d" % [j] end
                isum += j
            end
        end
        if $DEBUG then puts "\t\t%d" % [isum] end
        sums.append(isum)
        if $DEBUG then puts "\n" end
        c += 1
    end

#    puts sums

    # find greatest
    c = 99999999
    for i in sums
        if i > c
            d += 1
        end
        c = i
    end
    return d
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
        @test_set = [
            199,
            200,
            208,
            210,
            200,
            207,
            240,
            269,
            260,
            263
        ]
    end

    def test_basic_action
        assert_equal(
            7,
            basic_action(
                @test_set
            )
        )
    end

    def test_additional_action
        assert_equal(
            5,
            additional_action(
                @test_set
            )
        )
    end


end

