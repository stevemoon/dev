#!/usr/local/bin/ruby
open('../input.txt').each do |input|
  next unless (input =~ /(..).*\1/) && (input =~ /(.).\1/)
  puts input  
end

