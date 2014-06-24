-module(euler028).
-export([go/1]).



%% Starting with the number 1 and moving to the right in a clockwise direction a 5 by 5 spiral is formed as follows:

%% 21 22 23 24 25
%% 20  7  8  9 10
%% 19  6  1  2 11
%% 18  5  4  3 12
%% 17 16 15 14 13

%% It can be verified that the sum of the numbers on the diagonals is 101.

%% What is the sum of the numbers on the diagonals in a 1001 by 1001 spiral formed in the same way?

%% See excel sheet for some experimentation. I found the diagonal from 1 -> 9 -> 25 was the squares of the odd
%% numbers and the other diagonals were just offsets from that.
%% For the 1001 x 1001 square we'd need the first 500 odd numbers (symetrical top and bottom == 1000, plus the initial "1" so 1001).
%% answer is 
%% euler028:go(500).
%% 669171001



go(X) ->
    N = firstXodd(X),
    diags(N) + 1.


diags(N) ->
    diags(N, 0).
diags([N | Rest], Accum) ->
    A = N * N,
    B = (N * N) - (N - 1),
    C = B - (N - 1),
    D = C - (N - 1),
    diags(Rest, Accum + (A + B + C + D));
diags([], Accum) ->
    Accum.



firstXodd(X) ->
    firstXodd(1, X, []).
firstXodd(A, X, Accum) when (length(Accum) < X) ->
    firstXodd(A + 2, X, Accum ++ [(A + 2)]);
firstXodd(_, X, Accum) when (length(Accum) =:= X) ->
    Accum.
