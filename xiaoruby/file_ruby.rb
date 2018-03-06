#!/usr/bin/env ruby

# create by xiaobao at 14:46 2018/3/6


def step1
  filename = 'C:\\Users\\xiaobao\\Desktop\\data.txt'

  File.open(filename) do |f|
    lines = f.readlines
    lines.each do |line|
      # printf("#{line}\n")
      print line
    end
  end
end

def step2
  my_minimum = lambda {|x, y|
    if x < y
      x
    else
      y
    end}

  min = my_minimum.call(3, 5)

  puts min
end

def main
  # step1
  step2
end

main
