-module(euler048).
-export([go/1]).

go(X) ->
    Powers = [eullib:power(A,A) || A <- lists:seq(1,X)],
    lists:foldl(fun(A, Sum) -> A + Sum end, 0, Powers).
		  
