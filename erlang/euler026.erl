-module(euler026).
-export([go/2,divide/3,detect_single_repeat/2,cycle/2]).

% euler026:go(1000,10000).
% {983,982} == 983 has a 982 digit cycle. Whoo!

go(Max,Precision) ->
    A = find(Max, Precision, []),
    interpret(A, 0, 0).

interpret([A | B], Max, MaxCount) ->
    {Num, List} = A,
    Count = length(List),
    case Count > MaxCount of
	true ->  interpret(B, Num, Count);
	false -> interpret(B, Max, MaxCount)
    end;
interpret([], Max, MaxCount) -> 
    {Max, MaxCount}.

find(Cur, Precision, Accum) when Cur > 1 ->
    A = divide(1, Cur, Precision),
    B = cycle(A, length(A)),
    C = {Cur, B},
    find(Cur - 1, Precision, Accum ++ [C]);
find(1, _, Accum) ->
    Accum.

% cycle returns the longest repeating pattern as a list
cycle(List, Length) ->
    cycle(List, 1, Length).
cycle(List, Current, Size) when (Current < (1 + (Size div 2))) ->
    Y = lists:sublist(List, 1, Current),    
    Z = lists:sublist(List, length(Y) + 1, length(Y)),
    %io:format("~w~n~w~n", [Y, Z]),
    case (Y =:= Z) of
	true -> 
	    Y;
	false ->
	    cycle(List, Current + 1, Size)
    end;
cycle(_, Current, Size) when (Current >= (1 + (Size div 2))) ->
    [].

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
