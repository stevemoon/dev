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
# Revised to speed up runtime from ~15 minutes to ~6 seconds:
# Speedup #1 -- only check for divisors up to the square root
# Speedup #2 -- pre-calculate all sums up-front, with a hash lookup table
#
def divisors_of(num)
	divisors = []
	upper = Math.sqrt(num).floor
	1.upto(upper) { |n| 
		if (num % n == 0) 
			divisors << n
			temp = num/n
			divisors << temp unless (n == temp || temp == num)
		end
	}
	return divisors
end

def is_abundant?(num)
	return true if divisors_of(num).inject(0, :+) > num
	false
end

p "Calculating abundant numbers..."
$abundant_list = []
12.upto(28123) { |a|
	$abundant_list << a if is_abundant?(a)
}
puts "Done."

p "Calculating all sums of abundant numbers..."
$abundant_sums = Hash.new
$abundant_list.each { |ab|
	$abundant_list.each { |ab2|
		my_sum = ab + ab2
		break if my_sum > 28123
		$abundant_sums[my_sum] = my_sum
	}
}
puts "Done."

p "Summing it all up..."
$n_a_sums = 0
1.upto(23) { |n|
	$n_a_sums += n
}
24.upto(28123) { |n|
	$n_a_sums += n unless $abundant_sums.has_key?(n)
}
puts "Done."
puts $n_a_sums
