#!/usr/local/bin/ruby
open('../input.txt').each do |input|
  next unless (input =~ /(\w\w).+\1/)
  next unless (input =~ /(\w).\1+/)
  puts input  
end

