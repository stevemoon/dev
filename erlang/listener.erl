-module(listener).
-export([listen/0]).

listen() ->
    receive 
	{From, Msg} -> From ! {self(), [Msg]}
    end,
    listen().

