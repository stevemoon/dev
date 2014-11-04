-module(iq).
-export([go/1, find_moves/2, solve/2]).
-compile([debug_info]).
%
%     A
%    B C
%   D E F
%  G H I J
% K L M N O

go(Board) ->
    pretty_print(Board),
    case ets:info(visited) of
	undefined -> ok;
	_ ->
	    ets:delete(visited)
    end,
    ets:new(visited, [set, public, named_table]),
    solve(Board, []).

solve(Board, Moves) ->
    Visited = ets:member(visited, Board),
    case Visited of
	true -> 
	    exit({ok});
	false -> 
	    ets:insert(visited, {Board, true}),
	    ets:insert(visited, {rotate_left(Board), true}),
	    ets:insert(visited, {rotate_left(rotate_left(Board)), true})
    end,
    Peg_Count = count_pegs(Board),
    case Peg_Count of 
        1 -> io:format("Solution found: ~s~n", [Moves]);
	_ -> try spawn(iq, find_moves, [Board, Moves])
	     catch error -> ok end
    end.


% Board_State (with letter variables, 1's and 0 to match to)
% move pattern (with 1's and 0 and underscores) -- to match to in case
% Moved_Board_State (with letter variables, substituting 0's for 1's above, and 1 for the 0 above, letters stay the same
% Move text to show in move list
%
% find_moves(Board, Moves) ->
% case Board of
% [1,1,_,0...], 
%     try spawn(iq, solve, [?Moved_Board_State]
-define(CASE_BODY(MOVE_PATTERN, MOVED_BOARD_STATE, MOVE_TEXT), 
	case Initial_Board of
	    MOVE_PATTERN ->
		try spawn(iq, solve, [MOVED_BOARD_STATE, Moves ++ MOVE_TEXT])
		catch error -> ok end;
	    _  -> false
	end).

find_moves([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O], Moves) ->
    Initial_Board = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O],
    ?CASE_BODY([1,1,_,0,_,_,_,_,_,_,_,_,_,_,_],[0,0,C,1,E,F,G,H,I,J,K,L,M,N,O],["AxB->D "]),
    ?CASE_BODY([1,_,1,_,_,0,_,_,_,_,_,_,_,_,_],[0,B,0,D,E,1,G,H,I,J,K,L,M,N,O],["AxC->F "]),
    ?CASE_BODY([_,1,_,1,_,_,0,_,_,_,_,_,_,_,_],[A,0,C,0,E,F,1,H,I,J,K,L,M,N,O],["BxD->G "]),
    ?CASE_BODY([_,1,_,_,1,_,_,_,0,_,_,_,_,_,_],[A,0,C,D,0,F,G,H,1,J,K,L,M,N,O],["BxE->I "]),
    ?CASE_BODY([_,_,1,_,1,_,_,0,_,_,_,_,_,_,_],[A,B,0,D,0,F,G,1,I,J,K,L,M,N,O],["CxE->H "]),
    ?CASE_BODY([_,_,1,_,_,1,_,_,_,0,_,_,_,_,_],[A,B,0,D,E,0,G,H,I,1,K,L,M,N,O],["CxF->J "]),
    ?CASE_BODY([0,1,_,1,_,_,_,_,_,_,_,_,_,_,_],[1,0,C,0,E,F,G,H,I,J,K,L,M,N,O],["DxB->A "]),
    ?CASE_BODY([_,_,_,1,1,0,_,_,_,_,_,_,_,_,_],[A,B,C,0,0,1,G,H,I,J,K,L,M,N,O],["DxE->F "]),
    ?CASE_BODY([_,_,_,1,_,_,_,1,_,_,_,_,0,_,_],[A,B,C,0,E,F,G,0,I,J,K,L,1,N,O],["DxH->M "]),
    ?CASE_BODY([_,_,_,1,_,_,1,_,_,_,0,_,_,_,_],[A,B,C,0,E,F,0,H,I,J,1,L,M,N,O],["DxG->K "]),
    ?CASE_BODY([_,_,_,_,1,_,_,1,_,_,_,0,_,_,_],[A,B,C,D,0,F,G,0,I,J,K,1,M,N,O],["ExH->L "]),
    ?CASE_BODY([_,_,_,_,1,_,_,_,1,_,_,_,_,0,_],[A,B,C,D,0,F,G,H,0,J,K,L,M,1,O],["ExI->N "]),
    ?CASE_BODY([0,_,1,_,_,1,_,_,_,_,_,_,_,_,_],[1,B,0,D,E,0,G,H,I,J,K,L,M,N,O],["FxC->A "]),
    ?CASE_BODY([_,_,_,0,1,1,_,_,_,_,_,_,_,_,_],[A,B,C,1,0,0,G,H,I,J,K,L,M,N,O],["FxE->D "]),
    ?CASE_BODY([_,_,_,_,_,1,_,_,1,_,_,_,0,_,_],[A,B,C,D,E,0,G,H,0,J,K,L,1,N,O],["FxI->M "]),
    ?CASE_BODY([_,_,_,_,_,1,_,_,_,1,_,_,_,_,0],[A,B,C,D,E,0,G,H,I,0,K,L,M,N,1],["FxJ->O "]),
    ?CASE_BODY([_,0,_,1,_,_,1,_,_,_,_,_,_,_,_],[A,1,C,0,E,F,0,H,I,J,K,L,M,N,O],["GxD->B "]),
    ?CASE_BODY([_,_,_,_,_,_,1,1,0,_,_,_,_,_,_],[A,B,C,D,E,F,0,0,1,J,K,L,M,N,O],["GxH->I "]),
    ?CASE_BODY([_,_,0,_,1,_,_,1,_,_,_,_,_,_,_],[A,B,1,D,0,F,G,0,I,J,K,L,M,N,O],["HxE->C "]),
    ?CASE_BODY([_,_,_,_,_,_,_,1,1,0,_,_,_,_,_],[A,B,C,D,E,F,G,0,0,1,K,L,M,N,O],["HxI->J "]),
    ?CASE_BODY([_,_,_,_,_,_,0,1,1,_,_,_,_,_,_],[A,B,C,D,E,F,1,0,0,J,K,L,M,N,O],["IxH->G "]),
    ?CASE_BODY([_,0,_,_,1,_,_,_,1,_,_,_,_,_,_],[A,1,C,D,0,F,G,H,0,J,K,L,M,N,O],["IxE->B "]),
    ?CASE_BODY([_,_,_,_,_,_,_,0,1,1,_,_,_,_,_],[A,B,C,D,E,F,G,1,0,0,K,L,M,N,O],["JxI->H "]),
    ?CASE_BODY([_,_,0,_,_,1,_,_,_,1,_,_,_,_,_],[A,B,1,D,E,0,G,H,I,0,K,L,M,N,O],["JxF->C "]),
    ?CASE_BODY([_,_,_,0,_,_,1,_,_,_,1,_,_,_,_],[A,B,C,1,E,F,0,H,I,J,0,L,M,N,O],["KxG->D "]),
    ?CASE_BODY([_,_,_,_,_,_,_,_,_,_,1,1,0,_,_],[A,B,C,D,E,F,G,H,I,J,0,0,1,N,O],["KxL->M "]),
    ?CASE_BODY([_,_,_,_,0,_,_,1,_,_,_,1,_,_,_],[A,B,C,D,1,F,G,0,I,J,K,0,M,N,O],["LxH->E "]),
    ?CASE_BODY([_,_,_,_,_,_,_,_,_,_,_,1,1,0,_],[A,B,C,D,E,F,G,H,I,J,K,0,0,1,O],["LxM->N "]),
    ?CASE_BODY([_,_,_,_,_,_,_,_,_,_,0,1,1,_,_],[A,B,C,D,E,F,G,H,I,J,1,0,0,N,O],["MxL->K "]),
    ?CASE_BODY([_,_,_,0,_,_,_,1,_,_,_,_,1,_,_],[A,B,C,1,E,F,G,0,I,J,K,L,0,N,O],["MxH->D "]),
    ?CASE_BODY([_,_,_,_,_,0,_,_,1,_,_,_,1,_,_],[A,B,C,D,E,1,G,H,0,J,K,L,0,N,O],["MxI->F "]),
    ?CASE_BODY([_,_,_,_,_,_,_,_,_,_,_,_,1,1,0],[A,B,C,D,E,F,G,H,I,J,K,L,0,0,1],["MxN->O "]),
    ?CASE_BODY([_,_,_,_,_,_,_,_,_,_,_,0,1,1,_],[A,B,C,D,E,F,G,H,I,J,K,1,0,0,O],["NxM->L "]),
    ?CASE_BODY([_,_,_,_,0,_,_,_,1,_,_,_,_,1,_],[A,B,C,D,1,F,G,H,0,J,K,L,M,0,O],["NxI->E "]),
    ?CASE_BODY([_,_,_,_,_,_,_,_,_,_,_,_,0,1,1],[A,B,C,D,E,F,G,H,I,J,K,L,1,0,0],["OxN->M "]),
    ?CASE_BODY([_,_,_,_,_,0,_,_,_,1,_,_,_,_,1],[A,B,C,D,E,1,G,H,I,0,K,L,M,N,0],["OxJ->F "]).
    
pretty_print([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]) ->
    io:format("    ~B~n", [A]),
    io:format("   ~B ~B~n", [B, C]),
    io:format("  ~B ~B ~B~n", [D, E, F]),
    io:format(" ~B ~B ~B ~B~n", [G, H, I, J]),
    io:format("~B ~B ~B ~B ~B~n", [K, L, M, N, O]),
    io:format("Total Pegs: ~B~n~n", [count_pegs([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O])]).
    
rotate_left([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]) ->
    [O, J, N, F, I, M, C, E, H, L, A, B, D, G, K].

%% rotate_right(Board) ->
%%     rotate_left(rotate_left(Board)).
    
count_pegs(Board) ->
    lists:foldl(fun(X, Sum) -> X + Sum end, 0, Board).




%% move(Board, From, Takes, To) ->
%%     MovedBoard = move2(Board, [], hd(From) - 64, hd(Takes) - 64, hd(To) - 64, 1).
    
%% move2([Cur | OrigBoard], ResultBoard, FromInt, TakesInt, ToInt, Counter) when Counter < 16 ->
%%    case Counter of
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


%% define_moves() ->
%%     TextMoves = [{$A,$B,$D},{$A,$C,$F},
%% 		 {$B,$D,$G},{$B,$E,$I},
%% 		 {$C,$E,$H},{$C,$F,$J},
%% 		 {$D,$B,$A},{$D,$E,$F},{$D,$H,$M},{$D,$G,$K},
%% 		 {$E,$H,$L},{$E,$I,$N},
%% 		 {$F,$C,$A},{$F,$E,$D},{$F,$I,$M},{$F,$J,$O},
%% 		 {$G,$D,$B},{$G,$H,$I},
%% 		 {$H,$E,$C},{$H,$I,$J},
%% 		 {$I,$H,$G},{$I,$E,$B},
%% 		 {$J,$I,$H},{$J,$F,$C},
%% 		 {$K,$G,$D},{$K,$L,$M},
%% 		 {$L,$H,$E},{$L,$M,$N},
%% 		 {$M,$L,$K},{$M,$H,$D},{$M,$I,$F},{$M,$N,$O},
%% 		 {$N,$M,$L},{$N,$I,$E},
%% 		 {$O,$N,$M},{$O,$J,$F}],
%%     numeric_moves(TextMoves, []).

%% numeric_moves([{X, Y, Z} | Tail], NumericMoves) ->
%%     numeric_moves(Tail, NumericMoves ++ [{X - 64, Y - 64, Z - 64}]);
%% numeric_moves([], NumericMoves) ->
%%     %move_patterns(NumericMoves, []),
%%     NumericMoves.

%% move_patterns([Head | Tail], PatternList) ->
%%     move_patterns(Tail, PatternList ++ [move_pattern(Head)]);
%% move_patterns([], PatternList) ->
%%     PatternList.
    
%% move_pattern(NumericMove) ->
%%     move_pattern2([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], NumericMove, {[],[],[]}, 1).

%% move_pattern2(Board, {FromInt, TakesInt, ToInt}, {MovePattern, MovedBoardState, MoveText}, Counter) when Counter < 16 ->    
%%     case Counter of
%%        FromInt ->
%% 	    MovePatternChar = 49, % _ for otherwise
%% 	    MovedBoardStateChar = 48,
%% 	    MovedPattern = {MovePattern ++ [MovePatternChar], MovedBoardState ++ [MovedBoardStateChar], MoveText},
%% 	    move_pattern2(Board, {FromInt, TakesInt, ToInt}, MovedPattern, Counter + 1); %95 is _
%%        TakesInt ->
%% 	    MovePatternChar = 49, % _ for otherwise
%% 	    MovedBoardStateChar = 48,
%% 	    MovedPattern = {MovePattern ++ [MovePatternChar], MovedBoardState ++ [MovedBoardStateChar], MoveText},
%% 	    move_pattern2(Board, {FromInt, TakesInt, ToInt}, MovedPattern, Counter + 1);
%%        ToInt ->
%% 	    MovePatternChar = 48, % _ for otherwise
%% 	    MovedBoardStateChar = 49,
%% 	    MovedPattern = {MovePattern ++ [MovePatternChar], MovedBoardState ++ [MovedBoardStateChar], MoveText},
%% 	    move_pattern2(Board, {FromInt, TakesInt, ToInt}, MovedPattern, Counter + 1);
%%        _ ->
%% 	    MovePatternChar = 95, % _ for otherwise
%% 	    MovedBoardStateChar = Counter + 64,
%% 	    MovedPattern = {MovePattern ++ [MovePatternChar], MovedBoardState ++ [MovedBoardStateChar], MoveText},
%% 	    move_pattern2(Board, {FromInt, TakesInt, ToInt}, MovedPattern, Counter + 1)
%%    end;
%% move_pattern2(_, {FromInt, TakesInt, ToInt}, {MovePattern, MovedBoardState, MoveText}, Counter) when Counter == 16 ->
%%     Pattern = {MovePattern, MovedBoardState, [FromInt + 64] ++ [120] ++ [TakesInt + 64] ++ [45] ++ [62] ++ [ToInt + 64] ++ [32]},
%%     %io:format("~w~n", [Pattern]),
%%     Pattern.


%% find_moves([A, 1, C, D, E, F, G, H, I, J, K, L, M, N, O], Moves) ->
%%     Initial_Board = [A, 1, C, D, E, F, G, H, I, J, K, L, M, N, O],
%%     % BxD->G, BxE->I
%%     case Initial_Board of
%% 	[_, 1, _, 1, _, _, 0, _, _, _, _, _, _, _, _] -> 
%% 	    try spawn(iq, solve, [[A, 0, C, 0, E, F, 1, H, I, J, K, L, M, N, O], Moves ++ "BxD->G  "])
%% 	    catch error -> ok end;
%% 	_ -> false
%%     end,
%%     io:format("~s~n", ["1st case of B"]),
%%     case Initial_Board of
%% 	[_, 1, _, _, 1, _, _, _, 0, _, _, _, _, _, _] -> 
%% 	    try spawn(iq, solve, [[A, 0, C, D, 0, F, G, H, 1, J, K, L, M, N, O], Moves ++ "BxE->I  "])
%% 	    catch error -> ok end;
%% 	_ -> false
%%     end,
%%     io:format("~s~n", ["2nd case of B"]);
