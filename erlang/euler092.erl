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

go(X) ->
    A= digit_split(X),
    io:format("~w~n", [A]).

square_digits(X) ->
    A = digit_split(X),
    B = 
    square_digits(digit_split(X), 0).
square_digits(X, Accum) ->
    

digit_split(X) ->
    digit_split(X, []).
digit_split(X, Accum) when X > 9 ->
    digit_split(X div 10, Accum ++ [X rem 10]);
digit_split(X, Accum) when X =< 9 ->
    lists:reverse(Accum ++ [X]).
