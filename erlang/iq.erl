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
   % pretty_print(rotate_left(Board)),
   % pretty_print(rotate_right(Board)).

solve(Board, Moves) ->
    Peg_Count = count_pegs(Board),
    case Peg_Count of 
        1 -> io:format("Solution found: ~s~n", [Moves]);
	_ -> find_moves(Board, Moves)
    end.

find_moves([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O], Moves) ->
    Initial_Board = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O],
    % AxB->D, AxC->F
    case Initial_Board of
        [1, 1, _, 0, _, _, _, _, _, _, _, _, _, _, _] -> spawn(solve([0, 0, C, 1, E, F, G, H, I, J, K, L, M, N, O], Moves ++ "AxB->D  "));
	_ -> false
    end,
    case Initial_Board of
        [1, _, 1, _, _, 0, _, _, _, _, _, _, _, _, _] -> spawn(solve([0, B, 0, D, E, 1, G, H, I, J, K, L, M, N, O], Moves ++ "AxC->F  "));
	_ -> false
    end,
    % BxD->G, BxE->I
    % CxE->H, CxF->J
    % DxB->A, DxE->F, DxH->M, DxG->K
    case Initial_Board of
	[_, _, _, 1, _, _, 1, _, _, _, 0, _, _, _, _] -> spawn(solve([A, B, C, 0, E, F, 0, H, I, J, 1, L, M, N, O], Moves ++ "DxG->K  "));
         _ -> false
    end.
    % ExH->L, ExI->N
    % FxC->A, FxE->D, FxI->M, FxJ->O
    % GxD->B, GxH->I
    % HxE->C, HxI->J
    % IxH->G, IxE->B
    % JxI->H, JxF->C
    % KxG->D, KxL->M
    % LxH->E, LxM->N
    % MxL->K, MxH->D, MxI->F, MxN-O
    % NxM->L, NxI->E
    % OxN->M, OxJ->F
%1.
    
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
