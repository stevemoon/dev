-module(euler145).
-export([go/1, test/1]).

% Answer is 608720
% This takes a long time to run (~1 hour) for 1,000,000,000. There must be some serious
% optimization I am missing...

go(Max) ->
    Sequence = lists:seq(10,Max),
    %io:format("~w~n", [Sequence]),
    go2(Sequence, []).

go2([Next | Sequence], Accum) ->
    case test(Next) of
	true ->
	    go2(Sequence, Accum ++ [Next]);
	false ->
	    go2(Sequence, Accum)
    end;
go2([],[]) ->
    none_found;
go2([],Accum) ->
    length(Accum).


test(Num) when (Num rem 10 =/= 0) ->
    Fwd = integer_to_list(Num),
    Bwd = lists:reverse(Fwd),
    BwdNum = list_to_integer(Bwd),
    Sum = Num + BwdNum,
    SumList = [list_to_integer([X]) || X <- integer_to_list(Sum)],
    EvenDigits = [X || X <- SumList, (X rem 2 =:= 0)],
    %io:format("Sum: ~w  SumList: ~w   EvenDigits: ~w~n", [Sum, SumList, EvenDigits]),    
    case length(EvenDigits) of
	0 -> true;
	     %io:format("Num: ~w BwdNum: ~w ~n", [Num, BwdNum]),
	_ -> false
    end;
test(_) ->
    false.


