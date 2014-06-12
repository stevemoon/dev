-module(euler019).
-export([go/0]).

go() ->
    Dates = [{Y, M, D} || Y <- lists:seq(1901, 2000), 
			  M <- lists:seq(1,12), 
			  D <- [1]],
    calendar:day_of_the_week(hd(Dates)).

