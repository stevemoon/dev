#!/usr/local/bin/ruby

#answer is 871198282
words = ""
open('p022_names.txt') { |file| words = file.read }
$word_list = []
words.scan(/[A-Z]+/) { |w| $word_list << [w] }
$word_list.sort!
i = 0
list_total = 0
$word_list.each { |word| 
	i += 1
	w = word[0].to_s
	tot = 0
	w.each_byte { |x| tot += (x.ord - 64) }
	list_total += (tot * i)
}
puts list_total
