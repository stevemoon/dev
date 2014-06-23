-module(euler017).
-export([spell_out/1]).

%% If the numbers 1 to 5 are written out in words: one, two, three, four, five, 
%% then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.

%% If all the numbers from 1 to 1000 (one thousand) inclusive were written out 
%% in words, how many letters would be used?

%% NOTE: Do not count spaces or hyphens. For example, 342 (three hundred and 
%% forty-two) contains 23 letters and 115 (one hundred and fifteen) contains 20 
%% letters. The use of "and" when writing out numbers is in compliance with 
%% British usage.

%% Note: full list of rules here: http://en.wikipedia.org/wiki/English_numerals
%% Solved! Answer is 21124

spell_out(X) ->
    A = [so(B, []) || B <- lists:seq(1, X)],
    C = lists:flatten(A),
    io:format("~w~n", [C]),
    length(C).
    %so(X, []).

so(1, A) -> A ++ "one";
so(2, A) -> A ++ "two";
so(3, A) -> A ++ "three";
so(4, A) -> A ++ "four";
so(5, A) -> A ++ "five";
so(6, A) -> A ++ "six";
so(7, A) -> A ++ "seven";
so(8, A) -> A ++ "eight";
so(9, A) -> A ++ "nine";
so(10, A) -> A ++ "ten";
so(11, A) -> A ++ "eleven";
so(12, A) -> A ++ "twelve";
so(13, A) -> A ++ "thirteen";
so(14, A) -> A ++ "fourteen";
so(15, A) -> A ++ "fifteen";
so(16, A) -> A ++ "sixteen";
so(17, A) -> A ++ "seventeen";
so(18, A) -> A ++ "eighteen";
so(19, A) -> A ++ "nineteen";
so(20, A) -> A ++ "twenty";
so(30, A) -> A ++ "thirty";
so(40, A) -> A ++ "forty";
so(50, A) -> A ++ "fifty";
so(60, A) -> A ++ "sixty";
so(70, A) -> A ++ "seventy";
so(80, A) -> A ++ "eighty";
so(90, A) -> A ++ "ninety";
so(X, A) when X < 100 ->
    Y = so((X div 10) * 10, []),
    Z = so(X rem 10, []),
    A ++ Y ++ Z;
    %%A ++ Y ++ "-" ++ Z;
so(X, A) when (( X >= 100) and (X < 1000) and ((X rem 100) =:= 0)) ->
    Y = so(X div 100, []),
    A ++ Y ++ "hundred";
    %%A ++ Y ++ " hundred";
so(X, A) when (( X >= 100) and (X < 1000) and ((X rem 100) =/= 0)) ->
    Y = so((X div 100), []),
    Z = so(X rem 100, []),
    A ++ Y ++ "hundredand" ++ Z;
    %A ++ Y ++ " hundred and " ++ Z;
so(0, A) -> A;
so(1000, A) -> A ++ "onethousand";
%so(1000, A) -> A ++ "one thousand";
so(_, A) -> A ++ " OOPS!".
    






    
