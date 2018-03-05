# step1

def step1
  a = 3 ** 4
  puts a

  b = Math.sqrt(a)
  puts b

end


# step2

# 单引号就是原始的字符串，双引号会进行#{}替换
def hello(name = 'world')
  puts "Hello, #{name.capitalize}!"
end

def step2
  hello
  hello 'xiaobao'
end


# step3

class Greeting

  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def say_hi
    puts "Hi, #{@name}!"
  end

  def say_bye
    puts "Bye #{@name}, come back soon."
  end
end

# 符号对象 :name 前面加上冒号保证id值的唯一
# 实例变量 @name，类变量 @@name
def step3
  greet = Greeting.new('xiaobao')
  # greet.say_hi
  # greet.say_bye

  # puts Greeting.instance_methods(false)

  puts greet.respond_to?('name') # getter
  puts greet.respond_to?('name=') # setter
  puts greet.respond_to?('say_hi')
  puts greet.respond_to?('to_s')

end

class MegaGreeter
  attr_accessor :names

  def initialize(names = "world")
    @names = names
  end

  def say_hi
    if @names.nil?
      puts "..."
    elsif @names.respond_to?('each')
      @names.each do |name|
        puts "Hello #{name}!"
      end
    else
      puts "Hello #{names}!"
    end
  end

  def say_bye
    if @names.nil?
      puts "..."
    elsif @names.respond_to?("join")
      puts "GoodBye #{@names.join(', ')}. Come back soon!"
    else
      puts "GoodBye #{@names}. Come back soon!"
    end
  end

end

def step4
  if __FILE__ == $0
    mg = MegaGreeter.new
    mg.say_hi
    mg.say_bye

    mg.names = ['xiaobao', 'xiaoyu']
    mg.say_hi
    mg.say_bye

  end
end

def main
  # step1
  # step2
  # step3
  step4
end

main