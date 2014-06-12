-module(euler016).
-export([go/1]).

go(X) ->
    Number =  powers:raise(2, X),
    Digits = integer_to_list(Number),
    A = [list_to_integer([B]) || B <- Digits],
    lists:foldl(fun(C, Sum) -> C + Sum end, 0, A).

