-module(euler011).
-export([go/0]).

go() ->
    Grid = [08,02,22,97,38,15,00,40,00,75,04,05,07,78,52,12,50,77,91,08,49,49,99,40,17,81,18,57,60,87,17,40,98,43,69,48,04,56,62,00,81,49,31,73,55,79,14,29,93,71,40,67,53,88,30,03,49,13,36,65,52,70,95,23,04,60,11,42,69,24,68,56,01,32,56,71,37,02,36,91,22,31,16,71,51,67,63,89,41,92,36,54,22,40,40,28,66,33,13,80,24,47,32,60,99,03,45,02,44,75,33,53,78,36,84,20,35,17,12,50,32,98,81,28,64,23,67,10,26,38,40,67,59,54,70,66,18,38,64,70,67,26,20,68,02,62,12,20,95,63,94,39,63,08,40,91,66,49,94,21,24,55,58,05,66,73,99,26,97,17,78,78,96,83,14,88,34,89,63,72,21,36,23,09,75,00,76,44,20,45,35,14,00,61,33,97,34,31,33,95,78,17,53,28,22,75,31,67,15,94,03,80,04,62,16,14,09,53,56,92,16,39,05,42,96,35,31,47,55,58,88,24,00,17,54,24,36,29,85,57,86,56,00,48,35,71,89,07,05,44,44,37,44,60,21,58,51,54,17,58,19,80,81,68,05,94,47,69,28,73,92,13,86,52,17,77,04,89,55,40,04,52,08,83,97,35,99,16,07,97,57,32,16,26,26,79,33,27,98,66,88,36,68,87,57,62,20,72,03,46,33,67,46,55,12,32,63,93,53,69,04,42,16,73,38,25,39,11,24,94,72,18,08,46,29,32,40,62,76,36,20,69,36,41,72,30,23,88,34,62,99,69,82,67,59,85,74,04,36,16,20,73,35,29,78,31,90,01,74,31,49,71,48,86,81,16,23,57,05,54,01,70,54,71,83,51,54,69,16,92,33,48,61,43,52,01,89,19,67,48],
    Diags = [{321, 384}, {301, 385}, {281, 386}, {261,387}, 
	     {241, 388}, {221, 389}, {201, 390}, {181, 391}, 
	     {161, 392}, {141, 393}, {121, 394}, {101, 395}, 
	     { 81, 396}, { 61, 397}, { 41, 398}, { 21, 399}, 
	     {  1, 400}, {  2, 380}, {  3, 360}, {  4, 340}, 
	     {  5, 320}, {  6, 300}, {  7, 280}, {  8, 260},
	     {  9, 240}, { 10, 220}, { 11, 200}, { 12, 180},
	     { 13, 160}, { 14, 140}, { 15, 120}, { 16, 100},
	     { 17,  80}],
    io:format("Horiz:~w~n",[max_horiz(Grid, 1, 1)]),
    io:format("Vert:~w~n", [max_vert(Grid, 1, 1)]),
    io:format("Diag:~w~n", [max_diag(Grid, Diags, 1)]),
    TGrid = lists:flatten(transpose(Grid, [], 1)),
    io:format("RevDiag:~w~n", [max_diag(TGrid, Diags, 1)]).


max_diag(Grid, [Diag | Diags], Biggest) ->
    Row = diag_row(Grid, Diag, []),
%    io:format("~w~n", [Row]),
    X = srch(Row, 1, 1),
    case (X > Biggest) of
	true ->
	    max_diag(Grid, Diags, X);
	false ->
	    max_diag(Grid, Diags, Biggest)
    end;
max_diag(_, [], Biggest) ->
    Biggest.

diag_row(Grid, {Start, End}, Accum) when Start =< End ->
    diag_row(Grid, {Start + 21, End}, Accum ++ [lists:nth(Start, Grid)]);
diag_row(_, {Start, End}, Accum) when Start > End ->
    Accum.


max_horiz(Grid, Start, Biggest) when Start < 401 ->
    Row = lists:sublist(Grid, Start, 20),
 %   io:format("~w~n", [Row]),
    X = srch(Row, 1, 1),
    case (X > Biggest) of
	true ->
	    max_horiz(Grid, Start + 20, X);
	false ->
	    max_horiz(Grid, Start + 20, Biggest)
    end;
max_horiz(_, 401, Biggest) ->
    Biggest.


max_vert(Grid, Start, Biggest) when Start < 21 ->
    Column = column_list(Grid, Start, []),
  %  io:format("~w~n", [Column]),
    X = srch(Column, 1, 1),
    case (X > Biggest) of
	true ->
	    max_vert(Grid, Start + 1, X);
	false ->
	    max_vert(Grid, Start + 1, Biggest)
    end;
max_vert(_, 21, Biggest) ->
    Biggest.

column_list(Grid, Start, Accum) when Start < 401 ->
    column_list(Grid, Start + 20, Accum ++ [lists:nth(Start, Grid)]);
column_list(_ , _, Accum ) ->
    Accum.

transpose(Grid, TGrid, Start) when Start < 21 ->
    Column = lists:reverse(column_list(Grid, Start, [])),
    transpose(Grid, TGrid ++ [Column], Start + 1);
transpose(_, TGrid, Start) when Start >= 21 ->
    TGrid.


srch(SrcList, ChunkStart, Biggest) when ((ChunkStart + 3) =< length(SrcList)) ->
    FooBar = lists:sublist(SrcList, ChunkStart, 4),
    X = list_product(FooBar),
    case (X > Biggest) of
	true ->
	    srch(SrcList, ChunkStart + 1, X);
	false ->
	    srch(SrcList, ChunkStart + 1, Biggest)
    end;
srch(SrcList, ChunkStart, Biggest) when ((ChunkStart + 3) > length(SrcList)) ->
    Biggest.
					     
    

list_product(SrcList) ->
    lists:foldl(fun(X, Prod) -> X * Prod end, 1, SrcList).
    
    %io:format(Y).
	       
