-module(euler003).
-export([go/1]).

go(Num) ->
    PrimeFactors = factors:prime_factors(Num),
    stats:maximum(PrimeFactors).


    

