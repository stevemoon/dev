-module('adv_one').
-export([go/0]).

go() ->
    Data = hd(readlines('../input.txt')),
    Opens = length(lists:filter(fun(Element) -> Element == $( end, Data)),
    Closes = length(lists:filter(fun(Element) -> Element == $) end, Data)),
    Opens - Closes.
				
%    count(Data, 0).


count([], Accum) ->
    Accum;
count([$( | Tail], Accum) ->
    count(Tail, Accum + 1);
count([$) | Tail], Accum) ->
    count(Tail, Accum - 1);
count([_ | Tail], Accum) ->
    count(Tail, Accum).


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

