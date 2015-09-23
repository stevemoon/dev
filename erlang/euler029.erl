%%% Distinct powers
%%% Problem 29

%%% Consider all integer combinations of ab for 2 �� a �� 5 and 2 �� b �� 5:

%%%     22=4, 23=8, 24=16, 25=32
%%%     32=9, 33=27, 34=81, 35=243
%%%     42=16, 43=64, 44=256, 45=1024
%%%     52=25, 53=125, 54=625, 55=3125

%%% If they are then placed in numerical order, with any repeats removed, we get the following sequence of 15 distinct terms:

%%% 4, 8, 9, 16, 25, 27, 32, 64, 81, 125, 243, 256, 625, 1024, 3125

%%% How many distinct terms are in the sequence generated by ab for 2 �� a �� 100 and 2 �� b �� 100?
%% euler029:go(2,100).
%% 9183
%% Answer is 9183

-module(euler029).
-export([go/2]).

go(Low, High) ->
    Pairs = [{A, B} || A <- lists:seq(Low, High), B <- lists:seq(Low, High)],
    Powers = [math:pow(A, B) || {A, B} <- Pairs],
    UniquePowers = lists:usort(Powers),
    length(UniquePowers).
    


