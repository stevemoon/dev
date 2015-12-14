#!/usr/local/bin/ruby
open('../input.txt').each do |input|
  a = e = i = o = u = 0
  input.scan( /./ ) do |foo|
    a += 1 if (foo == "a")
    e += 1 if (foo == "e")
    i += 1 if (foo == "i")
    o += 1 if (foo == "o")
    u += 1 if (foo == "u")
  end
  next unless (a + e + i + o + u >= 3)
  next unless (input =~ /(\w)\1+/)
  next if (input =~ /ab|cd|pq|xy/)
  puts input  
end

