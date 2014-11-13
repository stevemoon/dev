-module(iq).
-export([go/1]).
-compile([debug_info]).
%
%     A
%    B C
%   D E F
%  G H I J
% K L M N O

go(Board) ->
    pretty_print(Board),
    solve(Board, []).

solve(Board, MovesSoFar) ->
    ValidMoves = get_valid_moves(Board),
    solve2(Board, ValidMoves, MovesSoFar).
solve2(Board, [{From, Takes, Lands}| Rest], MovesSoFar) ->
    solve(move(Board, {From, Takes, Lands}), MovesSoFar ++ [{From, Takes, Lands}]),    
    solve2(Board, Rest, MovesSoFar); 
solve2(Board, [], MovesSoFar) ->
    % we could have just traversed the valid moves to a board that has more moves left,
    % or we could get here with a board that is "played out" with no valid moves remaining
    ValidMoves = get_valid_moves(Board),
    case length(ValidMoves) of
	0 ->
	    solve3(Board, MovesSoFar);
	_ ->
	    ok
    end.
solve3(Board, MovesSoFar) ->
    % No valid moves left
    Peg_Count = count_pegs(Board),
    case Peg_Count of
	1 ->
	    MoveString = stringify_move_tuples(MovesSoFar),
	    io:format("~s ~s~n", [MoveString, "(1 peg remains)"]);
	8 ->
	    MoveString = stringify_move_tuples(MovesSoFar),
	    io:format("~s ~s~n", [MoveString, "(8 pegs remain)"]);
	_ ->
	    ok
    end.
    
pretty_print([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]) ->
    io:format("    ~B~n", [A]),
    io:format("   ~B ~B~n", [B, C]),
    io:format("  ~B ~B ~B~n", [D, E, F]),
    io:format(" ~B ~B ~B ~B~n", [G, H, I, J]),
    io:format("~B ~B ~B ~B ~B~n", [K, L, M, N, O]),
    io:format("Total Pegs: ~B~n~n", [count_pegs([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O])]).
    
%% TODO: This function works, but would probably be best re-done as a io:format with a call to stringify_move_tuples...
%% print_move_tuples([{From, Takes, Lands}|Tail]) ->
%%     PrettyNames = [$A, $B, $C, $D, $E, $F, $G, $H, $I, $J, $K, $L, $M, $N, $O],
%%     FromPretty = lists:nth(From + 1, PrettyNames),
%%     TakesPretty = lists:nth(Takes + 1, PrettyNames),
%%     LandsPretty = lists:nth(Lands + 1, PrettyNames),
%%     io:format("~c~s~c~s~c ", [FromPretty, "x", TakesPretty, "->", LandsPretty]),
%%     print_move_tuples(Tail);
%% print_move_tuples([]) ->
%%     io:format("~n").

stringify_move_tuples(Moves) ->
    stringify_move_tuples2(Moves, []).
stringify_move_tuples2([{From, Takes, Lands}|Tail], String) ->
    PrettyNames = [$A, $B, $C, $D, $E, $F, $G, $H, $I, $J, $K, $L, $M, $N, $O],
    FromPretty = lists:nth(From + 1, PrettyNames),
    TakesPretty = lists:nth(Takes + 1, PrettyNames),
    LandsPretty = lists:nth(Lands + 1, PrettyNames),
    Combined_String = String ++ [" ", FromPretty, "x", TakesPretty, "->", LandsPretty, " "],
    stringify_move_tuples2(Tail, Combined_String);
stringify_move_tuples2([], String) ->
    TempString = lists:flatten(String),
    list_to_binary(TempString).

rotate_left([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]) ->
    [O, J, N, F, I, M, C, E, H, L, A, B, D, G, K].

count_pegs(Board) ->
    lists:foldl(fun(X, Sum) -> X + Sum end, 0, Board).

move(Board, {From, Takes, To}) ->
    %This method ran the whole run about 12% faster than the recursive list builder in move1/move2 below
    FromHead = lists:sublist(Board,1,From),
    FromTail = lists:nthtail(From + 1, Board),
    FromBoard = FromHead ++ [0] ++ FromTail,
    TakesHead = lists:sublist(FromBoard,1,Takes),
    TakesTail = lists:nthtail(Takes + 1, FromBoard),
    TakesBoard = TakesHead ++ [0] ++ TakesTail,
    ToHead = lists:sublist(TakesBoard,1,To),
    ToTail = lists:nthtail(To + 1, TakesBoard),
    ToHead ++ [1] ++ ToTail.

%% move1(Board, Move) ->
%%     move2(Board, [], Move, 0).
%% move2([Cur | OrigBoard], ResultBoard, {FromInt, TakesInt, ToInt}, Counter) when Counter < 15 ->
%%     case Counter of
%%         FromInt ->
%%  	   move2(OrigBoard, ResultBoard ++ [0], {FromInt, TakesInt, ToInt}, Counter + 1);
%%         TakesInt ->
%%  	   move2(OrigBoard, ResultBoard ++ [0], {FromInt, TakesInt, ToInt}, Counter + 1);
%%         ToInt ->
%%  	   move2(OrigBoard, ResultBoard ++ [1], {FromInt, TakesInt, ToInt}, Counter + 1);
%%         _ ->
%%  	   move2(OrigBoard, ResultBoard ++ [Cur], {FromInt, TakesInt, ToInt}, Counter + 1)
%%     end;
%%  move2(_, ResultBoard, {_, _, _}, Counter) when Counter == 15 ->
%%     ResultBoard.


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
