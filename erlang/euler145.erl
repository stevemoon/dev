-module(euler145).
-export([go/1, test/1]).

go(Max) ->
    Sequence = lists:seq(10,Max),
    io:format("~w~n", [Sequence]),
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



<<<<<<< HEAD
% test(Num) ->
    
=======
test(Num) ->
    Fwd = integer_to_list(Num),
    Bwd = lists:reverse(Fwd),
    BwdNum = list_to_integer(Bwd),
  
    Sum = Num + BwdNum,
    SumList = [list_to_integer([X]) || X <- integer_to_list(Sum)],
    EvenDigits = [X || X <- SumList, (X rem 2 =:= 0)],
    case length(EvenDigits) of
	0 -> true;
	     %io:format("Num: ~w BwdNum: ~w ~n", [Num, BwdNum]),
	     %io:format("Sum: ~w  SumList: ~w   EvenDigits: ~w~n", [Sum, SumList, EvenDigits]);
	_ -> false
        end.
>>>>>>> FETCH_HEAD
