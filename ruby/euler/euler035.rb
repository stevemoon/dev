#!/usr/local/bin/ruby
#Circular primes
#Problem 35
#  foo 
#The number, 197, is called a circular prime because all rotations
#of the digits: 197, 971, and 719, are themselves prime.
#
#There are thirteen such primes below 100: 2, 3, 5, 7, 11, 13, 17, 
#31, 37, 71, 73, 79, and 97.
#
#How many circular primes are there below one million?
#
# Answer is 55
#
require 'mathn'
primes = Prime.instance
$prime_hash = Hash.new
primes.each { |x| 
	$prime_hash[x] = 1 if x < 1000000; break if x > 1000000 }


def rotate(str) 
	return str if str.length == 1
	temp = str
	first = temp.slice(0,1) 
	rest = temp[1..-1]
	rest << first
	return rest
end

def testnum(str)
	found = true
	str.size.times { 
		       found = false unless $prime_hash.key?(str.to_i)
		       str = rotate(str)
	}
	return found
end

circle_primes = []
$prime_hash.each { |num| circle_primes << num[0] if testnum(num[0].to_s) }
p circle_primes
puts circle_primes.length
		
