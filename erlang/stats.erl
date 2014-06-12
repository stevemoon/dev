-module(stats).
-export([minimum/1,maximum/1,range/1,mean/1,stdv/1]).

minimum(X) ->
    [Head | Tail] = X,
    minimum(Tail, Head).

minimum([], Min) -> Min;
minimum(List, Min) ->
    [Head | Tail] = List,
    if 
	Head < Min ->
	    minimum(Tail, Head);
        true -> minimum(Tail, Min)
    end.	
       
   
maximum(X) ->
    [Head | Tail] = X,
    maximum(Tail, Head).

maximum([], Max) -> Max;
maximum(List, Max) ->
    [Head | Tail] = List,
    if 
	Head > Max ->
	    maximum(Tail, Head);
        true -> maximum(Tail, Max)
    end.	 

range(X) ->
    [minimum(X), maximum(X)].

sum(List) ->
    lists:foldl(fun(X, Sum) -> X + Sum end, 0, List).

square(List) ->
    [X * X || X <- List].

mean(List) ->
    sum(List) / length(List).

stdv(X) ->
    N = length(X),
    Ssq = sum( square(X) ),
    S = sum(X),
    math:sqrt((N * Ssq - S * S) / (N * (N - 1))).
    

    
