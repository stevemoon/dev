-module(euler014).
-export([go/1]).

%% Answer: 837,799 has 525 terms and is the longest chain under 1,000,000.

%% The following iterative sequence is defined for the set of positive integers:

%% n ->n/2 (n is even)
%% n ->3n + 1 (n is odd)

%% Using the rule above and starting with 13, we generate the following sequence:
%% 13 40 20 10 5 16 8 4 2 1 It can be seen that this sequence (starting at 13 and
%% finishing at 1) contains 10 terms. Although it has not been proved yet (Collatz 
%% Problem), it is thought that all starting numbers finish at 1.

%% Which starting number, under one million, produces the longest chain?

%% NOTE: Once the chain starts the terms are allowed to go above one million.

go(X) ->
    find(lists:seq(1, X), {0, 0}).

find([X | NumSeq], {MaxNum, MaxTerms}) ->
    Terms = collatz(X, 0),     
    case (Terms > MaxTerms) of
	true ->
	    find(NumSeq, {X, Terms});
	false ->
	    find(NumSeq, {MaxNum, MaxTerms})
    end;
find([], MaxTuple) ->
    MaxTuple.
	    
    

collatz(X, Count) when ((X rem 2) =:= 0) ->
    %io:format("~w~n", [X]),
    collatz(X div 2, Count + 1);
collatz(X, Count) when (((X rem 2) =/= 0) and (X =/= 1)) ->
    %io:format("~w~n", [X]),
    collatz(3 * X + 1, Count + 1);
collatz(1, Count) ->
    %io:format("~w~n", [1]),
    Count + 1.

