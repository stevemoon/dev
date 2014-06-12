-module(process).
-export([go/0]).

go() ->
    Pid = spawn(listener,listen,[]),
    register(listener,Pid),
    register(process,self()),
    go2().

go2() ->    
    Input = get_input(),
    listener ! {self(), Input},
    receive 
	{_, Msg} -> io:format("Received ~s~n", [Msg])
    end,
    go2().
    

get_input() ->
    io:get_line("Say something goober!> ").
