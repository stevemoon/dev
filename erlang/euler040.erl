-module(euler040).
-export([go/0]).
%% An irrational decimal fraction is created by concatenating the positive 
%%integers:
%%
%% 0.123456789101112131415161718192021...
%%
%% It can be seen that the 12th digit of the fractional part is 1.
%%
%% If dn represents the nth digit of the fractional part, find the value of 
%% the following expression.
%%
%% d1 × d10 × d100 × d1000 × d10000 × d100000 × d1000000
%%

%% Answer is 210
%% This program doesn't seem to work for other LookFor lists, possibly an off-by-one calculation in find_digits.

go() ->
    LookFor = [1, 10, 100, 1000, 10000, 100000, 1000000],
    Digits = find_digits(0, 1, LookFor, []),
    Integers = [list_to_integer([X]) || X <- Digits],
    io:format("~w~n", [Integers]),
    product(tl(Integers), hd(Integers)).


product([X | Tail], Y) ->
    product(Tail, X * Y);
product([], Y)  -> Y.


find_digits(DigitCount, CurrentNum, LookFor, Accum) when length(LookFor) > 0 ->
    A = lists:flatten(integer_to_list(CurrentNum)),
    L = length(A),
    LF = hd(LookFor),
    case LF =< (DigitCount + L) of
	true -> 
	    Index = LF - DigitCount,
	    DesiredDigit = lists:nth(Index, A),
	    find_digits(DigitCount + L, CurrentNum + 1, tl(LookFor), Accum ++ [DesiredDigit]);
	false -> find_digits(DigitCount + L, CurrentNum + 1, LookFor, Accum)
    end;
find_digits(_, _, [], Accum) -> Accum.

	    



