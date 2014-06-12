%%% @author  <moonsr@MOONS1>
%%% @copyright (C) 2014, 
%%% @doc
%%%
%%% @end
%%% Created :  3 Mar 2014 by  <moonsr@MOONS1>

-module(calculus).
-export([derivative/2]).
-compile([debug_info]).

-spec(derivative(function(), float()) -> float()).
derivative(F, X) ->
    Delta = 1.0e-10,
    (F(X + Delta) - F(X)) / Delta.



