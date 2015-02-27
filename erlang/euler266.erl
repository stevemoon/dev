-module(euler266).
-export([go/0, sum_digits/1]).

go() ->
	%Primes=[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,
	%		73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,
	%		151,157,163,167,173,179,181],
	%ProductPrimes = lists:foldl(fun(X, Prod) -> X * Prod end, 1, Primes),
	ProductPrimes = 5397346292805549782720214077673687806275517530364350655459511599582614290,
	%% Digits sum to 336 -- number is divisible by 3
	%% Divisor will have digits that sum to a number divisible by 3 as well

	% ProductPrimes = 3102,
	% MaxVal = isqrt4(ProductPrimes),
	MaxVal = 2323218950681478446587180516177954548,
	DoneSoFar = 2136 * 100000 + 178 * 1000000 + 4988 * 10000000,
	Restart = MaxVal - DoneSoFar,
	%Restart.
	%ProductPrimes rem MaxVal.
	%find_divisor(ProductPrimes, MaxVal).
	%sum_digits(ProductPrimes).
	find_divisors(ProductPrimes, Restart, 0).

find_divisors(ProductPrimes, Value, Count) ->
	case Count of
		10000000 -> NewCount = 0,
				  io:format(".");
	    _ -> NewCount = Count + 1
	end,
	case check_divisor(ProductPrimes, Value) of
		true -> Value;
		_ -> find_divisors(ProductPrimes, Value - 3, NewCount)
	end.
	% case sum_digits(Value) rem 3 of 
	% 	0 -> case check_divisor(ProductPrimes, Value) of
	% 			true -> Value;
	% 			_ -> find_divisors(ProductPrimes, Value - 1, NewCount)
	% 		end;
	% 	_ -> find_divisors(ProductPrimes, Value - 1, NewCount)
	% end.

check_divisor(ProductPrimes, Value) ->
	%io:format("+"),
	case ProductPrimes rem Value of 
		0 -> true;
		_ -> false
	end.


%Lifted from http://stackoverflow.com/questions/21657491/an-efficient-algorithm
					%-to-calculate-the-integer-square-root-isqrt-of-arbitrari
% isqrt4(0) -> 0;
% isqrt4(N) when erlang:is_integer(N), N >= 0 ->
%     isqrt4(N, N).
% isqrt4(N, Xk) ->
%     Xk1 = (Xk + N div Xk) div 2,
%     if  Xk1 >= Xk -> Xk;
%         Xk1 < Xk -> isqrt4(N, Xk1)
%     end.

%Lifted from http://rosettacode.org/wiki/Sum_digits_of_an_integer#Erlang
sum_digits(N) ->
    sum_digits(N,10).
 
sum_digits(N,B) ->
    sum_digits(N,B,0).
 
sum_digits(0,_,Acc) ->
    Acc;
sum_digits(N,B,Acc) when N < B ->
    Acc+N;
sum_digits(N,B,Acc) ->
    sum_digits(N div B, B, Acc + (N rem B)).