-module(euler092).
-export([go/1]).
%% A number chain is created by continuously adding the square of the digits in a 
%% number to form a new number until it has been seen before.
%% For example,
%% 44 → 32 → 13 → 10 → 1 → 1
%% 85 → 89 → 145 → 42 → 20 → 4 → 16 → 37 → 58 → 89
%% Therefore any chain that arrives at 1 or 89 will become stuck in an endless loop. 
%% What is most amazing is that EVERY starting number will eventually arrive at 1 or 89.
%%
%% How many starting numbers below ten million will arrive at 89?
%%
%% Answer is: euler092:go(10000000).
%% 8581146

go(X) ->
    A = test(1, X, 0),
    io:format("~w~n", [A]).

test(Cur, Max, Count89s) when Cur > Max -> Count89s;
test(Cur, Max, Count89s) -> 
    case chain_to_89(Cur) of
	true -> test(Cur + 1, Max, Count89s + 1);
	false -> test(Cur + 1, Max, Count89s)
    end.
	    
chain_to_89(X) when X =:= 89 -> true;
chain_to_89(X) when X =:= 1 -> false;
chain_to_89(X) -> chain_to_89(square_digits(X)).

square_digits(X) ->
%    A = digit_split(X),
%    B = [C * C || C <- A],
    lists:foldl(fun(D, Sum) -> D * D + Sum end, 0, digit_split(X)).

digit_split(X) ->
    digit_split(X, []).
digit_split(X, Accum) when X > 9 ->
    digit_split(X div 10, [X rem 10] ++ Accum);
digit_split(X, Accum) when X =< 9 ->
    [X] ++ Accum.
