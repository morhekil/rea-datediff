module Datediff
  extend self

  def diff(date1, date2)
    days1 = date_to_days(*split_date(date1))
    days2 = date_to_days(*split_date(date2))
    diff = days2 - days1

    [date1, date2, diff]
  end

  protected

  def split_date(date)
    date.split(' ').reverse.collect { |p| p.to_i }
  end

  # Converts a given date into the number of days. Should be valid for all Gregorian dates,
  # i.e. starting with 16th century, so the proposed timeframe of 1900-2010 is also included.
  def date_to_days(year, month, day)
    # First - calculate the number of days until the given year.
    # Leap years are every fourth (+1/4), except every hundredth (-1/100),
    # but with every four-hundredth (+1/400)
    days = year*365 + (year*1/4).to_i - (year*1/100).to_i + (year*1/400).to_i

    # Next - to the months. We set March as month 0, as it puts troublesome
    # February and it's changing number of days at the end of the year,
    # thus not affecting days numbers of other months.
    #
    # Using linear regression we find the function as (306*month + 5)/10,
    # where month is 0..11, 0 being March and 11 - February
    adjusted_month = (month + 9) % 12
    days += (306*adjusted_month + 5)/10

    # And finally - we add the number of days as given
    days += day - 1

    days
  end

end
