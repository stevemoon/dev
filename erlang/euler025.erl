-module(euler025).
-export([go/1]).


%% euler025:go(1000).
%% ...
%% 4777: 998
%% 4778: 999
%% 4779: 999
%% 4780: 999
%% 4781: 999
%% 4782: 1000 <-- 4782 is the correct answer.
%% ok


go(NumDigits) ->
    fibdigits(1, 0, 0, 0, NumDigits).

fibdigits(_, _, Digits, Index, Search) when Digits =:= Search ->
    io:format("~b: ~b~n", [Index, Digits]);
fibdigits(FibPrev, FibCur, Digits, Index, Search) ->
    io:format("~b: ~b~n", [Index, Digits]),
    NextFib = FibCur + FibPrev,
    DigitCount = num_digits(NextFib),
    fibdigits(FibCur, NextFib, DigitCount, Index + 1, Search). 

num_digits(Num) ->
    length(integer_to_list(Num)).

				       
    
