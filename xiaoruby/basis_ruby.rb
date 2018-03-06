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

def step3
  a = [1, 2]
  a[4] = 3
  print(a)
end

def step4
  a = [2, 3, 4]
  sum = a.inject(0) {|res, item| res + item}
  puts sum
end

def step5
  a = [2, 3, 4]
  # even = a.inject([]) {|res, item| res << item.to_s}
  # even = a.inject([]) {|res, item| item if item % 2 == 0}
  even = a.select {|item| item if item.even?}
  odd = a.reject {|item| item if item.even?}
  print even
  print odd
end

def step6
  array = [['A', 'a'], ['B', 'b'], ['C', 'c']]

  hash = array.each_with_object({}) do |item, dic|
    dic[item[0]] = item[1]
  end

  puts hash
end

def step7
  dic = {:A => 'append', :B => 'bell'}
  puts dic
end

def step8
  s = 'abc'
  s.freeze
  # s[2] = 'd'
  puts s
end

# 除了nil，都是true
def step9
  s = ''
  if s
    print 'true'
  else
    print 'false'
  end
end

def step10
  s = [1, 2, 3]
  p s
  puts s
end

def main
  # step1
  # step2
  # step4
  # step5
  # step6
  # step7
  # step8
  # step9
  step10
end

main if $PROGRAM_NAME == __FILE__
