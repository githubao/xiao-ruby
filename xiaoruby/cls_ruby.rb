#!/usr/bin/env ruby

# create by xiaobao at 16:43 2018/3/6

class Sequence
  include Enumerable

  def initialize(from, to, by)
    @from, @to, @by = from, to, by
  end

  def each
    x = @from
    while x <= @to
      yield x
      x += @by
    end
  end

  def length
    return 0 if @from > @to
    Integer((@to - @from) / @by) + 1
  end

  alias size length

  def [](index)
    return nil if index < 0
    v = @from + index * @by
    v if v <= @to
  end

  def *(factor)
    Sequence.new(@from * factor, @to * factor, @by * factor)
  end

  def +(offset)
    Sequence.new(@from + offset, @to + offset, @by)
  end

  def to_s
    "Sequence{#{@from}, #{@to}, #{@by}}"
  end

end

module Sequences
  def self.fromtoby(from, to, by)
    x = from
    while x <= to
      yield x
      x += by
    end
  end
end

def step1
  s = Sequence.new(1, 10, 2)
  s.each {|x| print x}
  puts
  puts s[s.size - 1]
  t = (s + 1) * 4
  puts t.to_s
end

class Range
  def by(step)
    x = self.begin
    if exclude_end?
      while x < self.end
        yield x
        x += step
      end
    else
      while x <= self.end
        yield x
        x += step
      end
    end
  end
end

def step2
  Sequences.fromtoby(1, 10, 2) {|x| print x}
end

def step3
  (1...10).by(2) {|x| print x}
end

def main
  # step1
  # step2
  step3
end

main
