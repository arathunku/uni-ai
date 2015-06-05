require 'sinatra'
require 'chartkick'
require './ga.rb'

Chartkick.options = {
  height: "600px",
  width: "500px"
}

def p?(param)
  !(param.nil? || param.empty?)
end

get '/' do
  ga = GeneticAlgorithm.new(
    population_size: p?(params[:population_size]) ? params[:population_size].to_i : 4,
    generations_limit: p?(params[:generations_limit]) ? params[:generations_limit].to_i : 20,
    min: p?(params[:min]) ? params[:min].to_i : -10,
    max: p?(params[:max]) ? params[:max].to_i : 10,
    crossover_probability: p?(params[:crossover_probability]) ? params[:crossover_probability].to_f : 0.7,
    mutation_probability: p?(params[:mutation_probability]) ? params[:mutation_probability].to_f : 0.001,
    selection_probability: p?(params[:selection_probability]) ? params[:selection_probability].to_f : 0.2
  )
  data = ga.perform
  erb :index, locals: { ga: ga, data: data }
end


get '/avg' do
  ga = GeneticAlgorithm.new(
    population_size: p?(params[:population_size]) ? params[:population_size].to_i : 4,
    generations_limit: p?(params[:generations_limit]) ? params[:generations_limit].to_i : 20,
    min: p?(params[:min]) ? params[:min].to_i : -10,
    max: p?(params[:max]) ? params[:max].to_i : 10,
    crossover_probability: p?(params[:crossover_probability]) ? params[:crossover_probability].to_f : 0.7,
    mutation_probability: p?(params[:mutation_probability]) ? params[:mutation_probability].to_f : 0.001,
    selection_probability: p?(params[:selection_probability]) ? params[:selection_probability].to_f : 0.2
  )

  data = ga.averages_of_runs(p?(params[:n]) ? params[:n].to_i : 10)
  erb :avg, locals: { ga: ga, data: data }
end
