-module(factors).
-export([factors/1,prime_factors/1]).

factors(X) ->
    factors(2, X, []).
factors(Start, X, Accum) when Start >= (X div 2 + 1 ) ->
    Accum;
factors(Start, X, Accum) when (X rem Start =:= 0) ->
    io:format("o"),
    factors(Start + 1, X, [Start] ++ Accum);
factors(Start, X, Accum) when (X rem Start =/= 0) ->
    factors(Start + 1, X, Accum).



%% factors(X) ->
%%     factors(2, X, []).
%% factors(Start, X, Accum) when Start >= X ->
%%     Accum;
%% factors(Start, X, Accum) when (X rem Start =:= 0) ->
%%     factors(Start + 1, X, [Start] ++ Accum);
%% factors(Start, X, Accum) when (X rem Start =/= 0) ->
%%     factors(Start + 1, X, Accum).









prime_factors(X) ->
    Factors = factors(X),
    OddFactors = [Y || Y <- Factors, (Y rem 2 =/= 0)],
    find_primes(OddFactors).

find_primes(X) ->
    find_primes2(X, []).

find_primes2([], Accum) ->
    io:format("~n"),
    Accum;
find_primes2([H | T], Accum) ->
    io:format("."),
    case factors(H) of
	[] -> io:format("X"),
	      find_primes2(T, [H] ++ Accum);
	_ ->  find_primes2(T, Accum)
    end.


    

