require 'flt'
include Flt

HARD = true

module Fitness
  def self.calculate(individual)
    x = individual.first.is_a?(String) ? individual.first.to_i(2) : individual.first
    if HARD
      y = individual.last.is_a?(String) ? individual.last.to_i(2) : individual.last
      # Booth's function:
      (x + 2*y - 7)**2 + (2*x + y - 5)**2
    else
      x**2 + 2* ( ( x + 5) ** 2 )
    end
  end
end
