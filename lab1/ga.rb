require 'flt'
include Flt

require 'descriptive_statistics'
require './stats.rb'

require './fitness.rb'

DecNum.context.precision = 2

module Calculations
  include Fitness

  # Generates population
  def self.generate_population(size, min, max, elements=1)
    binary_length = max.to_s(2).size
    binary_length = min.to_s(2).size if min.to_s(2).size > binary_length

    1.upto(size).map {
      1.upto(elements).map {
        v = rand(min.to_i..max.to_i).to_s(2)
        v = v[0] == '-' ? v : '+' + v
        v[0] + ('0' * (binary_length - v.size)) + v[1..-1]
      }
    }
  end



  # Wikipedia
  # The tournament size is larger, weak individuals have a smaller chance to be selected.
  # choose k (the tournament size) individuals from the population at random
  # choose the best individual from pool/tournament with probability p
  # choose the second best individual with probability p*(1-p)
  # choose the third best individual with probability p*((1-p)^2)
  # and so on...
  def self.tournament_selection(population, selection_probability, stats)
    selection_size = 10

    1.upto(selection_size).map {
      population[rand(0..population.size-1).to_i]
    }.sort { |x, y|
      stats.fitness
      stats.fitness

      Fitness::calculate(y) <=> Fitness::calculate(x)
    }.each_with_index.map { |individual, index|
      if rand < (index == 0 ? selection_probability : selection_probability * (1-selection_probability)**index )
        individual
      else
        index == selection_size - 1 ? individual : nil
      end
    }.compact.first
  end

  # Cross two individuals be chosing random point
  # Example:
  # 10000100 and 11111111
  # if they are crossed at pos after char 3 it will be
  # 10011111 and 11100100
  # those are offsprings that are returned and put in the population after mutation
  def self.crossover(individual_1, individual_2, crossover_probability)
    if individual_1.is_a?(Array)
      individual_1.each_with_index.map { |x, index|
        crossover(x, individual_2[index], crossover_probability)
      }.transpose
    else
      pos = rand(1..individual_1.size-1).to_i
      if rand < crossover_probability
        [ individual_1[0..pos] + individual_2[pos+1..-1], individual_2[0..pos] + individual_1[pos+1..-1]]
      else
        [ individual_1, individual_2]
      end
    end
  end

  def self.flipped_bit(bit)
    bit == '1' ? '0' : '1'
  end

  # Filiping function in our case it means that
  # on any given position bits can be flipped with very small probability
  def self.mutation(individual, probability_flip=0.001)
    individual.map do |individual|
      individual.split('').map do |bit|
        rand < probability_flip ? flipped_bit(bit) : bit
      end.join('')
    end
  end

  def self.in_domain?(individual, min, max)
    individual.reject { |i| i.to_i(2) >= min && i.to_i <= max }.empty?
  end

  # evolution of the one population
  # Individuals are selected from the population by a tournament selection
  # then crossver is applied
  # then individuals are mutated
  # if results are within domain, there are added to the new population
  def self.population_transfer(parent_population, min, max, crossover_probability, mutation_probability, selection_probability, stats)
    population = []

    while population.size < parent_population.size do
      individual_1, individual_2 = [ tournament_selection(parent_population, selection_probability, stats), tournament_selection(parent_population, selection_probability, stats)]
      individual_1, individual_2 = crossover(individual_1, individual_2, crossover_probability)
      individual_1, individual_2 = [mutation(individual_1, mutation_probability), mutation(individual_2, mutation_probability)]

      population.push(individual_1) if in_domain?(individual_1, min, max)
      population.push(individual_2) if in_domain?(individual_1, min, max)
    end

    population
  end

  # Find the best individual from the population
  def self.get_extremes_from_population(population, fitnesses)
    max_fit = fitnesses.max
    max_individual = population[ fitnesses.index(max_fit) ].map { |e| e.to_i(2) }

    min_fit = fitnesses.min
    min_individual = population[ fitnesses.index(min_fit) ].map { |e| e.to_i(2) }

    {
      max: { individual: max_individual, fitness: max_fit },
      min: { individual: min_individual, fitness: min_fit }
    }
  end

  # Calculate:
  # * standard deviation in the population
  # * population average
  # *
  def self.compress_population(population)
    fitnesses = population.map { |individual|
      Fitness::calculate(individual)
    }

    get_extremes_from_population(population, fitnesses).merge({
      standard_deviation: fitnesses.standard_deviation.round(2),
      average: fitnesses.mean.round(2)
    })
  end
end



class GeneticAlgorithm
  attr_accessor :collected_data,
    :population_size,
    :generations_limit,
    :min,
    :max,
    :crossover_probability,
    :mutation_probability,
    :selection_probability

  def initialize(
    population_size: 4,
    generations_limit: 20 ,
    min: -10,
    max: 10,
    crossover_probability: 0.7,
    mutation_probability: 0.001,
    selection_probability: 0.2
  )
    @population_size = population_size
    @population_size = population_size
    @generations_limit = generations_limit
    @min = min
    @max = max
    @crossover_probability = crossover_probability
    @mutation_probability = mutation_probability
    @selection_probability = selection_probability

  end

  def perform
    collected_data = []

    stats = Stats.start
    if HARD
      population = Calculations::generate_population(population_size, min, max).flatten.zip(Calculations::generate_population(population_size, min, max).flatten)
    else
      population = Calculations::generate_population(population_size, min, max)#.zip(Calculations::generate_population(population_size, min, max))
    end

    collected_data.push(Calculations::compress_population(population))

    2.upto(generations_limit).each do |_|
      population = Calculations::population_transfer(population, min, max, crossover_probability, mutation_probability, selection_probability, stats)
      compressed = Calculations::compress_population(population)
      collected_data.push(compressed)
      # if compressed[:min][:fitness] == 0
      #   break
      # end
    end

    stats.end

    {
      generations: collected_data,
      fitness_count: stats.fitness_count,
      execution_time: stats.execution_time
    }
  end

  def averages_of_runs(n)
    if n < 1
      raise StandardError.new("Eh eh. arguments ")
    end

    acc_data = 1.upto(n).map { |_|
      perform # get only last, final result
    }

    if HARD
      max_individual = [
        acc_data.map {|t| t[:generations].last[:max][:individual].first }.mean.round(2),
        acc_data.map {|t| t[:generations].last[:max][:individual].last }.mean.round(2)
      ]

      min_individual = [
        acc_data.map {|t| t[:generations].last[:min][:individual].first }.mean.round(2),
        acc_data.map {|t| t[:generations].last[:min][:individual].last }.mean.round(2)
      ]
    else
      max_individual = acc_data.map {|t| t[:generations].last[:max][:individual].first }.mean.round(2)
      min_individual = acc_data.map {|t| t[:generations].last[:min][:individual].first }.mean.round(2)
    end


    {
      max: {
        individual: max_individual,
        fitness: acc_data.map {|t| t[:generations].last[:max][:fitness] }.mean.round(2)
      },
      min: {
        individual: min_individual,
        fitness: acc_data.map {|t| t[:generations].last[:min][:fitness] }.mean.round(2)
      },
      standard_deviation: acc_data.map {|t| t[:generations].last[:standard_deviation] }.mean.round(2),
      average: acc_data.map {|t| t[:generations].last[:average] }.mean.round(2),
      fitness_count: acc_data.map {|t| t[:fitness_count] }.mean.round(2),
      execution_time: acc_data.map {|t| t[:execution_time] }.mean.round(8),
      average_over_runs: n
    }
  end
end
