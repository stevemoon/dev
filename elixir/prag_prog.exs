#From page 35
list_concat = fn a,b -> a ++ b end
sum = fn a,b,c -> a + b + c end
pair_tuple_to_list = fn {a,b} -> [a,b] end

#From page 37:
fb? = fn
  {0,0,_} -> "FizzBuzz"
  {0,_,_} -> "Fizz"
  {_,0,_} -> "Buzz"
  {_,_,a} -> a
end

p37 = fn
  n -> fb?.({rem(n,3), rem(n,5), n})
end

#From page 39
prefix = fn a -> (fn b -> "#{a} #{b}" end) end

