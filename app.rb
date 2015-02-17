require 'sinatra'
require 'date'
require './oxdate'

YEARS  = (2014..2020)
TERMS  = %w(Michaelmas Hilary Trinity)

get '/' do
  real = params['real'] ||= {}
  ox = params['ox'] ||= {}

  case params[:direction]
  when "ox->real"
    real['year'], real['month'], real['day'] =
      get_normal_date([ox['year'].to_i,
                       ox['term'].to_sym,
                       ox['week'].to_i,
                       ox['week_day'].to_i])

  when "real->ox"
    ox['year'], term, ox['week'], ox['week_day'] =
      get_ox_date([real['year'].to_i,
                   real['month'].to_i,
                   real['day'].to_i])

    ox['term'] = term.to_s
  end
  erb :index
end
