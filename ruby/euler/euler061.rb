def tri(n)
	n * (n + 1) / 2
end

def square(n)
	n ** 2
end

def pent(n)
	n * (3 * n - 1) / 2
end

def hex(n)
	n * (2 * n - 1)
end

def sept(n)
	n * (5 * n - 3) / 2
end

def oct(n)
	n * (3 * n - 2)
end

i = 1
while true do
	if tri(i) > 999 
	puts "first triangle 4-digit number is #{i}"
	break
	end
i += 1
end

