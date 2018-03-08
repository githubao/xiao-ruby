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

# 不带感叹号的方法 不改变原来的值
# 带感叹号的方法 会改变原来的值以及方法的拷贝
def step3
  a = [2, 3, 1]

  b = a.sort
  print(a, b)

  # b = a.sort!
  # print(a,b)

end

def step4
  reg = /[\d]+/
  num = '234'

  puts num.match reg

  ran = 1...3
  ran2 = 1..3

  ran.each {|x| print x}
  puts

  ran2.each {|x| print x}
  puts

end

# 228 189 160 229 165 189 10 229 143 175 228 187 165
# 你 好 \n 可 以
# 20320 22909 10 21487 20197
# 你好\n 可以
def step5
  s = "你好\n可以"
  s.each_byte {|b| print(b,' ')}
  puts
  s.each_char {|c| print(c,' ')}
  puts
  s.each_codepoint {|p| print(p,' ')}
  puts
  s.each_line {|l| print(l,' ')}
end

def main
  # step1
  # step2
  # step3
  # step4
  step5
end

main
