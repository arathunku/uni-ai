require 'pry'
require 'deep_clone'
SIZE_MATRIX = 9
LOGS = false
require './sudoku_helpers'
require './element'

$bts_count = 0

module BacktraceForward
  def self.bts(board, available_domains)
    $bts_count += 1

    unassigned_element = SudokuHelpers::get_next_empty_element(board, available_domains)

    unless unassigned_element
      return board
    end

    # Iterate over available elements of the domain
    available_domains[unassigned_element.index].each do |domain_value|
      SudokuHelpers::logln "Trying to fit: #{domain_value}  #{unassigned_element}"

        # I'd like to receive new hash of elements with their domain filtered
      new_available_domains = SudokuHelpers::forward_check unassigned_element,
        domain_value,
        board,
        available_domains

      # in case we've got somewhere empty domain it means we've got wrong domain value,
      # do nothing, carry on
      if new_available_domains # domain empty
            # Deep clone because I don't want to mutate any of the elements in the board
        copied_board = DeepClone.clone board
        # Write down value on given location that's "probably" good
        copied_board[unassigned_element.index].value = domain_value
        result = bts(copied_board, new_available_domains)
        if result
          return result
        end
      end
    end

    return nil
  end

  def self.calculate_board(board)
    puts 'backtrace forward'
    $bts_count = 0
    start = Time.now
    solution = board.clone.each_with_index.map { |e, i| Element.new(e.to_i, i) }

    SudokuHelpers::print_board(solution)

    initial_domains = {}
    # initialize hash with available domains at each position
    solution.each do |e|
      initial_domains[e.index] = e.value == 0 ? (1..9).to_a : nil
    end.reject { |e| initial_domains[e.index].nil? }.each do |e|
      SudokuHelpers::get_neighbors(e, solution).each do |n|
        if initial_domains[e.index]
          initial_domains[e.index] = initial_domains[e.index] - [n.value]
          if initial_domains[e.index].count == 1
            e.value = initial_domains[e.index].first
            initial_domains[e.index] = nil
          end
        end
      end
    end

    json = {
      board: bts(solution, initial_domains).map(&:value),
      run_time: Time.now - start,
      bts_count: $bts_count
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
# wikipedia_board = [2,0,8,3,0,0,0,6,0,0,0,0,4,0,0,0,0,8,0,0,0,7,0,9,3,0,0,0,0,3,0,0,0,0,2,0,6,0,0,0,0,2,1,0,5,7,1,0,8,0,0,0,0,0,0,0,7,0,4,0,0,0,0,9,4,0,0,6,0,0,0,0,3,6,0,2,0,0,0,5,0]
# wikipedia_board = [
# 4,0,0,0,2,5,1,0,7,0,0,6,7,0,0,0,0,0,0,0,5,0,0,0,0,9,0,0,0,0,1,0,8,0,6,0,0,0,7,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,1,
# 0,0,2,0,9,3,0,0,0,0,0,0,0,0,0,0,5,0,3,4,0,0,1,0,0,0
# ]

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




puts "BTS executed count: #{$bts_count}"

