#!/usr/bin/env ruby

# create by xiaobao at 18:10 2018/3/6


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

      if i = s.index(/[^123456789\.]/)
        raise Invalid, "Illegal character #{s[i, 1]} in puzzle"
      end

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
      arr.each {|s| puts "#{s[0..2]} #{s[3..5]} #{s[6..8]}"}
      puts "#{'*' * 3} sln #{'*' * 3}"
    end

    def dup
      copy = super
      @grid = @grid.dup
      copy
    end

    def [](row, col)
      @grid[row * 9 + col]
    end

    def []=(row, col, new_val)
      unless (0..9).include? new_val
        raise Invalid, 'Illegal cell value'
      end
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
      @grid[row * 9, 9] - [0]
    end

    def coldigits(col)
      result = []

      col.step(80, 9) {|i|
        v = @grid[i]
        result << v if v != 0
      }
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
              rmin, cmin, pmin = row, col, p
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

def main
  puzzle = Sudoku.solve(Sudoku::Puzzle.new(ARGF.readlines))
  puzzle.pretty_print
end

def tmp
  s = "123\n456\n789"
  puts s.split("\n")
end

def tmp2
  arr = [123456789, 234567891, 345678912]
  arr2 = arr.map(&:to_s)
  arr2.each {|s| printf('%s %s %s\n', s[0..2], s[3..5], s[6..8])}
  # arr.each {|s| puts s.to_s[0..2]}
end

main
# tmp2

# .23 4.6 ..9
# 4.6 ... .2.
# 7.9 1.3 4..
# .34 .67 8.1
# ..7 8.1 .34
# 8.1 ..4 5.7
# 3.5 .78 .12
# 67. .12 3.5
# 9.2 .45 .78

# 123 456 789
# 456 789 123
# 789 123 456
# 234 567 891
# 567 891 234
# 891 234 567
# 345 678 912
# 678 912 345
# 912 345 678