#!/usr/bin/env ruby

# create by xiaobao at 11:30 2018/3/6

=begin
  这是多行注释
  第一行
  第二行
  第三行
=end


def step1
  puts 'a
  b'

  puts "this is a multiline in ruby\
b"
end

def step2
  name = gets
  puts "Hello, #{name}"
end

def main
  # step1
  step2
end

main if $PROGRAM_NAME == __FILE__
