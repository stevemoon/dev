-module(euler120).
-export([go/2, rmax/1]).
%% Let r be the remainder when (a−1)^n + (a+1)^n is divided by a^2.
%%
%% For example, if a = 7 and n = 3, then r = 42: 6^3 + 8^3 = 728 ≡ 42 mod 49. 
%% And as n varies, so too will r, but for a = 7 it turns out that rmax = 42.
%%
%% For 3 ≤ a ≤ 1000, find ∑ rmax.
%%
%% I found a pattern:
%% When A is Odd, rmax = A^2 - A
%% When A is Even, rmax = A^2 - 2 * A
%%
%% Solved: euler120:go(3, 1000).
%% 333082500

go(Start, Max) ->
    sumRMax(Start, Max, 0).

sumRMax(A, Max, Sum) when A > Max ->
    Sum;
sumRMax(A, Max, Sum ) ->
    case (A rem 2) =:= 0 of
	true -> RMax = (A * A) - (A * 2);
	false -> RMax = (A * A) - A
    end,
    sumRMax(A + 1, Max, Sum + RMax).
	    
rmax(A) ->
    rmax(A, 1, 0, 0).
rmax(_, N, MaxR, MaxRN) when N > 1000 ->
    {MaxR, MaxRN};
rmax(A, N, MaxR, MaxRN) ->
    R = (eullib:power(A - 1, N) + eullib:power(A + 1, N)) rem (A * A),
    case R > MaxR of
	true -> rmax(A, N + 1, R, N);
	false -> rmax(A, N + 1, MaxR, MaxRN)
    end.
	    

    
