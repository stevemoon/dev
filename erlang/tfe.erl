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
    io:format("~s~n", [A]).


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
    io:format("| ~B | ~B | ~B | ~B | ~n", [A, B, C, D]),
    io:format("|      |      |      |      | ~n"),
    print_board(Tail).


					       
