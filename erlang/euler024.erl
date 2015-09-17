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
    RevSeed = lists:reverse(Seed),
    {ok, Suffix, Pivot, Prefix} = find_non_increasing_prefix(RevSeed),
    io:format("~p ~p ~p", [Suffix, Pivot, Prefix]),
    {ok, A, B, C} = find_non_increasing_prefix(lists:reverse(Suffix)).

find_non_increasing_prefix(Seed) -> % Use reverse first for suffix
    fnip([hd(Seed)], tl(Seed)).
fnip([A | B], [C | D]) when A =< C ->
    X = lists:flatten([[C],[A],[B]]),
    fnip(X, D);
fnip([A | B], [C | D]) when A > C -> % We've arrived!
    X = lists:flatten([[A], [B]]),
    {ok, X, C, D };
fnip(A, []) -> % We've hit the end
    {error, no_more_permutations, A}.

find_correct_swap_element(Suffix, Pivot) ->
    fcse(hd(Suffix), tl(Suffix), Pivot).
fcse(Pivot, Tested, [Test | Remaining]) when Pivot >= Test ->
    X = lists:flatten([Tested],[Test]),
    fcse(Pivot, X, Remaining);
fcse(Pivot, Tested, [Test | Remaining]) when Pivot < Test ->
    %logic to build swapped suffix here
    ok. 


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

