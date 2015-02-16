require 'sinatra'

YEARS = (2014..2020)
TERMS = %w(Michaelmas Hilary Trinity)

get '/' do
  erb :index
end
