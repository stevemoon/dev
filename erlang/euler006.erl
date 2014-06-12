-module(euler006).
-export([go/0]).

go() ->
    Squares = [X * X || X <- lists:seq(1,100)],
    SumSq = lists:foldl(fun(X, Sum) -> X + Sum end, 0, Squares),
    SqSum = lists:foldl(fun(X, Sum) -> X + Sum end, 0, lists:seq(1,100)),
    (SqSum * SqSum) - SumSq.
