-module(euler036).
-export([go/1]).

go(Max) ->
    Nums = lists:seq(1,Max),
    DP = double_palindromes(Nums, []),
    lists:foldl(fun(X, Sum) -> X + Sum end, 0, DP).

double_palindromes([], Accum) ->
    Accum;
double_palindromes([Num | Nums], Accum) ->
    DecString = hd(io_lib:format("~.10B", [Num])),    
    BinString = hd(io_lib:format("~.2B", [Num])),
    case (is_palindrome(DecString) and is_palindrome(BinString)) of
       true ->
	   double_palindromes(Nums, Accum ++ [Num]);
       false ->
	   double_palindromes(Nums, Accum)
    end.

is_palindrome(X) ->
    Y = lists:reverse(X), 
    Y =:= X.
