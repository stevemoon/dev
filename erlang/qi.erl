-module(qi).
-export([go/1, get_valid_moves/1, print_move_tuples/1, move/2]).
-compile([debug_info]).
%
%     A
%    B C
%   D E F
%  G H I J
% K L M N O

go(Board) ->
    pretty_print(Board),
    ValidMoves = get_valid_moves(Board).
%    solve(Board, ValidMoves).
%    print_move_tuples(ValidMoves).
    %% case ets:info(visited) of
    %% 	undefined -> ok;
    %% 	_ ->
    %% 	    ets:delete(visited)
    %% end,
    %% ets:new(visited, [set, public, named_table]),
   %% solve(Board, [], 0).

%solve(Board, [CurrentMove|Rest]) ->
    %% Visited = ets:member(visited, Board),
    %% case Visited of
    %% 	true -> 
    %% 	    exit({ok});
    %% 	false -> 
    %% 	    ets:insert(visited, {Board, true}),
    %% 	    ets:insert(visited, {rotate_left(Board), true}),
    %% 	    ets:insert(visited, {rotate_left(rotate_left(Board)), true})
    %% end,
    %% Peg_Count = count_pegs(Board),
    %% case Peg_Count of 
    %%     1 -> io:format("Solution found: ~s~n", [Moves]),
    %% 	     exit({ok});
    %% 	_ -> try spawn(iq, find_moves, [Board, Moves, Count + 1])
    %% 	     catch error -> ok end
    %% end
%    try spawn(qi, solve, [Board, Moves, Count])
%    catch error -> ok end	;
%solve(_, _, Count) when Count > 13 ->
%    exit({ok});
%solve(_, Moves, Count) when Count == 13 ->
%    io:format("Solution found: ~s~n", [Moves]).



    
pretty_print([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]) ->
    io:format("    ~B~n", [A]),
    io:format("   ~B ~B~n", [B, C]),
    io:format("  ~B ~B ~B~n", [D, E, F]),
    io:format(" ~B ~B ~B ~B~n", [G, H, I, J]),
    io:format("~B ~B ~B ~B ~B~n", [K, L, M, N, O]),
    io:format("Total Pegs: ~B~n~n", [count_pegs([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O])]).
    
print_move_tuples([{From, Takes, Lands}|Tail]) ->
    PrettyNames = [$A, $B, $C, $D, $E, $F, $G, $H, $I, $J, $K, $L, $M, $N, $O],
    FromPretty = lists:nth(From + 1, PrettyNames),
    TakesPretty = lists:nth(Takes + 1, PrettyNames),
    LandsPretty = lists:nth(Lands + 1, PrettyNames),
    io:format("~c~s~c~s~c ", [FromPretty, "x", TakesPretty, "->", LandsPretty]),
    print_move_tuples(Tail);
print_move_tuples([]) ->
    io:format("~n").


rotate_left([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]) ->
    [O, J, N, F, I, M, C, E, H, L, A, B, D, G, K].

%% rotate_right(Board) ->
%%     rotate_left(rotate_left(Board)).
    
count_pegs(Board) ->
    lists:foldl(fun(X, Sum) -> X + Sum end, 0, Board).




move(Board, {From, Takes, To}) ->
    FromHead = lists:sublist(Board,1,From),
    FromTail = lists:nthtail(Board, From + 1),
    FromBoard = FromHead ++ [0] ++ FromTail,
    TakesHead = lists:sublist(FromBoard,1,Takes),
    TakesTail = lists:nthtail(FromBoard, Takes + 1),
    TakesBoard = TakesHead ++ [0] ++ TakesTail,
    ToHead = lists:sublist(TakesBoard,1,To),
    ToTail = lists:nthtail(TakesBoard, To + 1),
    MovedBoard = ToHead ++ [1] ++ ToTail.

%    MovedBoard = move2(Board, [], hd(From) - 64, hd(Takes) - 64, hd(To) - 64, 1).
    %
%move2([Cur | OrigBoard], ResultBoard, FromInt, TakesInt, ToInt, Counter) when Counter < 16 ->
%    case Counter of
%%        FromInt ->
%% 	   move2(OrigBoard, [0] ++ ResultBoard, FromInt, TakesInt, ToInt, Counter + 1);
%%        TakesInt ->
%% 	   move2(OrigBoard, [0] ++ ResultBoard, FromInt, TakesInt, ToInt, Counter + 1);
%%        ToInt ->
%% 	   move2(OrigBoard, [1] ++ ResultBoard, FromInt, TakesInt, ToInt, Counter + 1);
%%        _ ->
%% 	   move2(OrigBoard, [Cur] ++ ResultBoard, FromInt, TakesInt, ToInt, Counter + 1)
%%    end;
%% move2(_, ResultBoard, _, _, _, Counter) when Counter == 16 ->
%%     lists:reverse(ResultBoard).


get_valid_moves(Board) -> 
    % Possibles = [{From, Takes, Lands}] where A == 0, O == 14 (ported over from zero-based arrays in Perl)
    Possibles = [{0, 1, 3}, {0, 2, 5},
		 {1, 3, 6}, {1, 4, 8},
		 {2, 5, 9}, {2, 4, 7},
		 {3, 1, 0}, {3, 4, 5}, {3, 6,10}, {3, 7,12},
		 {4, 7,11}, {4, 8,13},
		 {5, 2, 0}, {5, 4, 3}, {5, 8,12}, {5, 9,14},
		 {6, 3, 1}, {6, 7, 8},
		 {7, 4, 2}, {7, 8, 9},
		 {8, 4, 1}, {8, 7, 6},
		 {9, 5, 2}, {9, 8, 7},
		 {10,6, 3}, {10,11,12},
		 {11,7, 4}, {11,12,13},
		 {12,7, 3}, {12, 8, 5}, {12,11,10}, {12,13,14},
		 {13,8, 4}, {13,12,11},
		 {14,9, 5}, {14,13,12}],
    get_valid_moves(Board, Possibles, []).
get_valid_moves(Board, [{From, Takes, Lands} | Tail], ValidMoves) -> 
    FromVal = lists:nth(From + 1, Board),
    TakesVal = lists:nth(Takes + 1, Board),
    LandsVal = lists:nth(Lands + 1, Board),
    case ((FromVal =:= 1) and (TakesVal =:= 1) and (LandsVal =:= 0)) of
	true ->
	    get_valid_moves(Board, Tail, ValidMoves ++ [{From, Takes, Lands}]);
	false ->
	    get_valid_moves(Board, Tail, ValidMoves)
    end;
get_valid_moves(_, [], ValidMoves) -> 
    ValidMoves.
