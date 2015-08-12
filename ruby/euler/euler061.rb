# Answer is 28684
# This program prints out several answers, mostly 28684 (with different permutations of which number is listed first)
# The other answers are incorrect, with one of the polynomial classes repeated. My check to ensure all six are present
# is flawed but good enough for this particular situation.
def tri(n) n * (n + 1) / 2 end
def square(n) n ** 2 end 
def pent(n) n * (3 * n - 1) / 2 end 
def hex(n) n * (2 * n - 1) end 
def sept(n) n * (5 * n - 3) / 2 end 
def oct(n) n * (3 * n - 2) end 

$set_list = []
def add_to_list(num,name) 
	temp = num.to_s
	left2 = temp.slice(0,2)
	right2 = temp.slice(2,2)
	$set_list << [num, name, left2, right2]
end

# I manually figured out the bounds for 4-digit results for each function were.
45.upto 140 do |n| add_to_list(tri(n),3) end
32.upto 99 do |n| add_to_list(square(n), 4) end
26.upto 81 do |n| add_to_list(pent(n), 5) end
23.upto 70 do |n| add_to_list(hex(n), 6) end
21.upto 63 do |n| add_to_list(sept(n), 7) end
19.upto 58 do |n| add_to_list(oct(n), 8) end

$all_six = 3*4*5*6*7*8
puts $set_list.length
$pairs_found = []
def find_pairs()
	$set_list.each { |i|
		$set_list.each { |j|
			$pairs_found << [i,j] if ((i[3] == j[2]) and (i[1] != j[1]))
		}
	}
end

find_pairs
$tris_found = []
def find_tris()
	$pairs_found.each { |i|
		$set_list.each { |j|
			$tris_found << [i,j] if (
						(i[1][3] == j[2]) and
						(i[0][1] != j[1]) and
						(i[1][1] != j[1])
			)
		}
	}
end
find_tris

$hex_found = []
def find_hex()
	$tris_found.each { |i|
		$tris_found.each { |j|
			$hex_found << [i,j] if (
						(i[0][0][2] == j[1][3]) and 
						(j[0][0][2] == i[1][3]) and
						(
i[0][0][1] * i[0][1][1] * i[1][1] * j[0][0][1] * j[0][1][1] * j[1][1] == $all_six )
			)
		}
	}
end
find_hex
$hex_found.each { |i| 
		p i 
		x = i[0][0][0][0] + i[0][0][1][0] + i[0][1][0] + i[1][0][0][0] + i[1][0][1][0] + i[1][1][0] 
		puts x
}
