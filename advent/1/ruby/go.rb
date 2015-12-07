$count = 0
open('../input.txt').each do |input|
  input.scan( /./ ) do |foo|
    $count += 1 if (foo == "(")
    $count -= 1 if (foo == ")")
  end
end
puts $count
