-module(euler015).
-export([go/2]).

% Lattice paths
% Problem 15
% Starting in the top left corner of a 2x2 grid, and only being able to
%  move to the right and down, there are exactly 6 routes to the bottom right corner.
% How many such routes are there through a 20x20 grid?
%
% Brute force solution (solve function) works fine for small numbers, but runtime to solve is probably close to 3 hours.
% Working from smaller numbers the pattern 2,2 -> 6, 3,3 -> 20, 4,4 -> 70, etc. shows the formula is:
% (2n)! / (n!)^2 (Thanks Wolfram Alpha!)
% This is implemented in the "calculate" function.
%
% Answer is: euler015:go(20,20).
% 137846528820.0

go(Right,Down) ->
%    solve(Right,Down).
    calculate(Right,Down).

calculate(Right,Down) when Right == Down ->
    factorial(2 * Right) / math:pow(factorial(Right),2);
calculate(_, _) ->
    error.

factorial(Num) when Num > 0 ->
    Num * factorial(Num - 1);
factorial(0) ->
    1.

solve(0,0) ->
    1;
solve(Right,0) ->
    solve(Right - 1, 0);
solve(0, Down) ->
    solve(0, Down - 1);
solve(Right, Down) ->
    solve(Right - 1, Down) + solve(Right, Down - 1).


