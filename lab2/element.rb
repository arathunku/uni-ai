class Element
  attr_accessor :domain, :value, :index, :row, :column
  def initialize(value, index)
    @value = value
    @index = index
    @column = index % SIZE_MATRIX
    @row = (index / SIZE_MATRIX)
  end

  def to_s
    "column: #{column} | row: #{row} | index: #{index} | value: #{value}"
  end

  def dup_with_value(new_value)
    Element.new(new_value, index)
  end
end
