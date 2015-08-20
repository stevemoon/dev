#!/usr/local/bin/ruby
#Amicable numbers
#Problem 21
#
#Let d(n) be defined as the sum of proper divisors of n 
#(numbers less than n which divide evenly into n).
#
#If d(a) = b and d(b) = a, where a ? b, then a and b are 
#an amicable pair and each of a and b are called amicable numbers.
#
#For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11,
#20, 22, 44, 55 and 110; therefore d(220) = 284. 
#
#The proper divisors of 284 are 1, 2, 4, 71 and 142; so d(284) = 220.
#
#Evaluate the sum of all the amicable numbers under 10000.

# ./euler021.rb
# ---
#[220, 284, 1184, 1210, 2620, 2924, 5020, 5564, 6232, 6368]
#---
#31626 <--- The answer!
#
def divisors_of(num)
	upper = num / 2 + 1
	(1..upper.to_i).select { |n| num % n == 0 }
end

def d(num)
	sum = 0
	divisors_of(num).each { |n| sum += n }
	return sum
end

$amicable_list = []
1.upto(10000-1) { |a|
	b = d(a)
	$amicable_list << a if ((d(b) == a) and (a != b))
}

puts "---"
p $amicable_list
puts "---"
puts $amicable_list.inject(0, :+)
