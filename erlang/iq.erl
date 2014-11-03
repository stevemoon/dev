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
    MoveList = define_moves(),
    PatternList = move_patterns(MoveList, []),
    dyn_match(hd(PatternList), Board).
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
    move_patterns(Tail, [PatternList ++ move_pattern(Head)]);
move_patterns([], PatternList) ->
    PatternList.
    
move_pattern(NumericMove) ->
    move_pattern2([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], NumericMove, [], 1).

move_pattern2(Board, {FromInt, TakesInt, ToInt}, Pattern, Counter) when Counter < 16 ->    
    case Counter of
       FromInt ->
	    move_pattern2(Board, {FromInt, TakesInt, ToInt}, Pattern ++ [1], Counter + 1);
       TakesInt ->
	    move_pattern2(Board, {FromInt, TakesInt, ToInt}, Pattern ++ [1], Counter + 1);
       ToInt ->
	    move_pattern2(Board, {FromInt, TakesInt, ToInt}, Pattern ++ [0], Counter + 1);
       _ ->
	    move_pattern2(Board, {FromInt, TakesInt, ToInt}, Pattern ++ [Counter + 64], Counter + 1)
   end;
move_pattern2(_, _, Pattern, Counter) when Counter == 16 ->
    %io:format("~p~n", [Pattern]),
    Pattern.

    



find_moves([1, B, C, D, E, F, G, H, I, J, K, L, M, N, O], Moves) ->
    Initial_Board = [1, B, C, D, E, F, G, H, I, J, K, L, M, N, O],
    % AxB->D, AxC->F
    case Initial_Board of
        [1, 1, _, 0, _, _, _, _, _, _, _, _, _, _, _] -> 
	    try spawn(iq, solve, [[0, 0, C, 1, E, F, G, H, I, J, K, L, M, N, O], Moves ++ "AxB->D  "])
	    catch error -> ok end;	    
	_ -> false
    end,
    io:format("~s~n", ["1st case of A"]),
    case Initial_Board of
        [1, _, 1, _, _, 0, _, _, _, _, _, _, _, _, _] -> 
	    try spawn(iq, solve, [[0, B, 0, D, E, 1, G, H, I, J, K, L, M, N, O], Moves ++ "AxC->F  "])
	    catch error -> ok end;
	_ -> false
    end,
    io:format("~s~n", ["2nd case of A"]);
find_moves([A, 1, C, D, E, F, G, H, I, J, K, L, M, N, O], Moves) ->
    Initial_Board = [A, 1, C, D, E, F, G, H, I, J, K, L, M, N, O],
    % BxD->G, BxE->I
    case Initial_Board of
	[_, 1, _, 1, _, _, 0, _, _, _, _, _, _, _, _] -> 
	    try spawn(iq, solve, [[A, 0, C, 0, E, F, 1, H, I, J, K, L, M, N, O], Moves ++ "BxD->G  "])
	    catch error -> ok end;
	_ -> false
    end,
    io:format("~s~n", ["1st case of B"]),
    case Initial_Board of
	[_, 1, _, _, 1, _, _, _, 0, _, _, _, _, _, _] -> 
	    try spawn(iq, solve, [[A, 0, C, D, 0, F, G, H, 1, J, K, L, M, N, O], Moves ++ "BxE->I  "])
	    catch error -> ok end;
	_ -> false
    end,
    io:format("~s~n", ["2nd case of B"]);
find_moves([A, B, 1, D, E, F, G, H, I, J, K, L, M, N, O], Moves) ->
    Initial_Board = [A, B, 1, D, E, F, G, H, I, J, K, L, M, N, O],
    % CxE->H, CxF->J
    case Initial_Board of
       %[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
	[_, _, 1, _, 1, _, _, 0, _, _, _, _, _, _, _] -> 
	    %                     [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
	    try spawn(iq, solve, [[A, B, 0, D, 0, F, G, 1, I, J, K, L, M, N, O], Moves ++ "CxE->H  "])
	    catch error -> ok end;
	_ -> false
    end,
    io:format("~s~n", ["1st case of C"]),
    case Initial_Board of
       %[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
	[_, _, 1, _, _, 1, _, _, _, 0, _, _, _, _, _] -> 
	    %                     [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
	    try spawn(iq, solve, [[A, B, 0, D, E, 0, G, 1, I, 1, K, L, M, N, O], Moves ++ "CxF->J  "])
	    catch error -> ok end;
	_ -> false
    end,
    io:format("~s~n", ["2nd case of C"]);
find_moves([A, B, C, 1, E, F, G, H, I, J, K, L, M, N, O], Moves) ->
    Initial_Board = [A, B, C, 1, E, F, G, H, I, J, K, L, M, N, O],
    % DxB->A, DxE->F, DxH->M, DxG->K
    case Initial_Board of
       %[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
	[0, 1, _, 1, 1, _, _, _, _, _, _, _, _, _, _] -> 
	    %                     [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
	    try spawn(iq, solve, [[1, 0, C, 0, E, F, G, H, I, J, K, L, M, N, O], Moves ++ "DxB->A  "])
	    catch error -> ok end;
	_ -> false
    end,
    io:format("~s~n", ["1st case of D"]),
    case Initial_Board of
       %[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
	[_, _, _, 1, 1, 0, _, _, _, _, _, _, _, _, _] -> 
	    %                     [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
	    try spawn(iq, solve, [[A, B, C, 0, 0, 1, G, H, I, J, K, L, M, N, O], Moves ++ "DxE->F  "])
	    catch error -> ok end;
	_ -> false
    end,
    io:format("~s~n", ["2nd case of D"]),
    case Initial_Board of
       %[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
	[_, _, _, 1, _, _, _, 1, _, _, _, _, 0, _, _] -> 
	    %                     [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
	    try spawn(iq, solve, [[A, B, C, 0, E, F, G, 0, I, J, K, L, 1, N, O], Moves ++ "DxH->M  "])
	    catch error -> ok end;
	_ -> false
    end,
    io:format("~s~n", ["3rd case of D"]),
    case Initial_Board of
       %[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
	[_, _, _, 1, _, _, 1, _, _, _, 0, _, _, _, _] -> 
	    %                     [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O]
	    try spawn(iq, solve, [[A, B, C, 0, E, F, 0, H, I, J, 1, L, M, N, O], Moves ++ "DxG->K  "])
	    catch error -> ok end;
	_ -> false
    end,
    io:format("~s~n", ["4th case of D"]).
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
