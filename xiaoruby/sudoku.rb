#!/usr/bin/env ruby

# create by xiaobao at 18:10 2018/3/6

require 'set'

# 数独的解法：
# 寻找所有没有填写的方块，哪个只有一种可能性就直接填写进去。
# 如果没有一种可能性的情况，就找到可能性最小的情况，先填写进去然后再填写其他的
# 如果推出矛盾，那么再试验其他的情况
#
# 数独的个数：
# 将旋转，对称，数字映像等操作得出的结果都视为同一个的情况下，共5472730538个。
#
module Sudoku
  class Puzzle
    ASCII = '.123456789'.freeze
    BIN = "\000\001\002\003\004\005\006\007\010\011".freeze

    def initialize(lines)
      s = if lines.respond_to? :join
            lines.join
          else
            lines.dup
          end

      s.gsub!(/\s/, '')

      raise Invalid, 'Grid is the wrong size' unless s.size == 81

      i = s.index(/[^123456789.]/)
      raise Invalid, "Illegal character #{s[i, 1]} in puzzle" if i

      s.tr!(ASCII, BIN)

      @grid = s.unpack('c*')

      raise Invalid, 'Initial puzzle has duplicates' if duplicates?

    end

    def to_s
      (0..8).collect {|r| @grid[r * 9, 9].pack('c9')}.join('\n').tr(BIN, ASCII)
    end

    def pretty_print
      arr = to_s.split('\n')
      puts "#{'*' * 3} sln #{'*' * 3}"

      arr.each_with_index do |s, idx|
        puts if (idx % 3).zero? && idx != 0
        puts "#{s[0..2]} #{s[3..5]} #{s[6..8]}"
      end

      puts "#{'*' * 3} sln #{'*' * 3}"
    end

    def dup
      copy = super
      @grid = @grid.dup
      copy
    end

    #
    # def [](row, col)
    #   @grid[row * 9 + col]
    # end

    def []=(row, col, new_val)
      raise Invalid, 'Illegal cell value' unless (0..9).cover? new_val
      @grid[row * 9 + col] = new_val
    end

    BoxOfIndex = [
        0, 0, 0, 1, 1, 1, 2, 2, 2, 0, 0, 0, 1, 1, 1, 2, 2, 2, 0, 0, 0, 1, 1, 1, 2, 2, 2,
        3, 3, 3, 4, 4, 4, 5, 5, 5, 3, 3, 3, 4, 4, 4, 5, 5, 5, 3, 3, 3, 4, 4, 4, 5, 5, 5,
        6, 6, 6, 7, 7, 7, 8, 8, 8, 6, 6, 6, 7, 7, 7, 8, 8, 8, 6, 6, 6, 7, 7, 7, 8, 8, 8
    ].freeze

    def each_unknown
      0.upto(8) do |row|
        0.upto(8) do |col|
          index = row * 9 + col
          next if @grid[index] != 0
          box = BoxOfIndex[index]
          yield row, col, box
        end
      end
    end

    def duplicates?
      0.upto(8) {|row| return true if rowdigits(row).uniq!}
      0.upto(8) {|col| return true if coldigits(col).uniq!}
      0.upto(8) {|box| return true if boxdigits(box).uniq!}
      false
    end

    AllDigits = [1, 2, 3, 4, 5, 6, 7, 8, 9].freeze

    def possible(row, col, box)
      AllDigits - (rowdigits(row) + coldigits(col) + boxdigits(box))
    end

    private

    def rowdigits(row)
      # puts "flag: #{@grid[row * 9, 9]}"
      @grid[row * 9, 9] - [0]
    end

    def coldigits(col)
      result = []

      col.step(80, 9) do |i|
        v = @grid[i]
        result << v if v != 0
      end
      result
    end

    BoxToIndex = [0, 3, 6, 27, 30, 33, 54, 57, 60].freeze

    def boxdigits(box)
      i = BoxToIndex[box]
      [
          @grid[i], @grid[i + 1], @grid[i + 2],
          @grid[i + 9], @grid[i + 10], @grid[i + 11],
          @grid[i + 18], @grid[i + 19], @grid[i + 20]
      ] - [0]
    end
  end

  class Invalid < StandardError
  end

  class Impossible < StandardError
  end

  def self.scan(puzzle)
    unchanged = false

    until unchanged
      unchanged = true
      rmin, cmin, pmin = nil
      min = 10

      puzzle.each_unknown do |row, col, box|
        p = puzzle.possible(row, col, box)
        case p.size
          when 0
            raise Impossible
          when 1
            puzzle[row, col] = p[0]
            unchanged = false
          else
            if unchanged && p.size < min
              min = p.size
              rmin = row
              cmin = col
              pmin = p
            end
        end
      end
    end
    [rmin, cmin, pmin]
  end

  def self.solve(puzzle)
    puzzle = puzzle.dup
    r, c, p = scan(puzzle)
    return puzzle if r.nil?

    p.each do |guess|
      puzzle[r, c] = guess

      begin
        return solve(puzzle)
      rescue Impossible
        next
      end

    end

    raise Impossible
  end

end

def run
  puzzle = Sudoku.solve(Sudoku::Puzzle.new(ARGF.readlines))
  puzzle.pretty_print
end

def tmp
  s = "123\n456\n789"
  puts s.split("\n")
end

def tmp2
  arr = [123_456_789, 234_567_891, 345_678_912]
  arr2 = arr.map(&:to_s)
  arr2.each {|s| printf('%s %s %s\n', s[0..2], s[3..5], s[6..8])}
  # arr.each {|s| puts s.to_s[0..2]}
end

def tmp3
  # arr = Array(0..80)
  # puts arr.sample(4)
  # 1000.times {puts rand(81)}
  1000.times {puts rand(0..80)}
end

def generate
  count = 3

  File.open('C:\\Users\\xiaobao\\Desktop\\sudoku.txt', 'w') do |fw|
    uniq = Set.new([])

    count.times do
      s = '.' * 81

      # 随机数据
      seeds = Array(1..9).sample(9)
      idxs = Array(0..80).sample(9)
      idxs.zip(seeds) {|idx, seed| s[idx] = seed.to_s}

      # 一种解法的可能性
      puzzle = Sudoku.solve(Sudoku::Puzzle.new(s))

      # 把结果添加到set里面
      uniq.add(puzzle.to_s.gsub!('\n', ''))
    end

    # 简单打印
    # uniq.each {|line| fw.write("#{line}\n")}

    # 按照格式打印
    uniq.each_with_index do |line, num|
      fw.write("\n#{'*' * 3}\t#{format('%03d', (num + 1))}\t#{'*' * 3}\n")
      line.each_char.with_index do |char, idx|
        fw.write("\t") if (idx % 3).zero? && idx != 0 && !(idx % 9).zero?
        fw.write("\n") if (idx % 9).zero? && idx != 0
        # fw.write("\n") if (idx % 27).zero? && idx != 0
        fw.write(char.to_s)
      end
      fw.write("\n")
    end

    puts "#{uniq.size} sudoku generated"

  end
end

def main
  # run
  # tmp
  # tmp2
  # tmp3
  generate
end

main


# .23 4.6 ..9
# 4.6 ... .2.
# 7.9 1.3 4..
# .34 .67 8.1
# ..7 8.1 .34
# 8.1 ..4 5.7
# 3.5 .78 .12
# 67. .12 3.5
# 9.2 .45 .78

# ... ... ...
# ... ... ...
# ... ... ...
# ... ... ...
# ... ... ...
# ... ... ...
# ... ... ...
# ... ... ...
# ... ... ...

# 123 456 789
# 456 789 123
# 789 123 456
# 234 567 891
# 567 891 234
# 891 234 567
# 345 678 912
# 678 912 345
# 912 345 678