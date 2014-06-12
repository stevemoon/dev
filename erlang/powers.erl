%%%-------------------------------------------------------------------
%%% @author  <moonsr@MOONS1>
%%% @copyright (C) 2013, 
%%% @doc
%%%
%%% @end
%%% Created :  8 Oct 2013 by  <moonsr@MOONS1>
%%%-------------------------------------------------------------------
-module(powers).
-export([raise/2,nth_root/2]).


%% Etude 4.3
raise(_, 0) -> 1;
raise(X, 1) -> X;
raise(X, N) when N > 0 -> raise(X, N, 1);
raise(X, N) when N =< 0 -> 1.0 / raise(X, -N). 

%% Etude 4.4
raise (X, N, ACC) when N == 0 -> ACC;
raise (X, N, ACC) -> raise (X, N - 1, X * ACC). 
    
%% Etude 4.5
nth_root(X, N) -> 
    A = X / 2.0,
    nth_root(X, N, A).

nth_root(X, N, A) ->
    io:format("Current guess is ~p~n", [A]),
    F = raise(A, N) - X,
    Fprime = N * raise(A, N - 1),
    Next = A - F / Fprime,
    Change = abs(Next - A),
    if
	Change < 1.0e-8 ->
	    Next;
	true -> nth_root(X, N, Next)
    end.
