-module(tfe).
-export([go/0]).

go() ->
    Goo = [2048, 2048, 2048, 2048, 
	   2048, 2048, 2048, 2048,
	   2048, 2048, 2048, 2048,
	   2048, 2048, 2048, 2048],
    print_board(Goo),
    {ok, A} = io:fread("", "~c"),    
%A = io:get_chars("", 1),
    io:format("~s~n", [A]),
    Board = move(A, Goo),
    print_board(Board).


move(["h"], Board) ->
    move(left, Board);
move(["j"], Board) ->
    move(down, Board);
move(["k"], Board) ->
    move(up, Board);
move(["l"], Board) ->
    move(right, Board);
move(left, Board) ->
    consolidate(Board);
move(right, Board) ->
    mirror(consolidate(mirror(Board)));
move(down, Board) ->
	rotate(consolidate(rotate(rotate(rotate(Board)))));
move(up, Board) ->
	rotate(rotate(rotate(consolidate(rotate(Board))))).

%A B C D  ++Rot1++ M I E A ++Rot2++ P O N M ++Rot3++ D H L P ++Rot4++ A B C D
%E F G H           N J F B	    L K J I          C G K O          E F G H
%I J K L           O K G C          H G F E          B F J N          I J K L
%M N O P           P L H D          D C B A          A E I M          M N O P
rotate([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P]) ->
    [M, I, E, A, N, J, F, B, O, K, G, C, P, L, H, D].

mirror([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P]) ->
    [D, C, B, A, H, G, F, E, L, K, J, I, P, O, N, M].

consolidate([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P]) ->
    Row1 = rowcons(A, B, C, D),
    Row2 = rowcons(E, F, G, H),
    Row3 = rowcons(I, J, K, L),
    Row4 = rowcons(M, N, O, P),
    lists:flatten([Row1, Row2, Row3, Row4]).

rowcons(A, B, C, D) when (A =:= B) and (C =:= D) and (A =/= 0) and (C =/= 0)->
    rowcons(A+B, C+D, 0, 0);
rowcons(A, B, C, D) when A =:= B and (A =/= 0) ->
    rowcons(A+B, C, D, 0);
rowcons(A, B, C, D) when B =:= C and (B =/= 0) ->
    rowcons(A, B+C, D, 0);
rowcons(A, B, C, D) when C =:= D and (C =/= 0) ->
    rowcons(A, B, C+D, 0);
rowcons(A, B, C, D) ->
    [A, B, C, D].

%% Looks like I'll want to use wx to drive this -- gives access to raw keyboard (no enter key) and can even do a gui.
%%   WXK_LEFT
%%     WXK_UP
%%     WXK_RIGHT
%%     WXK_DOWN
%% http://www.erlang.org/doc/man/wxKeyEvent.html#getKeyCode-1
%% http://erlangcentral.org/frame/?href=http%3A%2F%2Fwxerlang.dougedmunds.com#.VXs8IkZ4FKg

print_board(Board) ->
    io:fwrite("\e[2J"),
    print_board1(Board).
print_board1([]) -> %last line
    io:format(" ---------------------------  ~n");
print_board1([A, B, C, D | Tail]) ->
    io:format(" ---------------------------  ~n"),
    io:format("|      |      |      |      | ~n"),
    io:format("| ~4B | ~4B | ~4B | ~4B | ~n", [A, B, C, D]),
    io:format("|      |      |      |      | ~n"),
    print_board1(Tail).


					       
