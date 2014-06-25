-module(euler018).
-export([go/0]).

go() ->
    %DataFile = file:open("euler018a.txt", read),
    Lines = readlines("euler018.txt"),
    %io:format("~s~n", [Lines]).
    Lines.

readlines(FileName) ->
    {ok, Data} = file:read_file(FileName),
    binary:split(Data, [<<"\n">>], [global]).
