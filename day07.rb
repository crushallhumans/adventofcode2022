# adventofcode 2022
# crushallhumans
# puzzle 7
# 12/7/2022

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
    cwd = []
    cwd_key = ''
    max_dir_size = 100000
    total_fs_size = 70000000
    needed_fs_size = 30000000
    files_hash = {}
    for ii in param_set
        ia = ii.chars.to_a
        #ppd ia
        if ia[0] == '$'
            ia.shift(2)
            if ia[0..1].join('') == 'cd'
                ia.shift(3)
                dir = ia.join('')
                if dir == '..'
                    cwd.pop()
                else
                    cwd.append(dir)
                end
                ppd ['cd',cwd]
            elsif ia[0..1].join('') == 'ls'
                cwd_key = cwd.join('/')
            end
        else 
            ppd ['ls',cwd_key]
            if !files_hash.key?(cwd_key)
                files_hash[cwd_key] = []
            end
            node = ii.split(' ')
            if ia[0] == 'd'
                n = cwd.dup
                n.append(node[1])
                new_dir = n.join('/')
                if !files_hash.key?(new_dir)
                    files_hash[new_dir] = []
                end
                files_hash[cwd_key].append(['d',new_dir])
            else
                files_hash[cwd_key].append(node)
            end
        end
        ppd files_hash
    end

    dir_totals = {}
    files_hash.sort_by{|k,v| k.length}.reverse.each do |k,v|
        ppd ['fh: ',k,v]
        if !dir_totals.key?(k)
            dir_totals[k] = 0
        end
        v.each do |i|
            if i[0] != 'd'
                dir_totals[k] += i[0].to_i
            elsif dir_totals.key?(i[1])
                dir_totals[k] += dir_totals[i[1]]
            end
        end
        if dir_totals[k] <= max_dir_size
            ppd ['adding',dir_totals[k]]
            c += dir_totals[k]
        end
    end
    ppd ['dir_totals',dir_totals]

    current_fs_used = dir_totals['/']
    space_needed = needed_fs_size - (total_fs_size - current_fs_used)

    to_delete = current_fs_used
    dir_totals.sort_by{|k,v| v}.reverse.each do |k,v|
        ppd ['delete',k,v]
        if v < space_needed
            break
        end
        to_delete = v
    end

    if step_two
        return to_delete
    end
    c
end


def additional_action(param_set)
    basic_action(param_set, true)
end




def puzzle_text()
    puts("""--- Day 7: No Space Left On Device ---
You can hear birds chirping and raindrops hitting leaves as the expedition proceeds. Occasionally, you can even hear much louder sounds in the distance; how big do the animals get out here, anyway?

The device the Elves gave you has problems with more than just its communication system. You try to run a system update:

$ system-update --please --pretty-please-with-sugar-on-top
Error: No space left on device
Perhaps you can delete some files to make space for the update?

You browse around the filesystem to assess the situation and save the resulting terminal output (your puzzle input). For example:

$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
The filesystem consists of a tree of files (plain data) and directories (which can contain other directories or files). The outermost directory is called /. You can navigate around the filesystem, moving into or out of directories and listing the contents of the directory you're currently in.

Within the terminal output, lines that begin with $ are commands you executed, very much like some modern computers:

cd means change directory. This changes which directory is the current directory, but the specific result depends on the argument:
cd x moves in one level: it looks in the current directory for the directory named x and makes it the current directory.
cd .. moves out one level: it finds the directory that contains the current directory, then makes that directory the current directory.
cd / switches the current directory to the outermost directory, /.
ls means list. It prints out all of the files and directories immediately contained by the current directory:
123 abc means that the current directory contains a file named abc with size 123.
dir xyz means that the current directory contains a directory named xyz.
Given the commands and output in the example above, you can determine that the filesystem looks visually like this:

- / (dir)
  - a (dir)
    - e (dir)
      - i (file, size=584)
    - f (file, size=29116)
    - g (file, size=2557)
    - h.lst (file, size=62596)
  - b.txt (file, size=14848514)
  - c.dat (file, size=8504156)
  - d (dir)
    - j (file, size=4060174)
    - d.log (file, size=8033020)
    - d.ext (file, size=5626152)
    - k (file, size=7214296)
Here, there are four directories: / (the outermost directory), a and d (which are in /), and e (which is in a). These directories also contain files of various sizes.

Since the disk is full, your first step should probably be to find directories that are good candidates for deletion. To do this, you need to determine the total size of each directory. The total size of a directory is the sum of the sizes of the files it contains, directly or indirectly. (Directories themselves do not count as having any intrinsic size.)

The total sizes of the directories above can be found as follows:

The total size of directory e is 584 because it contains a single file i of size 584 and no other directories.
The directory a has total size 94853 because it contains files f (size 29116), g (size 2557), and h.lst (size 62596), plus file i indirectly (a contains e which contains i).
Directory d has total size 24933642.
As the outermost directory, / contains every file. Its total size is 48381165, the sum of the size of every file.
To begin, find all of the directories with a total size of at most 100000, then calculate the sum of their total sizes. In the example above, these directories are a and e; the sum of their total sizes is 95437 (94853 + 584). (As in this example, this process can count files more than once!)

Find all of the directories with a total size of at most 100000. What is the sum of the total sizes of those directories?

--- Part Two ---
Now, you're ready to choose a directory to delete.

The total disk space available to the filesystem is 70000000. To run the update, you need unused space of at least 30000000. You need to find a directory you can delete that will free up enough space to run the update.

In the example above, the total size of the outermost directory (and thus the total amount of used space) is 48381165; this means that the size of the unused space must currently be 21618835, which isn't quite the 30000000 required by the update. Therefore, the update still requires a directory with total size of at least 8381165 to be deleted before it can run.

To achieve this, you have the following options:

Delete directory e, which would increase unused space by 584.
Delete directory a, which would increase unused space by 94853.
Delete directory d, which would increase unused space by 24933642.
Delete directory /, which would increase unused space by 48381165.
Directories e and a are both too small; deleting them would not free up enough space. However, directories d and / are both big enough! Between these, choose the smallest: d, increasing unused space by 24933642.

Find the smallest directory that, if deleted, would free up enough space on the filesystem to run the update. What is the total size of that directory?


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
        @test_set = '$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k'
    end

    def test_basic_action
        assert_equal(
            95437,
            basic_action(
                @test_set.split("\n")
            )
        )
    end

    def test_additional_action
        assert_equal(
            24933642,
            additional_action(
                @test_set.split("\n")
            )
        )
    end


end

