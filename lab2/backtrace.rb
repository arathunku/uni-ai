require 'pry'
require './sudoku_helpers'
require './element'

$bts_count = 0
SIZE_MATRIX = 9
LOGS = false

module Backtrace
  def self.bts(board)
    $bts_count += 1
    unassigned_element = SudokuHelpers::get_next_empty_element(board)

    unless unassigned_element
      return true
    end

    1.upto(9).each do |domain_value|
      if SudokuHelpers::fits_in?(unassigned_element, domain_value, board)
        board[unassigned_element.index] = Element.new(domain_value, unassigned_element.index) # Place given number in a solution board

        if bts(board)
          return true
        else
          board[unassigned_element.index] = unassigned_element
        end
      end
    end

    return false
  end

  def self.calculate_board(board)
    puts 'backtrace'
    $bts_count = 0
    start = Time.now
    SudokuHelpers::print_board(board.each_with_index.map { |e, i| Element.new(e, i) })

    solution = board.clone.each_with_index.map { |e, i| Element.new(e, i) }
    bts(solution)
    SudokuHelpers::print_board(solution)
    puts "BTS executed count: #{$bts_count}"

    json = {
      board: solution.map(&:value) ,
      bts_count: $bts_count,
      run_time: Time.now - start
    }

    puts json

    $bts_count = 0
    json
  end
end
# wikipedia_board = [
#    5, 3, 0,  0, 7, 0,  0, 0, 0,
#    6, 0, 0,  1, 9, 5,  0, 0, 0,
#    0, 9, 8,  0, 0, 0,  0, 6, 0,

#    8, 0, 0,  0, 6, 0,  0, 0, 3,
#    4, 0, 0,  8, 0, 3,  0, 0, 1,
#    7, 0, 0,  0, 2, 0,  0, 0, 6,

#    0, 6, 0,  0, 0, 0,  2, 8, 0,
#    0, 0, 0,  4, 1, 9,  0, 0, 5,
#    0, 0, 0,  0, 8, 0,  0, 7, 9]

# wikipedia_board = [
# 4,0,0,0,2,5,1,0,7,0,0,6,7,0,0,0,0,0,0,0,5,0,0,0,0,9,0,0,0,0,1,0,8,0,6,0,0,0,7,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,1,
# 0,0,2,0,9,3,0,0,0,0,0,0,0,0,0,0,5,0,3,4,0,0,1,0,0,0
# ]
# wikipedia_board = [
#   7, 0, 0,  0, 0, 0,  0, 0, 0,
#   0, 0, 0,  0, 3, 0,  0, 4, 8,
#   0, 1, 5,  0, 0, 2,  9, 0, 0,

#   0, 0, 1,  0, 0, 0,  0, 0, 0,
#   0, 5, 0,  4, 7, 0,  0, 6, 0,
#   0, 0, 0,  0, 0, 0,  8, 0, 2,

#   3, 9, 0,  0, 6, 7,  5, 0, 0,
#   0, 7, 0,  0, 0, 3,  6, 2, 0,
#   5, 6, 0,  0, 0, 0,  0, 0, 4
# ]

#  Backtrace::calculate_board(wikipedia_board)

# wikipedia_board_solution = [
#    5, 3, 4,  6, 7, 8,  9, 1, 2, # 0
#    6, 7, 2,  1, 9, 5,  3, 4, 8, # 1
#    1, 9, 8,  3, 4, 2,  5, 6, 7, # 2

#    8, 5, 9,  7, 6, 1,  4, 2, 3, # 3
#    4, 2, 6,  8, 5, 3,  7, 9, 1, # 4
#    7, 1, 3,  9, 2, 4,  8, 5, 6, # 5

#    9, 6, 1,  5, 3, 7,  2, 8, 4, # 6
#    2, 8, 7,  4, 1, 9,  6, 3, 5, # 7
#    3, 4, 5,  2, 8, 6,  1, 7, 9] # 8
  #0  1  2   3  4  5   6  7  8

# wikipedia_board.each_with_index do |value, index|
#   ex = "For: #{wikipedia_board_solution[index]} at #{index}"
#   if value == 0
#     fail ex unless fits_at_col(index, wikipedia_board_solution[index], wikipedia_board)
#     fail ex unless fits_at_row(index, wikipedia_board_solution[index], wikipedia_board)
#     fail ex unless fits_at_sqr(index, wikipedia_board_solution[index], wikipedia_board)
#   end
# end







# wikipedia_board.each_with_index { |k, i| puts "#{k} - #{i}" };0
#puts "column - #{column}"; puts "row - #{row}"; puts "value: #{board[row * 10 + column]}";
