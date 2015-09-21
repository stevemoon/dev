%%% Prime permutations
%%% Problem 49
%%% The arithmetic sequence, 1487, 4817, 8147, in which each of the terms increases by 3330, 
%%% is unusual in two ways: (i) each of the three terms are prime, and, (ii) each of the 
%%% 4-digit numbers are permutations of one another.
%%%
%%% There are no arithmetic sequences made up of three 1-, 2-, or 3-digit primes, exhibiting 
%%% this property, but there is one other 4-digit increasing sequence.
%%%
%%% What 12-digit number do you form by concatenating the three terms in this sequence?

-module(euler049).
-export([go/1]).

go(FileName) ->
    PrimeList = readlines(FileName).

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    lists:reverse(get_all_lines(Device, [])).
get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), Accum;
        Line ->
            SLine = string:strip(Line, right, $\n),
            get_all_lines(Device, [{P1_decoded_hand, P2_decoded_hand}|Accum])
    end.
