-module(euler026).
-export([go/1,divide/3]).

go(Max) ->
    Max.

cycle(X) ->
    cycle(integer_to_list(X), []).
cycle(X, Accum) ->
    1.

trim(X) ->
    Y = lists:reverse(X),
    Z = list_to_integer(Y),
    lists:reverse(Z).
	    
%Found C++ divide algorithm I've ported poorly from here:
%http://www.thecrazyprogrammer.com/2013/10/cpp-high-precision-division-program.html
divide(A, B, Precision) when ((A > 0) and (B > 0) and (Precision > 0)) ->
    X = divide(A * 10, B, A div B, Precision, []),
    trim(X);
divide(A, B, Precision) when ((A =< 0) or (B =< 0) or (Precision =< 0)) ->
    {error}.

divide(A, B, C, Precision, _) when Precision > 0 ->
    divide(A * 10, B, A div B, Precision - 1, [C]);
divide(_, _, _, Precision, Accum) when Precision =:= 0 ->
    Accum.

    
