#!/usr/local/bin/ruby
#Non-abundant sums
#Problem 23
#
#A perfect number is a number for which the sum of its proper 
#divisors is exactly equal to the number. For example, the sum 
#of the proper divisors of 28 would be 1 + 2 + 4 + 7 + 14 = 28,
#	which means that 28 is a perfect number.
#
#A number n is called deficient if the sum of its proper divisors 
#is less than n and it is called abundant if this sum exceeds n.
#
#As 12 is the smallest abundant number, 1 + 2 + 3 + 4 + 6 = 16, 
#the smallest number that can be written as the sum of two abundant
#numbers is 24. By mathematical analysis, it can be shown that all
#integers greater than 28123 can be written as the sum of two abundant
#numbers. However, this upper limit cannot be reduced any further
#by analysis even though it is known that the greatest number that
#cannot be expressed as the sum of two abundant numbers is less than
#this limit.
#
#Find the sum of all the positive integers which cannot be written 
#as the sum of two abundant numbers.

# Answer is 4179871
# Run time is pretty slow (15 minute range) -- I must be missing some 
# obvious optimizations.
#
def divisors_of(num)
	upper = num / 2 + 1
	(1..upper.to_i).select { |n| num % n == 0 }
end

def is_abundant?(num)
	return true if divisors_of(num).inject(0, :+) > num
	false
end

$amicable_list = []
12.upto(28123) { |a|
	$amicable_list << a if is_abundant?(a)
}

def no_am_sum(num) # true if num is not the sum of 2 amicable numbers
	$amicable_list.each { |a1|
		break if a1 > num
		diff = num - a1
		return false if $amicable_list.include?(diff)
	}
	true
end

$n_a_sums = 0
1.upto(23) { |n|
	$n_a_sums += n
}
24.upto(28123) { |n|
	puts "." if ((n % 500) == 0)
	puts "++ 5,000" if ((n % 5000) == 0)
	$n_a_sums += n if no_am_sum(n)
}

puts $n_a_sums
