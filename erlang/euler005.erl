-module(euler005).
-export([all20/1,go/0]).

%% Presumably anything that 20 divides into will also work for factors 
%% of 20 (10, 5, 2).
%% Likewise with 19, etc. This eliminates 1-10, so multiplying 20*19*18...*11
%% yields a large number. Dividing this number by 20, 19, ... etc. yields
%% a smaller number. Eventually I got down to the Seed. Just to be sure
%% this is the smallest, I check every number down to the minimum given in
%% the problem for 1-10.
go() ->
    Seed = 232792560,
    trial(Seed, []).

trial(2520, Works) -> Works;		       
trial(X, Works) ->
    case all20(X) of
	true ->  trial(X - 1, Works ++ [X]);
	false -> trial (X - 1, Works)
    end.
		 
    
all20(X) ->
    Sequence = lists:seq(2, 20),
    Rems = [X rem Y || Y <- Sequence],
    lists:foldl(fun(Y, Sum) -> Y + Sum end, 0, Rems) =:= 0.
