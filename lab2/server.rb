require 'sinatra'
require "rack"
require './backtrace.rb'
require './backtrace_forward.rb'

def p?(param)
  !(param.nil? || param.empty?)
end

wikipedia_board = [
  5, 3, 0,  0, 7, 0,  0, 0, 0,
  6, 0, 0,  1, 9, 5,  0, 0, 0,
  0, 9, 8,  0, 0, 0,  0, 6, 0,

  8, 0, 0,  0, 6, 0,  0, 0, 3,
  4, 0, 0,  8, 0, 3,  0, 0, 1,
  7, 0, 0,  0, 2, 0,  0, 0, 6,

  0, 6, 0,  0, 0, 0,  2, 8, 0,
  0, 0, 0,  4, 1, 9,  0, 0, 5,
  0, 0, 0,  0, 8, 0,  0, 7, 9]

wikipedia_board = [
4,0,0,0,2,5,1,0,7,0,0,6,7,0,0,0,0,0,0,0,5,0,0,0,0,9,0,0,0,0,1,0,8,0,6,0,0,0,7,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,1,
0,0,2,0,9,3,0,0,0,0,0,0,0,0,0,0,5,0,3,4,0,0,1,0,0,0
]

def n_params(params)
  Rack::Utils.parse_nested_query(params)
end

get '/' do
  query_hash = request.query_string
  puts query_hash
  query_board = p?(n_params(query_hash)["board"]) ? n_params(query_hash)["board"].map(&:to_i) : wikipedia_board

  erb :index, locals: {
    forward: params[:forward].to_i == 1,
    query_board: query_board,
    result: params[:forward].to_i == 1 ? BacktraceForward::calculate_board(query_board) : Backtrace::calculate_board(query_board)
  }
end


