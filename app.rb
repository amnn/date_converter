require 'sinatra'
require 'active_support/all'

TERMS = %w(michaelmas hilary trinity)

def to_year_hash(*dates)
  Hash[TERMS.zip(
        dates.map do |date|
          Date.parse(date)
        end)]
end

DATES =
  {2014 => to_year_hash('20141012', '20150118', '20150426'),
   2015 => to_year_hash('20151017', '20160117', '20160424'),
   2016 => to_year_hash('20161009', '20170115', '20170423'),
   2017 => to_year_hash('20171008', '20180114', '20180422'),
   2018 => to_year_hash('20181007', '20190113', '20190428'),
   2019 => to_year_hash('20191013', '20200119', '20200426'),
   2020 => to_year_hash('20201011', '20210117', '20210425')}

TERM_BY_DATE =
  DATES.each_with_object({}) do |(year, terms), term_by_date|
    terms.each do |term, start_date|
      term_by_date[start_date] = [year, term]
    end
  end

YEARS = DATES.keys

def to_real_date(year, term, week, day)
  DATES[year][term] + (week-1).weeks + day.days
end

def to_ox_date(now)
  start_date, (year, term) =
    TERM_BY_DATE.min_by do |(start, _)|
      (start - now).abs
    end

  diff = (now - start_date).to_i
  weeks, days = diff.divmod 7
  [year, term, weeks + 1, days]
end

def params_to_date(params)
  Date.new(*params.values_at('year', 'month', 'day').map(&:to_i))
end

def date_to_params(date)
  %w(year month day).each_with_object({}) do |interval, params|
    params[interval] = date.send(interval)
  end
end

get '/' do
  real = params['real'] ||= {}
  ox = params['ox'] ||= {}

  case params[:direction]
  when "ox->real"
    params['real'] =
      date_to_params(
        to_real_date(ox['year'].to_i, ox['term'],
                     ox['week'].to_i, ox['week_day'].to_i))

  when "real->ox"
    ox['year'], ox['term'], ox['week'], ox['week_day'] =
      to_ox_date(params_to_date(real))

  end

  erb :index
end
