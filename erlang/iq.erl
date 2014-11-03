-module(iq).
-export([go/1, find_moves/2, solve/3, move/4, define_moves/0]).
-compile([debug_info]).
%
%     A
%    B C
%   D E F
%  G H I J
% K L M N O

go(Board) ->
    pretty_print(Board),
    find_moves(Board, []).
   %MoveList = define_moves(),
   %PatternList = move_patterns(MoveList, []).
   % dyn_match(hd(PatternList), Board).
   % solve(Board, MoveList, []).
   % pretty_print(rotate_left(Board)),
   % pretty_print(rotate_right(Board)).

solve(Board, MoveList, Moves) ->
    Peg_Count = count_pegs(Board),
    case Peg_Count of 
        1 -> io:format("Solution found: ~s~n", [Moves]);
	_ -> try spawn(iq, try_moves, [Board, MoveList, Moves])
	     catch error -> ok end
    end.

try_moves(Board, MoveList, Moves) ->
    ok.

dyn_match(Pattern, Board) ->
    io:format("~w~n", [Pattern]).
    %% {ok, T, _} = erl_scan:string(lists:flatten(Pattern)),
    %% {ok, [A]} = erl_parse:parse_exprs(T),
    %% {value, V, _} = erl_eval:expr(A, []),
    %% V.

%%% TODO: recursive function to take the board, and the move list, then go through each move on the list. If the Move works with the board then spawn a process (solve) to do it.
%%% Alternatively, find a way to write a macro that will generate the erlang code to do regular pattern matching and then execute it. Building the lists of patterns to match against would be trivial.

%dyn_match(
% Dynamic match -- compile move pattern into a native pattern-match
%% Eval = fun(S) ->
%% 	       {ok, T, _} = erl_scan:string(S),
%% 	       {ok, [A]} = erl_parse:parse_exprs(T),
%% 	       {value, V, _} = erl_eval:expr(A, []),
%% 	       V end,
%% FilterGen = fun(X) ->
%% 		    Eval(lists:flatten(["fun(",X,")->true;(_)->false end."])) end,
%% filter(FilterGen(MovePattern)).

%% Eval = fun(S) -> {ok, T, _} = erl_scan:string(S), {ok,[A]} = erl_parse:parse_exprs(T), {value, V, _} = erl_eval:expr(A,[]), V end,
%% FilterGen = fun(X) -> Eval(lists:flatten(["fun(",X,")->true;(_)->false end."])) end,
%% filter(FilterGen("{book, _}"), [{dvd, "The Godfather" } , {book, "The Hitchhiker's Guide to the Galaxy" }, {dvd, "The Lord of Rings"}]).
%% [{book,"The Hitchhiker's Guide to the Galaxy"}]


move(Board, From, Takes, To) ->
    MovedBoard = move2(Board, [], hd(From) - 64, hd(Takes) - 64, hd(To) - 64, 1).
    
move2([Cur | OrigBoard], ResultBoard, FromInt, TakesInt, ToInt, Counter) when Counter < 16 ->
   case Counter of
       FromInt ->
	   move2(OrigBoard, [0] ++ ResultBoard, FromInt, TakesInt, ToInt, Counter + 1);
       TakesInt ->
	   move2(OrigBoard, [0] ++ ResultBoard, FromInt, TakesInt, ToInt, Counter + 1);
       ToInt ->
	   move2(OrigBoard, [1] ++ ResultBoard, FromInt, TakesInt, ToInt, Counter + 1);
       _ ->
	   move2(OrigBoard, [Cur] ++ ResultBoard, FromInt, TakesInt, ToInt, Counter + 1)
   end;
move2(_, ResultBoard, _, _, _, Counter) when Counter == 16 ->
    lists:reverse(ResultBoard).


define_moves() ->
    TextMoves = [{$A,$B,$D},{$A,$C,$F},
		 {$B,$D,$G},{$B,$E,$I},
		 {$C,$E,$H},{$C,$F,$J},
		 {$D,$B,$A},{$D,$E,$F},{$D,$H,$M},{$D,$G,$K},
		 {$E,$H,$L},{$E,$I,$N},
		 {$F,$C,$A},{$F,$E,$D},{$F,$I,$M},{$F,$J,$O},
		 {$G,$D,$B},{$G,$H,$I},
		 {$H,$E,$C},{$H,$I,$J},
		 {$I,$H,$G},{$I,$E,$B},
		 {$J,$I,$H},{$J,$F,$C},
		 {$K,$G,$D},{$K,$L,$M},
		 {$L,$H,$E},{$L,$M,$N},
		 {$M,$L,$K},{$M,$H,$D},{$M,$I,$F},{$M,$N,$O},
		 {$N,$M,$L},{$N,$I,$E},
		 {$O,$N,$M},{$O,$J,$F}],
    numeric_moves(TextMoves, []).

numeric_moves([{X, Y, Z} | Tail], NumericMoves) ->
    numeric_moves(Tail, NumericMoves ++ [{X - 64, Y - 64, Z - 64}]);
numeric_moves([], NumericMoves) ->
    %move_patterns(NumericMoves, []),
    NumericMoves.

move_patterns([Head | Tail], PatternList) ->
    move_patterns(Tail, PatternList ++ [move_pattern(Head)]);
move_patterns([], PatternList) ->
    PatternList.
    
move_pattern(NumericMove) ->
    move_pattern2([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], NumericMove, {[],[],[]}, 1).

move_pattern2(Board, {FromInt, TakesInt, ToInt}, {MovePattern, MovedBoardState, MoveText}, Counter) when Counter < 16 ->    
    case Counter of
       FromInt ->
	    MovePatternChar = 49, % _ for otherwise
	    MovedBoardStateChar = 48,
	    MovedPattern = {MovePattern ++ [MovePatternChar], MovedBoardState ++ [MovedBoardStateChar], MoveText},
	    move_pattern2(Board, {FromInt, TakesInt, ToInt}, MovedPattern, Counter + 1); %95 is _
       TakesInt ->
	    MovePatternChar = 49, % _ for otherwise
	    MovedBoardStateChar = 48,
	    MovedPattern = {MovePattern ++ [MovePatternChar], MovedBoardState ++ [MovedBoardStateChar], MoveText},
	    move_pattern2(Board, {FromInt, TakesInt, ToInt}, MovedPattern, Counter + 1);
       ToInt ->
	    MovePatternChar = 48, % _ for otherwise
	    MovedBoardStateChar = 49,
	    MovedPattern = {MovePattern ++ [MovePatternChar], MovedBoardState ++ [MovedBoardStateChar], MoveText},
	    move_pattern2(Board, {FromInt, TakesInt, ToInt}, MovedPattern, Counter + 1);
       _ ->
	    MovePatternChar = 95, % _ for otherwise
	    MovedBoardStateChar = Counter + 64,
	    MovedPattern = {MovePattern ++ [MovePatternChar], MovedBoardState ++ [MovedBoardStateChar], MoveText},
	    move_pattern2(Board, {FromInt, TakesInt, ToInt}, MovedPattern, Counter + 1)
   end;
move_pattern2(_, {FromInt, TakesInt, ToInt}, {MovePattern, MovedBoardState, MoveText}, Counter) when Counter == 16 ->
    Pattern = {MovePattern, MovedBoardState, [FromInt + 64] ++ [120] ++ [TakesInt + 64] ++ [45] ++ [62] ++ [ToInt + 64] ++ [32]},
    %io:format("~w~n", [Pattern]),
    Pattern.

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
		pretty_print(Initial_Board),
		try spawn(iq, find_moves, MOVED_BOARD_STATE, Moves ++ MOVE_TEXT)
		catch error -> ok end;
	    _  -> false
	end).

%% find_moves([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O], Moves) ->
find_moves(Initial_Board, Moves) ->
?CASE_BODY("1,1,_,0,_,_,_,_,_,_,_,_,_,_,_","0,0,C,1,E,F,G,H,I,J,K,L,M,N,O","AxB->D "),
?CASE_BODY("1,_,1,_,_,0,_,_,_,_,_,_,_,_,_","0,B,0,D,E,1,G,H,I,J,K,L,M,N,O","AxC->F "),
?CASE_BODY("_,1,_,1,_,_,0,_,_,_,_,_,_,_,_","A,0,C,0,E,F,1,H,I,J,K,L,M,N,O","BxD->G "),
?CASE_BODY("_,1,_,_,1,_,_,_,0,_,_,_,_,_,_","A,0,C,D,0,F,G,H,1,J,K,L,M,N,O","BxE->I "),
?CASE_BODY("_,_,1,_,1,_,_,0,_,_,_,_,_,_,_","A,B,0,D,0,F,G,1,I,J,K,L,M,N,O","CxE->H "),
?CASE_BODY("_,_,1,_,_,1,_,_,_,0,_,_,_,_,_","A,B,0,D,E,0,G,H,I,1,K,L,M,N,O","CxF->J "),
?CASE_BODY("0,1,_,1,_,_,_,_,_,_,_,_,_,_,_","1,0,C,0,E,F,G,H,I,J,K,L,M,N,O","DxB->A "),
?CASE_BODY("_,_,_,1,1,0,_,_,_,_,_,_,_,_,_","A,B,C,0,0,1,G,H,I,J,K,L,M,N,O","DxE->F "),
?CASE_BODY("_,_,_,1,_,_,_,1,_,_,_,_,0,_,_","A,B,C,0,E,F,G,0,I,J,K,L,1,N,O","DxH->M "),
?CASE_BODY("_,_,_,1,_,_,1,_,_,_,0,_,_,_,_","A,B,C,0,E,F,0,H,I,J,1,L,M,N,O","DxG->K "),
?CASE_BODY("_,_,_,_,1,_,_,1,_,_,_,0,_,_,_","A,B,C,D,0,F,G,0,I,J,K,1,M,N,O","ExH->L "),
?CASE_BODY("_,_,_,_,1,_,_,_,1,_,_,_,_,0,_","A,B,C,D,0,F,G,H,0,J,K,L,M,1,O","ExI->N "),
?CASE_BODY("0,_,1,_,_,1,_,_,_,_,_,_,_,_,_","1,B,0,D,E,0,G,H,I,J,K,L,M,N,O","FxC->A "),
?CASE_BODY("_,_,_,0,1,1,_,_,_,_,_,_,_,_,_","A,B,C,1,0,0,G,H,I,J,K,L,M,N,O","FxE->D "),
?CASE_BODY("_,_,_,_,_,1,_,_,1,_,_,_,0,_,_","A,B,C,D,E,0,G,H,0,J,K,L,1,N,O","FxI->M "),
?CASE_BODY("_,_,_,_,_,1,_,_,_,1,_,_,_,_,0","A,B,C,D,E,0,G,H,I,0,K,L,M,N,1","FxJ->N "),
?CASE_BODY("_,0,_,1,_,_,1,_,_,_,_,_,_,_,_","A,1,C,0,E,F,0,H,I,J,K,L,M,N,O","GxD->B "),
?CASE_BODY("_,_,_,_,_,_,1,1,0,_,_,_,_,_,_","A,B,C,D,E,F,0,0,1,J,K,L,M,N,O","GxH->I "),
?CASE_BODY("_,_,0,_,1,_,_,1,_,_,_,_,_,_,_","A,B,1,D,0,F,G,0,I,J,K,L,M,N,O","HxE->C "),
?CASE_BODY("_,_,_,_,_,_,_,1,1,0,_,_,_,_,_","A,B,C,D,E,F,G,0,0,1,K,L,M,N,O","HxI->J "),
?CASE_BODY("_,_,_,_,_,_,0,1,1,_,_,_,_,_,_","A,B,C,D,E,F,1,0,0,J,K,L,M,N,O","IxH->G "),
?CASE_BODY("_,0,_,_,1,_,_,_,1,_,_,_,_,_,_","A,1,C,D,0,F,G,H,0,J,K,L,M,N,O","IxE->B "),
?CASE_BODY("_,_,_,_,_,_,_,0,1,1,_,_,_,_,_","A,B,C,D,E,F,G,1,0,0,K,L,M,N,O","JxI->H "),
?CASE_BODY("_,_,0,_,_,1,_,_,_,1,_,_,_,_,_","A,B,1,D,E,0,G,H,I,0,K,L,M,N,O","JxF->C "),
?CASE_BODY("_,_,_,0,_,_,1,_,_,_,1,_,_,_,_","A,B,C,1,E,F,0,H,I,J,0,L,M,N,O","KxG->D "),
?CASE_BODY("_,_,_,_,_,_,_,_,_,_,1,1,0,_,_","A,B,C,D,E,F,G,H,I,J,0,0,1,N,O","KxL->M "),
?CASE_BODY("_,_,_,_,0,_,_,1,_,_,_,1,_,_,_","A,B,C,D,1,F,G,0,I,J,K,0,M,N,O","LxH->E "),
?CASE_BODY("_,_,_,_,_,_,_,_,_,_,_,1,1,0,_","A,B,C,D,E,F,G,H,I,J,K,0,0,1,O","LxM->N "),
?CASE_BODY("_,_,_,_,_,_,_,_,_,_,0,1,1,_,_","A,B,C,D,E,F,G,H,I,J,1,0,0,N,O","MxL->K "),
?CASE_BODY("_,_,_,0,_,_,_,1,_,_,_,_,1,_,_","A,B,C,1,E,F,G,0,I,J,K,L,0,N,O","MxH->D "),
?CASE_BODY("_,_,_,_,_,0,_,_,1,_,_,_,1,_,_","A,B,C,D,E,1,G,H,0,J,K,L,0,N,O","MxI->F "),
?CASE_BODY("_,_,_,_,_,_,_,_,_,_,_,_,1,1,0","A,B,C,D,E,F,G,H,I,J,K,L,0,0,1","MxN->N "),
?CASE_BODY("_,_,_,_,_,_,_,_,_,_,_,0,1,1,_","A,B,C,D,E,F,G,H,I,J,K,1,0,0,O","NxM->L "),
?CASE_BODY("_,_,_,_,0,_,_,_,1,_,_,_,_,1,_","A,B,C,D,1,F,G,H,0,J,K,L,M,0,O","NxI->E "),
?CASE_BODY("_,_,_,_,_,_,_,_,_,_,_,_,0,1,1","A,B,C,D,E,F,G,H,I,J,K,L,1,0,0","NxN->M "),
?CASE_BODY("_,_,_,_,_,0,_,_,_,1,_,_,_,_,1","A,B,C,D,E,1,G,H,I,0,K,L,M,N,0","NxJ->F ").

%% ?CASE_BODY([49,49,95,48,95,95,95,95,95,95,95,95,95,95,95],[48,48,67,49,69,70,71,72,73,74,75,76,77,78,79],[65,120,66,45,62,68,32]),
%% ?CASE_BODY([49,95,49,95,95,48,95,95,95,95,95,95,95,95,95],[48,66,48,68,69,49,71,72,73,74,75,76,77,78,79],[65,120,67,45,62,70,32]),
%% ?CASE_BODY([95,49,95,49,95,95,48,95,95,95,95,95,95,95,95],[65,48,67,48,69,70,49,72,73,74,75,76,77,78,79],[66,120,68,45,62,71,32]),
%% ?CASE_BODY([95,49,95,95,49,95,95,95,48,95,95,95,95,95,95],[65,48,67,68,48,70,71,72,49,74,75,76,77,78,79],[66,120,69,45,62,73,32]),
%% ?CASE_BODY([95,95,49,95,49,95,95,48,95,95,95,95,95,95,95],[65,66,48,68,48,70,71,49,73,74,75,76,77,78,79],[67,120,69,45,62,72,32]),
%% ?CASE_BODY([95,95,49,95,95,49,95,95,95,48,95,95,95,95,95],[65,66,48,68,69,48,71,72,73,49,75,76,77,78,79],[67,120,70,45,62,74,32]),
%% ?CASE_BODY([48,49,95,49,95,95,95,95,95,95,95,95,95,95,95],[49,48,67,48,69,70,71,72,73,74,75,76,77,78,79],[68,120,66,45,62,65,32]),
%% ?CASE_BODY([95,95,95,49,49,48,95,95,95,95,95,95,95,95,95],[65,66,67,48,48,49,71,72,73,74,75,76,77,78,79],[68,120,69,45,62,70,32]),
%% ?CASE_BODY([95,95,95,49,95,95,95,49,95,95,95,95,48,95,95],[65,66,67,48,69,70,71,48,73,74,75,76,49,78,79],[68,120,72,45,62,77,32]),
%% ?CASE_BODY([95,95,95,49,95,95,49,95,95,95,48,95,95,95,95],[65,66,67,48,69,70,48,72,73,74,49,76,77,78,79],[68,120,71,45,62,75,32]),
%% ?CASE_BODY([95,95,95,95,49,95,95,49,95,95,95,48,95,95,95],[65,66,67,68,48,70,71,48,73,74,75,49,77,78,79],[69,120,72,45,62,76,32]),
%% ?CASE_BODY([95,95,95,95,49,95,95,95,49,95,95,95,95,48,95],[65,66,67,68,48,70,71,72,48,74,75,76,77,49,79],[69,120,73,45,62,78,32]),
%% ?CASE_BODY([48,95,49,95,95,49,95,95,95,95,95,95,95,95,95],[49,66,48,68,69,48,71,72,73,74,75,76,77,78,79],[70,120,67,45,62,65,32]),
%% ?CASE_BODY([95,95,95,48,49,49,95,95,95,95,95,95,95,95,95],[65,66,67,49,48,48,71,72,73,74,75,76,77,78,79],[70,120,69,45,62,68,32]),
%% ?CASE_BODY([95,95,95,95,95,49,95,95,49,95,95,95,48,95,95],[65,66,67,68,69,48,71,72,48,74,75,76,49,78,79],[70,120,73,45,62,77,32]),
%% ?CASE_BODY([95,95,95,95,95,49,95,95,95,49,95,95,95,95,48],[65,66,67,68,69,48,71,72,73,48,75,76,77,78,49],[70,120,74,45,62,79,32]),
%% ?CASE_BODY([95,48,95,49,95,95,49,95,95,95,95,95,95,95,95],[65,49,67,48,69,70,48,72,73,74,75,76,77,78,79],[71,120,68,45,62,66,32]),
%% ?CASE_BODY([95,95,95,95,95,95,49,49,48,95,95,95,95,95,95],[65,66,67,68,69,70,48,48,49,74,75,76,77,78,79],[71,120,72,45,62,73,32]),
%% ?CASE_BODY([95,95,48,95,49,95,95,49,95,95,95,95,95,95,95],[65,66,49,68,48,70,71,48,73,74,75,76,77,78,79],[72,120,69,45,62,67,32]),
%% ?CASE_BODY([95,95,95,95,95,95,95,49,49,48,95,95,95,95,95],[65,66,67,68,69,70,71,48,48,49,75,76,77,78,79],[72,120,73,45,62,74,32]),
%% ?CASE_BODY([95,95,95,95,95,95,48,49,49,95,95,95,95,95,95],[65,66,67,68,69,70,49,48,48,74,75,76,77,78,79],[73,120,72,45,62,71,32]),
%% ?CASE_BODY([95,48,95,95,49,95,95,95,49,95,95,95,95,95,95],[65,49,67,68,48,70,71,72,48,74,75,76,77,78,79],[73,120,69,45,62,66,32]),
%% ?CASE_BODY([95,95,95,95,95,95,95,48,49,49,95,95,95,95,95],[65,66,67,68,69,70,71,49,48,48,75,76,77,78,79],[74,120,73,45,62,72,32]),
%% ?CASE_BODY([95,95,48,95,95,49,95,95,95,49,95,95,95,95,95],[65,66,49,68,69,48,71,72,73,48,75,76,77,78,79],[74,120,70,45,62,67,32]),
%% ?CASE_BODY([95,95,95,48,95,95,49,95,95,95,49,95,95,95,95],[65,66,67,49,69,70,48,72,73,74,48,76,77,78,79],[75,120,71,45,62,68,32]),
%% ?CASE_BODY([95,95,95,95,95,95,95,95,95,95,49,49,48,95,95],[65,66,67,68,69,70,71,72,73,74,48,48,49,78,79],[75,120,76,45,62,77,32]),
%% ?CASE_BODY([95,95,95,95,48,95,95,49,95,95,95,49,95,95,95],[65,66,67,68,49,70,71,48,73,74,75,48,77,78,79],[76,120,72,45,62,69,32]),
%% ?CASE_BODY([95,95,95,95,95,95,95,95,95,95,95,49,49,48,95],[65,66,67,68,69,70,71,72,73,74,75,48,48,49,79],[76,120,77,45,62,78,32]),
%% ?CASE_BODY([95,95,95,95,95,95,95,95,95,95,48,49,49,95,95],[65,66,67,68,69,70,71,72,73,74,49,48,48,78,79],[77,120,76,45,62,75,32]),
%% ?CASE_BODY([95,95,95,48,95,95,95,49,95,95,95,95,49,95,95],[65,66,67,49,69,70,71,48,73,74,75,76,48,78,79],[77,120,72,45,62,68,32]),
%% ?CASE_BODY([95,95,95,95,95,48,95,95,49,95,95,95,49,95,95],[65,66,67,68,69,49,71,72,48,74,75,76,48,78,79],[77,120,73,45,62,70,32]),
%% ?CASE_BODY([95,95,95,95,95,95,95,95,95,95,95,95,49,49,48],[65,66,67,68,69,70,71,72,73,74,75,76,48,48,49],[77,120,78,45,62,79,32]),
%% ?CASE_BODY([95,95,95,95,95,95,95,95,95,95,95,48,49,49,95],[65,66,67,68,69,70,71,72,73,74,75,49,48,48,79],[78,120,77,45,62,76,32]),
%% ?CASE_BODY([95,95,95,95,48,95,95,95,49,95,95,95,95,49,95],[65,66,67,68,49,70,71,72,48,74,75,76,77,48,79],[78,120,73,45,62,69,32]),
%% ?CASE_BODY([95,95,95,95,95,95,95,95,95,95,95,95,48,49,49],[65,66,67,68,69,70,71,72,73,74,75,76,49,48,48],[79,120,78,45,62,77,32]),
%% ?CASE_BODY([95,95,95,95,95,48,95,95,95,49,95,95,95,95,49],[65,66,67,68,69,49,71,72,73,48,75,76,77,78,48],[79,120,74,45,62,70,32]).
%%     %% case Initial_Board of
%%     %%     [1, 1, _, 0, _, _, _, _, _, _, _, _, _, _, _] -> 
%%     %% 	    try spawn(iq, solve, [[0, 0, C, 1, E, F, G, H, I, J, K, L, M, N, O], Moves ++ "AxB->D  "])
%%     %% 	    catch error -> ok end;	    
%%     %% 	_ -> false
%%     %% end,
%%     io:format("~s~n", ["1st case of A"]),
%%     case Initial_Board of
%%         [1, _, 1, _, _, 0, _, _, _, _, _, _, _, _, _] -> 
%% 	    try spawn(iq, solve, [[0, B, 0, D, E, 1, G, H, I, J, K, L, M, N, O], Moves ++ "AxC->F  "])
%% 	    catch error -> ok end;
%% 	_ -> false
%%     end,
%%     io:format("~s~n", ["2nd case of A"]);
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
%% find_moves([A, B, 1, D, E, F, G, H, I, J, K, L, M, N, O], Moves) ->
%%     Initial_Board = [A, B, 1, D, E, F, G, H, I, J, K, L, M, N, O],
%%     % CxE->H, CxF->J
%%     case Initial_Board of
%%        %[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
%% 	[_, _, 1, _, 1, _, _, 0, _, _, _, _, _, _, _] -> 
%% 	    %                     [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
%% 	    try spawn(iq, solve, [[A, B, 0, D, 0, F, G, 1, I, J, K, L, M, N, O], Moves ++ "CxE->H  "])
%% 	    catch error -> ok end;
%% 	_ -> false
%%     end,
%%     io:format("~s~n", ["1st case of C"]),
%%     case Initial_Board of
%%        %[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
%% 	[_, _, 1, _, _, 1, _, _, _, 0, _, _, _, _, _] -> 
%% 	    %                     [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
%% 	    try spawn(iq, solve, [[A, B, 0, D, E, 0, G, 1, I, 1, K, L, M, N, O], Moves ++ "CxF->J  "])
%% 	    catch error -> ok end;
%% 	_ -> false
%%     end,
%%     io:format("~s~n", ["2nd case of C"]);
%% find_moves([A, B, C, 1, E, F, G, H, I, J, K, L, M, N, O], Moves) ->
%%     Initial_Board = [A, B, C, 1, E, F, G, H, I, J, K, L, M, N, O],
%%     % DxB->A, DxE->F, DxH->M, DxG->K
%%     case Initial_Board of
%%        %[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
%% 	[0, 1, _, 1, 1, _, _, _, _, _, _, _, _, _, _] -> 
%% 	    %                     [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
%% 	    try spawn(iq, solve, [[1, 0, C, 0, E, F, G, H, I, J, K, L, M, N, O], Moves ++ "DxB->A  "])
%% 	    catch error -> ok end;
%% 	_ -> false
%%     end,
%%     io:format("~s~n", ["1st case of D"]),
%%     case Initial_Board of
%%        %[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
%% 	[_, _, _, 1, 1, 0, _, _, _, _, _, _, _, _, _] -> 
%% 	    %                     [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
%% 	    try spawn(iq, solve, [[A, B, C, 0, 0, 1, G, H, I, J, K, L, M, N, O], Moves ++ "DxE->F  "])
%% 	    catch error -> ok end;
%% 	_ -> false
%%     end,
%%     io:format("~s~n", ["2nd case of D"]),
%%     case Initial_Board of
%%        %[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
%% 	[_, _, _, 1, _, _, _, 1, _, _, _, _, 0, _, _] -> 
%% 	    %                     [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
%% 	    try spawn(iq, solve, [[A, B, C, 0, E, F, G, 0, I, J, K, L, 1, N, O], Moves ++ "DxH->M  "])
%% 	    catch error -> ok end;
%% 	_ -> false
%%     end,
%%     io:format("~s~n", ["3rd case of D"]),
%%     case Initial_Board of
%%        %[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
%% 	[_, _, _, 1, _, _, 1, _, _, _, 0, _, _, _, _] -> 
%% 	    %                     [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
%% 	    try spawn(iq, solve, [[A, B, C, 0, E, F, 0, H, I, J, 1, L, M, N, O], Moves ++ "DxG->K  "])
%% 	    catch error -> ok end;
%% 	_ -> false
%%     end,
%%     io:format("~s~n", ["4th case of D"]).
%%     case Initial_Board of
%% 	[_, _, _, 1, _, _, 1, _, _, _, 0, _, _, _, _] -> spawn(solve([A, B, C, 0, E, F, 0, H, I, J, 1, L, M, N, O], Moves ++ "DxG->K  "));
%%          _ -> false
%%     end.
%%     % ExH->L, ExI->N
%%     % FxC->A, FxE->D, FxI->M, FxJ->O
%%     % GxD->B, GxH->I
%%     % HxE->C, HxI->J
%%     % IxH->G, IxE->B
%%     % JxI->H, JxF->C
%%     % KxG->D, KxL->M
%%     % LxH->E, LxM->N
%%     % MxL->K, MxH->D, MxI->F, MxN-O
%%     % NxM->L, NxI->E
%%     % OxN->M, OxJ->F
%% %1.
    
pretty_print([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]) ->
    io:format("    ~B~n", [A]),
    io:format("   ~B ~B~n", [B, C]),
    io:format("  ~B ~B ~B~n", [D, E, F]),
    io:format(" ~B ~B ~B ~B~n", [G, H, I, J]),
    io:format("~B ~B ~B ~B ~B~n", [K, L, M, N, O]),
    io:format("Total Pegs: ~B~n~n", [count_pegs([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O])]).
    
rotate_left([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]) ->
    [O, J, N, F, I, M, C, E, H, L, A, B, D, G, K].

rotate_right(Board) ->
    rotate_left(rotate_left(Board)).
    
count_pegs(Board) ->
    lists:foldl(fun(X, Sum) -> X + Sum end, 0, Board).
