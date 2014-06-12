-module(eullib).
-export([power/2, maximum/1]).

power(_, 0) -> 1;
power(X, 1) -> X;
power(X, N) when N > 0 -> power(X, N, 1);
power(X, N) when N =< 0 -> 1.0 / power(X, -N). 

power(_, N, ACC) when N == 0 -> ACC;
power(X, N, ACC) -> power(X, N - 1, X * ACC). 
    

maximum(X) ->
    [Head | Tail] = X,
    maximum(Tail, Head).

maximum([], Max) -> Max;
maximum(List, Max) ->
    [Head | Tail] = List,
    if 
	Head > Max ->
	    maximum(Tail, Head);
        true -> maximum(Tail, Max)
    end.
