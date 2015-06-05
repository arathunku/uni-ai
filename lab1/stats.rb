class Stats
  attr_reader :fitness_count, :execution_time

  def initialize
    @fitness_count = 0;
    @generation_count = 0;
    @execution_time = 0;
  end

  def self.start
    stats = new()
    stats.start
    stats
  end

  def fitness
    @fitness_count += 1
  end

  def start
    @start = Time.now
  end

  def generation!
    @generation_count += 1
  end

  def end
    @execution_time = Time.now - @start
  end

  def print
    puts "Execution time: #{@execution_time}"
    puts "Fitness count: #{@fitness_count}"
  end
end
