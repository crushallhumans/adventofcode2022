# adventofcode 2022
# crushallhumans
# puzzle 8
# 12/8/2022

require 'test/unit'
require 'pp'
require 'set'
require 'matrix'

def ppd(var)
  if $DEBUG 
    pp var
  end
end




def basic_action(param_set, step_two = false)
  c = 0
  ppd param_set
  trees_w = param_set[0].length
  trees_h = param_set.length
  trees = Matrix.rows(param_set.map{ |i| i.chars.to_a})
  visible_trees = Matrix.rows(param_set.map{ |i| i.chars.to_a.map{0}})
  ppd trees
  ppd visible_trees

  visible = (trees_w * 2) + ((trees_h - 2) * 2)
  ppd visible

  # generate scans:
  # x
  # 0 -> [2,[1,1,5],[1,2,5],[1,3,1],2]
  # 1 -> [6,[2,1,5],[2,2,3],[2,3,3],2]
  # 2 -> [3,[3,1,3],[3,2,5],[3,3,4],9]
  # y
  # 3 -> [0,[1,1,5],[2,1,5],[3,1,3],5]
  # 4 -> [3,[1,2,5],[2,2,3],[3,2,5],3]
  # 5 -> [7,[1,3,1],[2,3,3],[3,3,4],9]

  scans = []
  x = 1
  y = 1
  Range.new(1,(trees_w-2)).each do
    sc = [trees[0,x].to_i]
    Range.new(1,(trees_h-2)).each do
      sc.append([y,x,trees[y,x].to_i])
      y += 1
    end
    sc.append(trees[y,x].to_i)
    scans.append(sc)
    x += 1
    y = 1
  end

  x = 1
  y = 1
  Range.new(1,(trees_h-2)).each do
    sc = [trees[y,0].to_i]
    Range.new(1,(trees_w-2)).each do
      sc.append([y,x,trees[y,x].to_i])
      x += 1
    end
    sc.append(trees[y,x].to_i)
    scans.append(sc)
    y += 1
    x = 1
  end

  ppd scans
  scans.each do |scan_do|
    max0 = scan_do.shift()
    max1 = scan_do.pop()
    scan_do.each do |s|
      if s[2] > max0
        max0 = s[2]
        visible_trees[s[0],s[1]] = 1
      end
      if s[2] == 9
        break
      end
    end
    scan_do.reverse.each do |s|
      if s[2] > max1
        max1 = s[2]
        visible_trees[s[0],s[1]] = 1
      end
      if s[2] == 9
        break
      end
    end
  end

  visible_trees.each do |vt|
    visible += vt
  end


  ppd visible_trees


  if step_two
    highest_scenic = 0
    Range.new(1,(trees_h-2)).each do |x|
        Range.new(1,(trees_w-2)).each do |y|
            scenic = calculate_scenic(trees, x, y, trees_w, trees_h)
            if scenic > highest_scenic
              highest_scenic = scenic 
            end
        end
    end
    return highest_scenic
  end
  visible
end


def calc_sight(trees,top,bottom,fixed,fixed_pos,sight,note)
  s = 0
  stepp = bottom == 0 ? -1 : 1

  ppd [note,top,bottom,fixed,fixed_pos,stepp]
  top.step(bottom,stepp).each do |f|
    y = (fixed_pos == 'y') ? fixed : f
    x = (fixed_pos == 'x') ? fixed : f
    t = trees[y,x].to_i
    s += 1
    ppd [f,y,x,t,sight]
    if t >= sight
      break
    end
  end
  s
end

def calculate_scenic(trees, x, y, trees_w, trees_h)
  ppd [x,y]
  sight = trees[y,x].to_i
  scenic = []
  w = trees_w - 1
  h = trees_h - 1
  [
    [y-1,0,x,'x',sight,"up"],
    [y+1,h,x,'x',sight,"down"],
    [x-1,0,y,'y',sight,"left"],
    [x+1,w,y,'y',sight,"right"],
  ].each do |a|
    scenic.append(calc_sight(trees,a[0],a[1],a[2],a[3],a[4],a[5]))
  end
  ppd [[y,x],sight,scenic,scenic.reduce(:*)]
  scenic.reduce(:*)
end


def additional_action(param_set)
  basic_action(param_set, true)
end




def puzzle_text()
  puts("""--- Day 8: Treetop Tree House ---
The expedition comes across a peculiar patch of tall trees all planted carefully in a grid. The Elves explain that a previous expedition planted these trees as a reforestation effort. Now, they're curious if this would be a good location for a tree house.

First, determine whether there is enough tree cover here to keep a tree house hidden. To do this, you need to count the number of trees that are visible from outside the grid when looking directly along a row or column.

The Elves have already launched a quadcopter to generate a map with the height of each tree (your puzzle input). For example:

30373
25512
65332
33549
35390


Each tree is represented as a single digit whose value is its height, where 0 is the shortest and 9 is the tallest.

A tree is visible if all of the other trees between it and an edge of the grid are shorter than it. Only consider trees in the same row or column; that is, only look up, down, left, or right from any given tree.

All of the trees around the edge of the grid are visible - since they are already on the edge, there are no trees to block the view. In this example, that only leaves the interior nine trees to consider:

The top-left 5 is visible from the left and top. (It isn't visible from the right or bottom since other trees of height 5 are in the way.)
The top-middle 5 is visible from the top and right.
The top-right 1 is not visible from any direction; for it to be visible, there would need to only be trees of height 0 between it and an edge.
The left-middle 5 is visible, but only from the right.
The center 3 is not visible from any direction; for it to be visible, there would need to be only trees of at most height 2 between it and an edge.
The right-middle 3 is visible from the right.
In the bottom row, the middle 5 is visible, but the 3 and 4 are not.
With 16 trees visible on the edge and another 5 visible in the interior, a total of 21 trees are visible in this arrangement.

Consider your map; how many trees are visible from outside the grid?

-- Part Two ---
Content with the amount of tree cover available, the Elves just need to know the best spot to build their tree house: they would like to be able to see a lot of trees.

To measure the viewing distance from a given tree, look up, down, left, and right from that tree; stop if you reach an edge or at the first tree that is the same height or taller than the tree under consideration. (If a tree is right on the edge, at least one of its viewing distances will be zero.)

The Elves don't care about distant trees taller than those found by the rules above; the proposed tree house has large eaves to keep it dry, so they wouldn't be able to see higher than the tree house anyway.

In the example above, consider the middle 5 in the second row:

30373
25512
65332
33549
35390
Looking up, its view is not blocked; it can see 1 tree (of height 3).
Looking left, its view is blocked immediately; it can see only 1 tree (of height 5, right next to it).
Looking right, its view is not blocked; it can see 2 trees.
Looking down, its view is blocked eventually; it can see 2 trees (one of height 3, then the tree of height 5 that blocks its view).
A tree's scenic score is found by multiplying together its viewing distance in each of the four directions. For this tree, this is 4 (found by multiplying 1 * 1 * 2 * 2).

However, you can do even better: consider the tree of height 5 in the middle of the fourth row:

30373
25512
65332
33549
35390
Looking up, its view is blocked at 2 trees (by another tree with a height of 5).
Looking left, its view is not blocked; it can see 2 trees.
Looking down, its view is also not blocked; it can see 1 tree.
Looking right, its view is blocked at 2 trees (by a massive tree of height 9).
This tree's scenic score is 8 (2 * 2 * 1 * 2); this is the ideal spot for the tree house.

Consider each tree on your map. What is the highest scenic score possible for any tree?



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
    @test_set = '30373
25512
65332
33549
35390'
  end

  def test_basic_action
    assert_equal(
      21,
      basic_action(
        @test_set.split("\n")
      )
    )
  end

  def test_additional_action
    assert_equal(
      8,
      additional_action(
        @test_set.split("\n")
      )
    )
  end


end

