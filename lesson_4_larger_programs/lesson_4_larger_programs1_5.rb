# lesson_4_larger_programs1_5.rb

# TTT Bonus Features

# 5 - Computer Refinements

require "pry"

INITIAL_MARKER = " ".freeze
PLAYER_MARKER = "X".freeze
COMPUTER_MARKER = "O".freeze
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]].freeze       # diagonals
WHO_GOES_FIRST = ["Player", "Computer"]

def prompt(msg)
  puts "=>#{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system "clear"
  puts "You're #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  square = " "
  loop do
    prompt"Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  square = empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def computer_threatened?(brd)
  WINNING_LINES.each do |value1, value2, value3|
    case
    when brd[value1] == PLAYER_MARKER &&
         brd[value2] == PLAYER_MARKER &&
         brd[value3] != COMPUTER_MARKER
      return true
    when brd[value2] == PLAYER_MARKER &&
         brd[value3] == PLAYER_MARKER &&
         brd[value1] != COMPUTER_MARKER
      return true
    when brd[value3] == PLAYER_MARKER &&
         brd[value1] == PLAYER_MARKER &&
         brd[value2] != COMPUTER_MARKER
      return true
    end
  end
  nil
end

def threatened_computer_places_piece!(brd)
  WINNING_LINES.each do |value1, value2, value3|
    case
    when brd[value1] == PLAYER_MARKER &&
         brd[value2] == PLAYER_MARKER &&
         brd[value3] != COMPUTER_MARKER
      brd[value3] = COMPUTER_MARKER
      return
    when brd[value2] == PLAYER_MARKER &&
         brd[value3] == PLAYER_MARKER &&
         brd[value1] != COMPUTER_MARKER
      brd[value1] = COMPUTER_MARKER
      return
    when brd[value3] == PLAYER_MARKER &&
         brd[value1] == PLAYER_MARKER &&
         brd[value2] != COMPUTER_MARKER
      brd[value2] = COMPUTER_MARKER
      return
    end
  end
  nil
end

def can_computer_win?(brd)
  WINNING_LINES.each do |value1, value2, value3|
    case
    when brd[value1] == COMPUTER_MARKER &&
         brd[value2] == COMPUTER_MARKER &&
         brd[value3] != PLAYER_MARKER
      return true
    when brd[value2] == COMPUTER_MARKER &&
         brd[value3] == COMPUTER_MARKER &&
         brd[value1] != PLAYER_MARKER
      return true
    when brd[value3] == COMPUTER_MARKER &&
         brd[value1] == COMPUTER_MARKER &&
         brd[value2] != PLAYER_MARKER
      return true
    end
  end
  nil
end

def winning_computer_places_piece!(brd)
  WINNING_LINES.each do |value1, value2, value3|
    case
    when brd[value1] == COMPUTER_MARKER &&
         brd[value2] == COMPUTER_MARKER &&
         brd[value3] != PLAYER_MARKER
      brd[value3] = COMPUTER_MARKER
    when brd[value2] == COMPUTER_MARKER &&
         brd[value3] == COMPUTER_MARKER &&
         brd[value1] != PLAYER_MARKER
      brd[value1] = COMPUTER_MARKER
    when brd[value3] == COMPUTER_MARKER &&
         brd[value1] == COMPUTER_MARKER &&
         brd[value2] != PLAYER_MARKER
      brd[value2] = COMPUTER_MARKER
    end
  end
  nil
end

def is_square_5_available?(brd)
  true if brd[5] == " "
end

def computer_places_piece_on_5!(brd)
  brd[5] = COMPUTER_MARKER
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return "Player"
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return "Computer"
    end
  end
  nil
end

def joinor(array, separator=",", final_string="or")
  new_string = ""
  array[0..-2].each { |value| new_string << "#{value}#{separator} " }
  new_string << "#{final_string} #{array.last}"
  new_string
end

loop do
  player_score = 0
  computer_score = 0

  loop do
    board = initialize_board

    loop do
      display_board(board)

      puts
      prompt "The current score is: Player #{player_score} - Computer #{computer_score}"

      player_places_piece!(board)
      break if someone_won?(board) || board_full?(board)

      case
      when can_computer_win?(board)
        winning_computer_places_piece!(board)
        break if someone_won?(board) || board_full?(board)
      when computer_threatened?(board)
        threatened_computer_places_piece!(board)
        break if someone_won?(board) || board_full?(board)
      when is_square_5_available?(board)
        computer_places_piece_on_5!(board)
        break if someone_won?(board) || board_full?(board)
      else 
        computer_places_piece!(board)
        break if someone_won?(board) || board_full?(board)
      end
    end

    display_board(board)

    case detect_winner(board)
    when "Player"
      player_score += 1
    when "Computer"
      computer_score += 1
    end

    if someone_won?(board)
      prompt "#{detect_winner(board)} WON!"
      prompt "The final score is: Player #{player_score} - Computer #{computer_score}"
    else
      prompt "It's a tie!"
    end

    break if player_score == 5
    break if computer_score == 5
  end

  prompt "Play Again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt "Thanks for Playing Tic Tac Toe! Goodbye!"
