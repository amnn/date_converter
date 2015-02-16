require 'date'

OXDATE_TERMS = [:michaelmas, :hilary, :trinity]
OXDATE_YEARS_START = 2014
OXDATE_YEARS =
      [
       [
         [2014,10,12], #michealmas
         [2015,01,18], #hilary
         [2015,4,26], #trinity
       ], #2014-2015
       [
         [2015,10,11],
         [2016,01,17],
         [2016,4,24],
       ],
       [
         [2016,10,9],
         [2017,01,15],
         [2017,4,23],
       ],
      ]

#input: [year,month,day]
#output: [string-year,symbol-term,num-week,num-day]
def get_ox_date_simple(date_triple)
  date_normal = Date.new(*date_triple)

  for cur_year in 0...OXDATE_YEARS.length
    for cur_term in 0...3
      cur_term_start = Date.new(*OXDATE_YEARS[cur_year][cur_term]) - 7 #begin at 0th week
      cur_term_end = cur_term_start + 7 * 9                       #end at 8th week

      if (date_normal > cur_term_start && date_normal < cur_term_end)
        days = date_normal.mjd - cur_term_start.mjd
        cur_term_name = OXDATE_TERMS[cur_term]
        cur_full_year = cur_year + OXDATE_YEARS_START
        return [cur_full_year, cur_term_name, days / 7, days % 7 ]
      end
    end
  end

  return nil
end

#input: [year,symbol-term,num-week,num-day]
#output: [year,month,day]
def get_normal_date(ox_date)
  term = OXDATE_TERMS.index(ox_date[1])
  year = ox_date[0]
  week = ox_date[2]
  day = ox_date[3]

  termstart = Date.new(*OXDATE_YEARS[year-OXDATE_YEARS_START][term]) - 7
  result = termstart + week * 7 + day
  return [result.year, result.month, result.day]
end

def get_ox_date(date_triple)
  date_normal = Date.new(*date_triple)
  years = OXDATE_YEARS.map { |year| year.map { |term| Date.new(*term) + 7 * 3 } } #consider 4th week as the middle of term
  best_year = years.min_by do |year|
    best = year.min_by { |term| (date_normal.mjd - term.mjd).abs  }
    (date_normal.mjd - best.mjd).abs
  end
  best_term = best_year.min_by { |term| (date_normal.mjd - term.mjd).abs  }

  best_year = years.index(best_year)
  best_term = years[best_year].index(best_term)

  cur_full_year = best_year + OXDATE_YEARS_START
  cur_term_name = OXDATE_TERMS[best_term]
  days = date_normal.mjd - (Date.new(*OXDATE_YEARS[best_year][best_term]) - 7).mjd
  return [cur_full_year, cur_term_name, days / 7, days % 7 ]
end

p get_ox_date_simple([2016,1,26])
p get_ox_date_simple([2016,1,10])
p get_normal_date([2014,:hilary, 1, 0]) #note that 2014 means the 2014-2015 year.
p get_ox_date([2016,1,26])
p get_ox_date([2016,1,10])
