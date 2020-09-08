#initialize empty, decide if new game or loaded game

require 'yaml'

class Hangman

  def initialize()
    @word = []
    @board = []
    @extra = []
    @guesses = 0
    @won = false
  end
  
  def new_game()
    @word = get_word()
    @board = set_new_board()
    puts "new game initialized"
  end

  def set_new_board()
    @word.each do |x|
      @board << "_"
    end
    return @board
  end
  
  def get_word()
    dictionary = []
    File.open("5desk.txt").each do |line|
      if line.chomp.length > 4 && line.chomp.length < 11
        dictionary << line.downcase.chomp
      else
      end
    end
    word = dictionary[rand(0..dictionary.length)]
    word_arr = word.split("") #if doesnt split into array declare return on this 
  end
  
  def load_game()
    puts "enter filename: "
    filename = gets.chomp
    if File.exists? "saved_games/#{filename}.yml"
      saved = YAML::load File.read("saved_games/#{filename}.yml")
      @word = saved[:word]
      @board = saved[:board]
      @guesses = saved[:guesses]
      @extra = saved[:extra]
    else
      puts "#{filename} not found"
    end
  end
  
  def save_game()
    Dir.mkdir ("saved_games") unless Dir.exists? "saved_games"
    puts "enter filename to save: "
    filename = gets.chomp
    File.open("saved_games/#{filename}.yml","w") do |serialize|
      game = (YAML::dump({
        word: @word,
        board: @board,
        guesses: @guesses,
        extra: @extra,
      }))
      serialize.puts game
    end
  end

  def round()
    puts "enter guess: "
    puts "enter \'save\' to save the game"
    char = gets.chomp #if longer than 1
    if char == "save"
      save_game()
      exit
    end
    while @extra.include? char
      puts "already used, try again: "
      char = gets.chomp
    end
    while @board.include? char
      puts "already used, try again: "
      char = gets.chomp
    end
    if @word.include? char
      @word.each_with_index do |v,k|
        if char == v
          @board[k] = char
        end
      end
    else
      @extra << char
      @guesses += 1
    end
  end

  def check_win()
    if @board.include? "_"
      @won = false
    else
      @won = true
    end
  end

  def play_game()
    until @guesses == 10 || @won
          puts "word: #{@word}"
          puts "board: #{@board}"
          puts "guesses: #{@guesses}"
          puts "extra: #{@extra}"
          check_win()
          round()
          check_win()
    end
    if @guesses == 10 && !@won
      puts "sorry you lost"
    end
    if @guesses < 10 && @won
      puts "hey you won!"
    end
  end

end

puts "welcome to Hangman (v3)"
puts "1.New Game\n2.Load Game"
ans = gets.chomp.to_i
case ans
when 1
  player = Hangman.new()
  player.new_game()
when 2 
  player = Hangman.new()
  player.load_game()
else
  puts "invalid choice"
end

player.play_game()




