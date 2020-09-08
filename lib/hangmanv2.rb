require 'json'

class Hangman
  def initialize()
  end

  def new_game()
    word = pick_word()
    @guesses = 10 #guesses needs to be saved
    board(word)
    display()
  end

  def load_game()
  end
  def save_game()
  end

  def play_round()
      puts "enter guess:"
      input = gets.chomp
      if input.length > 1
      input = input[0]
      end
      if @word_arr.include? input
        @word_arr.each_with_index do |val,ind|
          if input == val
            @display_board[ind] == val
          end
        end
      else
        @bad_guesses << input
        @guesses -= 1
      end
  end

  #this only generates a word to use
  def pick_word()
    dictionary = []
    File.open("5desk.txt").each do |line|
      if line.chomp.length > 4 && line.chomp.length < 11
        dictionary << line.downcase.chomp
      else
      end
    end
    word = dictionary[rand(0..dictionary.length)]
  end

  #this takes the word generated from pick_word and creates the word_arr and the empty board
  def board(word)
    @bad_guesses = [] #bad_guesses needs to be saved
    @word_arr = word.split("") #word_arr needs to be saved
    @display_board = [] #display board needs to be saved
    @word_arr.each do |x|
      @display_board << "_"
    end
  end

  def display()
    puts "#{@word_arr}"
    puts "#{@display_board}"
  end

  def won?()
    @won = false unless @word_arr == @display_board
  end

end

puts "welcome to Hangman"
puts "1. Newgame\n2. Loadgame"
new_or_load = gets.chomp
case new_or_load
when "1"
  player = Hangman.new.new_game()
when "2"
  player = Hangman.new.load_game()
else
  puts "invalid choice"
end


