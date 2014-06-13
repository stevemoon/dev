-module(euler019).
-export([go/0]).

go() ->
    Dates = [{Y, M, D} || Y <- lists:seq(1901, 2000), 
			  M <- lists:seq(1,12), 
			  D <- [1]],
    WeekDays = [calendar:day_of_the_week(X) || X <- Dates],
    Sundays = [X || X <- WeekDays, X =:= 7],
    lists:foldl(fun(X, Sum) -> X + Sum end, 0, Sundays) / 7.

