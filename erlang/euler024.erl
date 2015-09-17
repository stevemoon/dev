%%% Lexicographic permutations
%%% Problem 24
%%% A permutation is an ordered arrangement of objects. For example, 3124 is one possible permutation
%%% of the digits 1, 2, 3 and 4. If all of the permutations are listed numerically or alphabetically,
%%% we call it lexicographic order. The lexicographic permutations of 0, 1 and 2 are:
%%%
%%% 012   021   102   120   201   210
%%%
%%% What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9?
%%%
%%% Algorithm from: http://www.nayuki.io/page/next-lexicographical-permutation-algorithm

-module(euler024).
-export([go/1]).

go(Seed) ->
    find_non_increasing_prefix(Seed).

find_non_increasing_prefix(A) -> % Use reverse first for suffix
    fnip([hd(A)], tl(A)).
fnip([A | B], [C | D]) when A > C ->
    X = lists:flatten([[C],[A],[B]]),
    fnip(X, D);
fnip([A | B], [C | D]) when A < C -> % We've arrived!
    X = lists:flatten([[A], [B]]),
    {ok, lists:reverse(X), C, D };
fnip(A, []) -> % We've hit the end
    {error, no_more_permutations, A}.



%% next_lexicographic(X) ->
%%     Y = lists:reverse(X),
%%     {Suffix, Pivot, Prefix} = id_pivot(Y,[]).

%% id_pivot([Trial | RevSuffix], [
%% %% id_pivot([Head, Pivot | Tail],Accum) when Head > Pivot ->
%% %%     NewAccum = lists:flatten([Accum] ++ [Head]),
%% %%     NewHead = lists:flatten([Pivot] ++ [Tail]),
%% %%     id_pivot(NewHead, NewAccum);
%% %% id_pivot([Head, Pivot | Tail],Accum) when Head < Pivot ->
%% %%     NewHead = lists:flatten([Accum] ++ [Head]),
%% %%     {NewHead, Pivot, Tail};
%% %% id_pivot([], Accum) ->
%% %%     {[],[],Accum}.



%% %id_pivot_successor(Front, Pivot, End) ->
%% %    ok.

