module Datediff
  extend self

  # Main method is the calculation of days between two dates. It accepts the dates as it's
  # argument in 'DD MM YYYY' format, and throws :invalid symbol if either of dates isn't valid.
  # Otherwise - sorts the dates, and returns them and the difference as an array:
  # [ date_earlier, date_later, days_difference ]
  def diff(date1, date2)
    date1_split = split_date(date1)
    date2_split = split_date(date2)

    throw :invalid unless Datediff.valid?(date1_split) && Datediff.valid?(date2_split)

    days1 = date_to_days(*date1_split)
    days2 = date_to_days(*date2_split)
    diff = days2 - days1

    diff >= 0 ?
      [date1, date2, diff] :
      [date2, date1, -diff]
  end

  # To validate the date we convert it into days, and then back into date.
  # If the date is invalid - those values won't match.
  def valid?(date)
    date == days_to_date( date_to_days(*date) )
  end

  protected

  def split_date(date)
    date.split(' ').reverse.collect { |p| p.to_i }
  end

  # Converts a given date into the number of days. Should be valid for all Gregorian dates,
  # i.e. starting with 16th century, so the proposed timeframe of 1900-2010 is also included.
  def date_to_days(year, month, day)
    # First - months. We set March as month 0, as it puts troublesome
    # February and it's changing number of days at the end of the year,
    # thus not affecting days numbers of other months.
    #
    # Using a linear regression we find the function as (30.6*month + 0.026),
    # where month is 0..11, 0 being March and 11 - February
    adjusted_month = (month + 9) % 12
    days = (30.6*adjusted_month + 0.526).to_i

    # Next - calculate the number of days until the given year, adding it to the number
    # of days we've got from the months.
    days += year_to_days(year - (adjusted_month/10).to_i)

    # And finally - we add the number of days as given
    days += day - 1

    days
  end

  # Converts a given number of days into a date. Basically is a reverse version of
  # date_to_days algorithms, but is a bit more complex as we need to check to extra
  # edge conditions.
  def days_to_date(days)
    # First - we get a number of years in these days, as an approximate value
    # at the moment
    year = ((days + 1.4780) / 365.2425).to_i
    # And calculate how many days are left after that
    days_left = days - year_to_days(year)
    # If we've got a negative number - we need to adjust our approximation
    # of the year, and recalculate the leftover
    if days_left < 0
      year -= 1
      days_left = days - year_to_days(year)
    end

    # Leftover days are now a basis for the month calculation. It is a direct reversion
    # of the same calculations in date_to_days
    adjusted_month = ((days_left + 0.526) / 30.6).to_i
    # If we've got more than 12 months - adjust the year accordingly
    year += ((adjusted_month + 2) / 12).to_i
    # And calculate the final month value
    month = (adjusted_month + 2) % 12 + 1

    # And the last step - get the day of the month
    day = days_left - (adjusted_month * 30.6 + 0.526).to_i + 1

    [year, month, day]
  end

  # Helper method converting year into a number of days, that is being used multiple times
  # in the algorithm.
  #
  # Leap years are every fourth (+1/4), except every hundredth (-1/100),
  # but with every four-hundredth (+1/400)
  def year_to_days(year)
    year*365 + (year*1/4).to_i - (year*1/100).to_i + (year*1/400).to_i
  end

end
