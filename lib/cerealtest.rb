require 'yaml'

class Dooto

  attr_accessor :first, :second, :third

  def initialize()
    @first = []
    @second = []
    @third = []
  end

  def change_data()
    puts "enter some numbers first arr"
    input = gets.chomp
    @first = input.split("")
    puts "enter some numbers second arr"
    input = gets.chomp
    @second = input.split("")
    puts "enter some numbers third arr"
    input = gets.chomp
    @third = input.split("")
  end

  def output()
    puts "#{@first}"
    puts "#{@second}"
    puts "#{@third}"
  end

  def saving()
    Dir.mkdir("tester") unless Dir.exists? "tester"
    puts "enter save file name"
    filename = gets.chomp
    File.open("tester/#{filename}.yml", "w") do |serialize|
      game = (YAML::dump({
        first: @first,
        second: @second,
        third: @third,
      }))
      serialize.puts game
    end
  end

  def loading()
    puts "enter filename"
    answer = gets.chomp
    if File.exists? "tester/#{answer}.yml"
      saved = YAML::load File.read("tester/#{answer}.yml")
      @first = saved[:first]
      @second = saved[:second]
      @third = saved[:third]
    else
      puts "file :#{answer} doesnt exists"
    end
  end



end


game = Dooto.new()
puts "1.New or 2.saved"
x = gets.chomp
case x
when "1"
  game.change_data()
  game.output()
  game.saving()
when "2"
  game.loading()
  game.output()
else
  puts "invalid"
end



