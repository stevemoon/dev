-module(euler004).
-export([go/0]).

go () ->
    Palindromes = goober(100, 100, []),
    stats:maximum(Palindromes).


goober(999, 1000, Accum) ->
    Accum;
goober(X, Y, Accum) when Y =/= 1000 ->
    Z = X * Y,
    case is_palindrome(Z) of
	true ->
	    goober(X, Y + 1, Accum ++ [Z]);
	false ->
	    goober(X, Y + 1, Accum)
    end;
goober(X, 1000, Accum) when X < 999 ->
    goober(X + 1, 100, Accum).



is_palindrome(X) ->
    Fwd = integer_to_list(X),
    Bwd = lists:reverse(Fwd),
    Bwd =:= Fwd.
