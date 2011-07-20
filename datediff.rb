#!/usr/bin/env ruby

require 'lib/datediff'

$stdin.each_line do |line|
  dates = line.strip.split(', ')
  catch(:invalid) do
    result = Datediff.diff(dates.shift, dates.shift)
    $stdout.puts result.join(', ')
  end
end
