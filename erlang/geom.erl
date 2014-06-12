%%%-------------------------------------------------------------------
%%% @author  <moonsr@MOONS1>
%%% @copyright (C) 2013, 
%%% @doc Functions for calculating areas of geometric shapes.
%%% @version 0.1
%%%
%%% @end
%%% Created : 25 Sep 2013 by  <moonsr@MOONS1>
%%%-------------------------------------------------------------------

-module(geom).
-export([area/1]).

%%--------------------------------------------------------------------
%% @doc Calculates the area of a rectangle, given the length and width.
%% or the area of a circle given just the radius. Returns the area.
%% @spec
%% @end
%%--------------------------------------------------------------------

-spec(area(atom(),number(),number()) -> number()).
-spec(area({atom(), number(), number()}) -> number()).

%% etude 3.4
%% area(rectangle, W ,L ) when W >= 0, L >= 0  -> W * L;
%% area(triangle, A, B ) when A >= 0, B >= 0 -> A * B / 2.0;
%% area(ellipse, A, B) when A >= 0, B >= 0 -> math:pi() * A * B;
%% area(_, _, _) -> 0.0.

%% etude 4.1
area(Shape, A, B) when A >= 0, B >= 0 ->
    case Shape of
	rectangle -> A * B * 1.0;
	triangle -> (A * B) / 2.0;
	ellipse -> math:pi() * A * B;
	_ -> 0.0	
    end.


area({Shape, A, B}) ->
    area(Shape, A, B).
 
