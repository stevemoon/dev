-module('adv_one_b').
-export([go/0]).

go() ->
    Data = hd(readlines('../input.txt')),
%    Opens = length(lists:filter(fun(Element) -> Element == $( end, Data)),
%    Closes = length(lists:filter(fun(Element) -> Element == $) end, Data)),
%    Opens - Closes.
    Length = length(Data),
    count(Data, Length, 0).


count([], _, Accum) ->
    Accum;
count(Data, Length, -1) ->
    io:format("~s ~w ~n", ["First Basement at:", Length - length(Data)]);
count([$( | Tail], Length, Accum) ->
    count(Tail, Length, Accum + 1);
count([$) | Tail], Length, Accum) ->
    count(Tail, Length, Accum - 1);
count([_ | Tail], Length, Accum) ->
    count(Tail, Length, Accum).


readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    lists:reverse(get_all_lines(Device, [])).

 
get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), Accum;
        Line ->
            SLine = string:strip(Line, right, $\n),
            get_all_lines(Device, [SLine|Accum])
    end.

