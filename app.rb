require 'sinatra'

YEARS = (2014..2020)
TERMS = %w(Michaelmas Hilary Trinity)
DAYS  = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)

get '/' do
  erb :index
end
