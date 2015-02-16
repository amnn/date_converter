require 'date'

@terms = [:michealmas, :hilary, :trinity]
@years_start = 2014
@years = 
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
  
  for cur_year in 0...@years.length
    for cur_term in 0...3
      cur_term_start = Date.new(*@years[cur_year][cur_term]) - 7 #begin at 0th week
      cur_term_end = cur_term_start + 7 * 9                       #end at 8th week
      
      if (date_normal > cur_term_start && date_normal < cur_term_end)
        days = date_normal.mjd - cur_term_start.mjd
        cur_term_name = @terms[cur_term]
        cur_full_year = cur_year + @years_start
        return [cur_full_year.to_s + "-" + (cur_full_year+1).to_s, cur_term_name, days / 7, days % 7 ]
      end
    end
  end
  
  return nil
end

#input: [year,symbol-term,num-week,num-day]
#output: [year,month,day]
def get_normal_date(ox_date)
  term = @terms.index(ox_date[1])
  year = ox_date[0]
  week = ox_date[2]
  day = ox_date[3]
  
  @termstart = Date.new(*@years[year-@years_start][term]) - 7
  result = @termstart + week * 7 + day
  return [result.year, result.month, result.day]
end

p get_ox_date_simple([2015,1,18])
p get_normal_date([2014,:hilary, 1, 0]) #note that 2014 means the 2014-2015 year.
