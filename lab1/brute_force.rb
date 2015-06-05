require './fitness.rb'
require './stats.rb'

min = -100
max = 100

if HARD
  # Booth's function:
  # domain 10x10
  stats = Stats.start

  best =  min.upto(max).to_a.zip(min.upto(max).to_a).uniq.flatten.permutation(2).to_a.uniq.map { |individual|
    stats.fitness
    [ individual[0], individual[1], Fitness::calculate(individual)]
  }.sort { |x, y|
    x.last <=> y.last
  }.first

  stats.end

  puts best.join(', ')
  stats.print
else
  # 1 D example function
  stats = Stats.start
  best =  min.upto(max).map { |individual|
    stats.fitness
    [ individual[0], individual[1], Fitness::calculate([individual])]
  }.sort { |x, y|
    x.last <=> y.last
  }.first
  puts best.join(', ')
  stats.print

end


