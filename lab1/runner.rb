require './ga.rb'

# puts GeneticAlgorithm.new().perform

puts GeneticAlgorithm.new(
  population_size: 4,
  generations_limit:  20,
  min: -1000,
  max: 1000,
  crossover_probability: 0.7,
  mutation_probability: 0.01,
  selection_probability: 0.2
).perform
