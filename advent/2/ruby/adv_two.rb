require 'csv'
total_area = 0
total_ribbon = 0
CSV.foreach("../input.txt", {:col_sep => "x"}) do |row|
  new_row = row.map(&:to_i).sort
  l = new_row[0]
  w = new_row[1]
  h = new_row[2]
  area = 2 * l * w + 2 * w * h + 2 * h * l
  slack = l * w
  area += slack
  ribbon_wrap = l + l + w + w
  ribbon_bow = l * w * h
  total_ribbon += ribbon_wrap + ribbon_bow
  total_area += area
  puts "#{l}  :  #{h}  :  #{w}  :  #{area}"
end
puts "Total area: #{total_area}"
puts "Total ribbon: #{total_ribbon}"
