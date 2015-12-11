data = Hash.new(0)
x1 = 0
x2 = 0
y1 = 0
y2 = 0
santa = true
data[[x1,y1]] += 1
open('../input.txt').each do |input|
  input.scan( /./ ) do |foo|
    if (santa) then 
         x1 += 1 if (foo == ">")
         x1 -= 1 if (foo == "<")
         y1 += 1 if (foo == "^")
         y1 -= 1 if (foo == "v")
         data[[x1,y1]] += 1
         santa = false
    else 
      x2 += 1 if (foo == ">")
      x2 -= 1 if (foo == "<")
      y2 += 1 if (foo == "^")
      y2 -= 1 if (foo == "v")
      data[[x2,y2]] += 1
      santa = true
    end
  end
end
puts data.count
