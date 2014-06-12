-module(euler019).
-export([go/0]).

go() ->
    Months = lists:seq(1,12),
    Years = lists:seq(1901, 2000),
    calendar:day_of_the_week(2014, 1, 1).
