%%%-------------------------------------------------------------------
%%% @author  <moonsr@MOONS1>
%%% @copyright (C) 2013, 
%%% @doc
%%%
%%% @end
%%% Created :  4 Oct 2013 by  <moonsr@MOONS1>
%%%-------------------------------------------------------------------
-module(dijkstra).
-export([gcd/2]).

%%--------------------------------------------------------------------
%% @doc Calculates the area of a rectangle, given the length and width.
%% or the area of a circle given just the radius. Returns the area.
%% @spec
%% @end
%%--------------------------------------------------------------------

-spec(gcd(number(),number()) -> number()).

%% etude 4.2
gcd(M, N) ->
    if
	M == N -> M;
        M > N -> gcd(M-N, N);
        true -> gcd(M, N-M)
    end.
