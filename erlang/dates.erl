-module(dates).
-export([date_parts/1,julian/1]).

-spec(date_parts(string()) -> list()).
date_parts(String) ->
    [YStr, MStr, DStr] =  re:split(String,"-",[{return, list}]),
    [element(1, string:to_integer(YStr)),
     element(1, string:to_integer(MStr)),
     element(1, string:to_integer(DStr))].

%% julian(String) ->
%%     [Y, M, D] = date_parts(String),
%%     DaysPerMonth = [31, feb_days(Y), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
%%     Accum = 0,
%%     julian(Y, M, D, DaysPerMonth, Accum).

%% julian(Y, M, D, DaysPerMonth, Accum) when M > (13 - length(DaysPerMonth)) ->
%%     [Head | Tail] = DaysPerMonth,
%%     julian(Y, M, D, Tail, Accum + Head);

%% julian(Y, M, D, DaysPerMonth, Accum) when M == (13 - length(DaysPerMonth))->
%%     Accum + D.

julian(String)->
    [Y, M, D] = date_parts(String),
    DaysPerMonth = [31, feb_days(Y), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
    {Sublist, _} = lists:split(M - 1, DaysPerMonth),
    D + lists:foldl(fun(V, A) ->
				V + A end, 0, Sublist).
feb_days(Y) ->
   if (Y rem 4 == 0 andalso Y rem 100 /= 0) orelse (Y rem 400 == 0) -> 29;
   true -> 28
   end.

