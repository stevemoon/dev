$count = 0
$pos = 0
open('../input.txt').each do |input|
  input.scan( /./ ) do |foo|
    $pos += 1
    $count += 1 if (foo == "(")
    $count -= 1 if (foo == ")")
    puts "Basement at position: #{$pos}" if ($count == -1)
  end
end
puts $count
