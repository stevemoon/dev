-module(euler002).
-export([go/1]).

go(Max) ->
    Sequence = fiblist(Max, 2, 1, [2,1]),
    Sums = [X || X <- Sequence, (X rem 2 =:= 0)],
    lists:foldl(fun(X, Sum) -> X + Sum end, 0, Sums).
    

fiblist(Max, Last, Prev, Accum) when Max >= Last ->
    fiblist(Max, Last + Prev, Last, [(Last + Prev) | Accum ]);
fiblist(Max, Last, _, Accum) when Max < Last ->
    [_|Return] = Accum,
    lists:reverse(Return).
    
