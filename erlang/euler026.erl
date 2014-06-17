-module(euler026).
-export([go/2,divide/3,detect_single_repeat/2,cycle/2]).

go(Max,Precision) ->
    A = divide(1, Max, Precision),
    io:format("~s~n", [A]),
    B = detect_single_repeat(A, length(A)),
    io:format("~w~n", [B]),
    cycle(A, Precision).

cycle(X, Precision) ->
    cycle(X, 1, Precision, []).
cycle(X, Current, Size, Accum) when (Current < (1 + (Size div 2))) ->
    Y = lists:sublist(X, 1, Current),    
    Z = lists:sublist(X, length(Y) + 1, length(Y)),
    %io:format("~w~n~w~n", [Y, Z]),
    case (Y =:= Z) of
	true -> 
	    %cycle(X, Current + 1, Size, Accum ++ [{Current, Y, Z}]);
	    {Current, Y};
	false ->
	    cycle(X, Current + 1, Size, Accum)
    end;
cycle(_, Current, Size, Accum) when Current =:= ((Size div 2) + 1) ->
    Accum.




%Found C++ divide algorithm I've ported poorly from here:
%http://www.thecrazyprogrammer.com/2013/10/cpp-high-precision-division-program.html
divide(A, B, Precision) when ((A > 0) and (B > 0) and (Precision > 0)) ->
    X = divide(A * 10, B, A div B, Precision, []),
    Y = trim(X),
    integer_to_list(Y);
divide(A, B, Precision) when ((A =< 0) or (B =< 0) or (Precision =< 0)) ->
    {error}.

divide(A, B, C, Precision, _) when Precision > 0 ->
    divide(A * 10, B, A div B, Precision - 1, [C]);
divide(_, _, _, Precision, Accum) when Precision =:= 0 ->
    Accum.

    
detect_single_repeat(X, Count) ->
    Z = X, %integer_to_list(X),
    Y = lists:reverse(Z),
    detect_single_repeat2(Y, Count).

detect_single_repeat2([X , Y | Z], Count) when X =:= Y ->	    
    detect_single_repeat2(Z, Count - 2);
detect_single_repeat2(_, Count) when Count < 3 ->
    true;
detect_single_repeat2([X , Y | _], _) when X =/= Y ->
    false.


trim(X) ->
    W = hd(X),
    Y = integer_to_list(W),
    Z = lists:reverse(Y),
    A = list_to_integer(Z), %dispose of trailing (leading) zeros
    B = integer_to_list(A), %convert back to string for reverse
    C = lists:reverse(B),
    list_to_integer(C).
