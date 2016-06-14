%Sum of digits sequence
%Problem 551
%
%Let a0, a1, a2, ... be an integer sequence defined by:
%
%    a0 = 1;
%    for n = 1, an is the sum of the digits of all preceding terms.
%
%The sequence starts with 1, 1, 2, 4, 8, 16, 23, 28, 38, 49, ...
%You are given a106 = 31054319.
%
%Find a1015.

-module(euler551).
-export([sum_digits/1, a/1]).

a(0) ->
    1;
a(1) ->
    1;
a(Num) ->
    a(1,Num-1,1).
a(Cur, Num, Prev) when Cur == Num ->
    Prev + sum_digits(Prev);
a(0,Num,_Prev) ->
    a(1,Num,1); 
a(Cur,Num,Prev) ->
    io:format("~p,~p~n", [Cur, Prev]),
    a(Cur + 1, Num, Prev + sum_digits(Prev)).
%% a(0) -> 1;
%% a(1) -> 1;
%% a(Num) ->
%%     sum_digits(a(Num - 1)) + a(Num - 1).
%% 	sum_digits(Num) + a(Num - 1).

%Lifted from http://rosettacode.org/wiki/Sum_digits_of_an_integer#Erlang
sum_digits(N) ->
    sum_digits(N,10).
 
sum_digits(N,B) ->
    sum_digits(N,B,0).
 
sum_digits(0,_,Acc) ->
    Acc;
sum_digits(N,B,Acc) when N < B ->
    Acc+N;
sum_digits(N,B,Acc) ->
    sum_digits(N div B, B, Acc + (N rem B)).
