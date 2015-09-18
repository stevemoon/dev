%%% Lexicographic permutations
%%% Problem 24
%%% A permutation is an ordered arrangement of objects. For example, 3124 is one possible permutation
%%% of the digits 1, 2, 3 and 4. If all of the permutations are listed numerically or alphabetically,
%%% we call it lexicographic order. The lexicographic permutations of 0, 1 and 2 are:
%%%
%%% 012   021   102   120   201   210
%%%
%%% What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9?
%%%  euler024:go([0,1,2,3,4,5,6,7,8,9]).
%%%  [2,7,8,3,9,1,5,4,6,0]
%%%  --- Answer is 2783915460
%%% Algorithm from: http://www.nayuki.io/page/next-lexicographical-permutation-algorithm

-module(euler024).
-export([go/1]).

go(Seed) ->
    nth_lex(Seed, 1000000).

nth_lex(Seed, 1) ->
    Seed;
nth_lex(Seed, Count) ->
    %io:format("~p~n", [Seed]),
    NextSeed = next_lex(Seed),
    nth_lex(NextSeed, Count - 1).

next_lex(Seed) ->
    RevSeed = lists:reverse(Seed),
    {ok, Prefix, Pivot, Suffix} = find_non_increasing_prefix(RevSeed),
    NewSuffix = find_new_suffix(Suffix, Pivot),
    NextLex = lists:flatten([[Prefix],[NewSuffix]]),
    NextLex.

find_non_increasing_prefix(Seed) -> % Use reverse first for suffix
    fnip([hd(Seed)], tl(Seed)).
fnip([A | B], [C | D]) when A =< C ->
    X = lists:flatten([[C],[A],[B]]),
    fnip(X, D);
fnip([A | B], [C | D]) when A > C -> % We've arrived!
    X = lists:flatten([[A], [B]]),
    {ok, lists:reverse(D), C, X };
fnip(A, []) -> % We've hit the end
    {error, no_more_permutations, A}.

find_new_suffix(Suffix, Pivot) ->
    RevSuffix = lists:reverse(Suffix),
    fns(Pivot, [], RevSuffix).
fns(Pivot, Tested, []) ->
    NewSuffix = lists:flatten([[Tested], [Pivot]]),
    NewSuffix;
fns(Pivot, Tested, [Test | Remaining]) when (Pivot >= Test) ->
    %io:format("tested: ~p~n", [Tested]),
    X = lists:flatten([Tested],[Test]),
    fns(Pivot, X, Remaining);
fns(Pivot, Tested, [Test | Remaining]) when Pivot < Test ->
    NewSuffix = lists:flatten([[Test],[Tested], [Pivot], [Remaining]]),
    %io:format("~p ~p ~p ~p ~n", [Pivot, Tested, Test, Remaining]),
    NewSuffix.


