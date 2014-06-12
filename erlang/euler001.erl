-module(euler001).
-export([go/1]).

go(Max) ->
    Sequence = lists:seq(1, Max),
    Sums = [X || X <- Sequence, (X rem 3 =:= 0) or (X rem 5 =:= 0)],
    lists:foldl(fun(X, Sum) -> X + Sum end, 0, Sums).


