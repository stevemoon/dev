-module(primes).
-export([primes_under/1]).

primes_under(Num) ->
    trunc(math:sqrt(Num)) + 1.

