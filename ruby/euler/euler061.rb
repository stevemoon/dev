def tri(n) n * (n + 1) / 2 end
def square(n) n ** 2 end 
def pent(n) n * (3 * n - 1) / 2 end 
def hex(n) n * (2 * n - 1) end 
def sept(n) n * (5 * n - 3) / 2 end 
def oct(n) n * (3 * n - 2) end 
# TODO: iterate over $set_list matching last 2 with 1st 2, 
# building chains. Find a 6-chain that has one each of the 
# polynomial classes.
#
$set_list = []
def add_to_list(n,name) 
	temp = n.to_s
	left2 = temp.slice(0,2).to_i
	right2 = temp.slice(2,2).to_i
	$set_list << [n, name, left2, right2]
end

45.upto 140 do |n| add_to_list(tri(n),:tri) end
32.upto 99 do |n| add_to_list(square(n), :square) end
26.upto 81 do |n| add_to_list(pent(n), :pent) end
23.upto 70 do |n| add_to_list(hex(n), :hex) end
21.upto 63 do |n| add_to_list(sept(n), :sept) end
19.upto 58 do |n| add_to_list(oct(n), :oct) end

#puts $set_list
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
#puts $pairs_found
#$pairs_found.each { |i|
#	p i
#}

$quad_found = []
def find_quad_chains()
	$pairs_found.each { |i|
		$pairs_found.each { |j|
				#	p i
				#	p j
				#	puts "#{i[1][3]} : #{j[0][2]}"
				#	puts "-------"
				$quad_found << [i,j] if (
					i[1][3] == j[0][2] and
					i[0][2] == j[1][3] and
					i[0][1] != j[0][1] and
					i[1][1] != j[0][1] and
					i[0][1] != j[1][1] and
					i[1][1] != j[1][1]
				)
			}
		}
end

find_quad_chains
$hex_found = []
def hex_found()
	$quad_found.each { |i|
		$pairs_found.each { |j|
			$hex_found << [i,j] if (
				i[0][0][2] == j[1][3] and
				i[1][1][3] == j[0][2] #and
				#i[0][0][1] != j[0][1] and
				#i[0][1][1] != j[0][1] and
				#i[1][0][1] != j[0][1] and
				#i[1][1][1] != j[0][1] and
				#i[0][0][1] != j[1][1] and
				#i[0][1][1] != j[1][1] and
				#i[1][0][1] != j[1][1] and
				#i[1][1][1] != j[1][1]
			)
		}
	}
end

hex_found
puts $hex_found.length
$hex_found.each { |i| p i }
