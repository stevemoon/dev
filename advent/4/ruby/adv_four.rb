require 'digest'
key = "iwrupvqb"
(8000000..10000000).each do |i|
  digest = Digest::MD5.hexdigest "#{key}#{i}"
  left5 = digest[0..5]
  puts "#{digest} with #{i}" if (left5 == "000000")
end
