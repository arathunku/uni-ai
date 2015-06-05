require 'deep_clone'

module SudokuHelpers
  def self.log(str)
  puts str if LOGS
  end

  def self.logln(str)
    puts str if LOGS
  end

  def self.print_board(board)
    return unless board.is_a?(Array)
    puts "Board: "
    0.upto(SIZE_MATRIX - 1).each do |row|
      0.upto(SIZE_MATRIX - 1).each do |column|
        print "#{board[row * SIZE_MATRIX + column].value}, "
        print ' ' if (row * SIZE_MATRIX + column) % 3 == 2
      end
      print "\n"
      print "\n" if row % 3 == 2
    end
  end

  # http://aima.cs.berkeley.edu/2nd-ed/newchap05.pdf
  # When- FORWARD CHECKING ever a variable X is assigned, the forward checking process looks at each unassigned variable
  # Y that is connected to X by a constraint and deletes from Y ’s domain any value that is inconsistent
  # with the value chosen for X.
  def self.forward_check(assigned_element, domain_value, board, available_domains)
    # deep clone for safety, I don't want to mutate any of the domains
    new_domains = DeepClone.clone available_domains

    new_domains[assigned_element.index] = nil
    # > Looks at each unassigned variable Y that is connected to X
    get_neighbors(assigned_element, board).reject do |e|
      new_domains[e.index].nil?
    end.each do |element|
#      new_domains[element.index].each do |new_domain_value|
#        if !fits_in?(element, new_domain_value, board)
          # > deletes from Y ’s domain any value that is inconsistent with the value chosen for X.
          new_domains[element.index] = new_domains[element.index] - [domain_value]

          # In case, the domain is empty after removal it means that
          # I've wrong domain value and we need to select something else
          if new_domains[element.index].empty?
            return nil
          end
#        end
#      end
    end

    return new_domains
  end

  def self.get_neighbors(element, board)
    (get_row(element, board) + get_col(element, board) + get_sqr(element, board)).uniq
  end

  def self.fits_in?(element, value, board)
    !get_neighbors(element, board).map { |e| e.value }.include?(value)
  end

  def self.get_row(element, board)
    0.upto(8).map do |column|
      # log "column - #{column}"; log "\trow - #{element.row}"; log "\tvalue: #{board[element.row * SIZE_MATRIX + column].value}\n";
      board[element.row * SIZE_MATRIX + column]
    end
  end

  def self.get_col(element, board)
    0.upto(8).map do |row|
      # log "column - #{element.column}"; log "\trow - #{row}"; log "\tvalue: #{board[row * SIZE_MATRIX + element.column].value}\n";
      board[row * SIZE_MATRIX + element.column]
    end
  end

  def self.get_sqr(element, board)
    elements = []
    0.upto(2).each do |i|
      0.upto(2).each do |j|
        row = j + 3 * (element.row / 3)
        column = i + 3 * (element.column /  3)
        # log "column - #{column} \trow - #{row} \tvalue: #{board[row * 9 + column].value} | fitting: #{value} | #{element}";
        elements.push board[row * SIZE_MATRIX + column]
      end
    end
    elements
  end

  def self.get_next_empty_element(board, domain=nil)
    board.each_with_index do |element, index|
      if domain
        return element if domain[element.index]
      else
        return element if element.value == 0
      end
    end
    return nil
  end

  def self.get_next_empty_with_smallest_domain(board, domain)
    board.reject { |e| domain[e.index].nil? }.sort { |a, b|
      domain[a.index].count <=> domain[b.index].count
    }.last
  end
end
