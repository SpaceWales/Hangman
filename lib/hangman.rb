#import list of words from 5desk
#select random line (word) between 5-12 letters
#get count for tries
#update display to show letters and their place
#show incorrect letters that have been chosen
#every turn, player gets to make a guess
#update display,
#end game if player runs out of turns
#add ability to save gave, serialization export it to a document
#name the save file maybe?
#add ability to load game at the start

#require 'json'
require 'yaml'
#calling new when trying to retrieve save implements all the methods and fucks it up
class Hangman
  #add save file in here, 
  #also maybe ability to start a new game
  attr_accessor :name, :word_arr, :hidden_arr, :tries, :bad_guess, 

  def initialize()
  end

  def newgame()
    @tries = tries()
    @play_word = usable_word()
    start_round(@play_word)
    @won = false
  end

  def tries()
    num = 0
    puts "Tries: default (D) = 7, enter a custom number (C) or randomly generated (R) between 5-15"
    response = gets.chomp.downcase
    case response
    when "d"
      num = 7
    when "c"
      puts "enter custom number"
      num = gets.chomp.to_i
    when "r"
      num = rand(5..15)
    else
      puts "you gave me #{response}, which i have no idea what to do with"
    end
    puts "#{num} tries it is."
    num
  end

  def usable_word()
    dic = []
    File.open("5desk.txt").each do |line|
      dic << line.chomp
    end
    usable = false
    while !usable
      rand_num = rand(0..dic.size)
      if dic[rand_num].length > 5 && dic[rand_num].length < 12
        usable = true
        good = dic[rand_num]
      else
        puts "#{dic[rand_num]}, length of #{dic[rand_num].length}, was rejected"
        usable = false
      end
    end
    good.downcase
  end

  def start_round(word)
    @word_arr = word.split("")
    @hidden_arr = []
    @bad_guess = []
    @word_arr.each do |x|
      @hidden_arr << "_"
    end 
    p @word_arr
    p @hidden_arr
    puts "the round has been initialized!"
  end  

  def check_play(letter)
    if letter.length > 1
      letter = letter[0]
    end
    if @word_arr.include? letter
      @word_arr.each_with_index do |v,k|
        if letter == v
          @hidden_arr[k] = letter
        end
      end
    else
      @bad_guess << letter
      @tries -= 1
    end
  end

  def check_win()
    if @hidden_arr == @word_arr
      @won = true
    else
      @won = false
    end
  end

  def play_round()
    while !@won 
      check_win()
      puts "Current board: #{@hidden_arr.join()}"
      puts "Current guesses: #{@bad_guess.join(",")}"
      puts "Current tries: #{@tries}"
      puts "enter guess: \n type 'save' if you'd like to save your game"
      @guess = gets.chomp
      if @guess == "save"
        save_game()
        @guess = ""
        exit
      end
      check_play(@guess)
      check_win()
    end

    if @tries == 0 && @won == false
      puts "ahh too bad, lost"
      puts "word was #{@word_arr.join()}"
    end
    if @tries > 0 && @won == true
      puts "Hey you won!"
      puts "#{@hidden_arr.join()}"
    end
  end

  def save_game()
    puts "what is the name to save"
    @name = gets.chomp
    Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
    File.open("saved_games/#{@name}_save.yml","w") do |srl|
      game = (YAML::dump({
        name: @name,
        word_arr: @word_arr,
        hidden_arr: @hidden_arr,
        tries: @tries,
        bad_guess: @bad_guess,
      }))
      srl.puts game
      end
    end
  end

  public
  def load_game()
    puts "what was the name of your save file"
    name = gets.chomp
    if File.exists? "saved_games/#{name}.yml"
      saved = YAML::load File.read("saved_games/#{name}.yml")
      @name = saved[:name]
      @word_arr = saved[:word_arr]
      @hidden_arr = saved[:hidden_arr]
      @tries = saved[:tries]
      @bad_guess = saved[:bad_guess]
    else
      puts "file doesnt exist"
  end

  #def save_game()   
  #  File.open("saved_games/#{@name}_save.json","w") do |f|
  #    f.write(to_json)
  #  end 
  #  puts "thanks for playing! \n your game will (hopefully) be here when you get back"
  #  exit
  #end
  
  #def to_json(*a)
  #  {
  #    "@name" => @name,
  #    "@tries" => @tries,
  #    "@word_arr" => @word_arr,
  #    "@hidden_arr" => @hidden_arr,
  #    "@bad_guess" => @bad_guess,
  #  }.to_json(*a)
  #end
  #hash is coming from outside class

end

#def retrieve_save(name)
#  file = File.read("saved_games/#{name}_save.json")
#  data_hash = JSON.parse(file)
#  puts "retrieved: #{data_hash}"
#end



puts "welcome to HangMan"
puts "New Game: N\nSaved Game: S\n"
new_or_saved = gets.chomp.downcase
if new_or_saved == "s"
  player = Hangman.new()
  player.load_game()
  player.play_round()
else
  player = Hangman.new()
  player.newgame()
  player.play_round()
end











