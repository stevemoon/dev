-module(euler145).
-export(go/1).

go(Max) ->
    Sequence = lists:seq(1,Max),
    go2(Sequence, []).

go2([Next | Sequence], Accum) ->
    case test(Next) of
	true ->
	    go2(Sequence, Next ++ [Accum]);
	false ->
	    go2(Sequence, Accum).

% test(Num) ->
    
