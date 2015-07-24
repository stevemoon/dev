-module(euler506).
-export([go/1, get_next_seq/4, digit_list_to_integer/2]).

%% Consider the infinite repeating sequence of digits:
%% 1234321234321234321...
%% Amazingly, you can break this sequence of digits into a sequence of integers such that the sum of the digits in the n'th value is n.
%% The sequence goes as follows:
%% 1, 2, 3, 4, 32, 123, 43, 2123, 432, 1234, 32123, ...
%% Let vn be the n'th value in this sequence. For example, v2 = 2, v5 = 32 and v11 = 32123.
%% Let S(n) be v1 + v2 + ... + vn. For example, S(11) = 36120, and S(1000) mod 123454321 = 18232686.
%% Find S(10^14) mod 123454321.


















% First (failed) attempt below:
%
% ----- What I've found ----
% The number of digits from the sequence used to make the next number changes in a fixed pattern of 15 steps:
% +1, 0, 0, 0, +1, +1, -1, +2, -1, +1, +1, 0, 0, 0, +1
%
% Strategy:
% v(n) is the list of integers of x length following v(n-1). 
% So v(27) is a list of 11 digits (3,2,1,2,3,4,3,2,1,2,3), and is the second position in the sequnce described above:
% v(28) is therefore 11 digits + 0 digits == 11 digits, so we take 11 digits from the cycle starting at 4 (3,4,3,2,1,2,3,4,3,2,1)
% v(22) is 8 digits long, but the sequence increases by 2 for v(23), so v(23 would be 8 digits + 2 digits == 10 digits, again starting at 4.
%
%
% Issues:
% The above can be done in tail-recursive fashion, so RAM usage should be minimal.
% Generating the list of digits and then converting to an integer is probably going to be inefficient.
% If the start digit is 1, the next will always be 2. Likewise with 4 the next will always be 3. 
% if the start digits is 2 or 3, it is indeterminate if the sequence is going up or down.

% Brute force approach:
% Started 12:07pm 7/10/2015
% Abandonded 11:35am 7/13/2015
% During this time, according to observer, "get_next_seq" had done 949 billion reductions. Presuming that is 1 recurse per reduction it was 
% more than 2 orders of magnitude away from the final number, and of course each number requires many calls to get_next_seq. So after 3 days
% we're less than 0.1% of the way through the problem.
% Note to self: For suspected long-running-processes, add in debug and process table data to make progress-tracking in observer easier.
%
% Brute force of this problem is not realistic.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Brute Force Approach Code %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -export([go/1, get_next_seq/4, digit_list_to_integer/2]).
%% go(Num) ->
%%     DigitCycle = [1, 0, 0, 0, 1, 1, -1, 2, -1, 1, 1, 0, 0, 0, 1],
%%     s(Num, 1, 2, 3, 0, DigitCycle, 0) rem 123454321.


%% s(EndNum, CurNum, _, _, _, _, Accum) when CurNum > EndNum ->
%%     Accum;
%% s(EndNum, CurNum, PrevLast, Prev2ndLast, LastDigitCount, [Increment | RestOfDigitCycle], Accum) ->
%%     {DigitList, NewLast, New2ndLast} = get_next_seq(LastDigitCount + Increment, PrevLast, Prev2ndLast, []),
%%     NewAccum = Accum + digit_list_to_integer(DigitList, 0),
%%     s(EndNum, CurNum + 1, NewLast, New2ndLast, LastDigitCount + Increment, RestOfDigitCycle ++ [Increment], NewAccum).



%% digit_list_to_integer([], Accum) ->
%%     Accum;
%% digit_list_to_integer([Head|Tail], Accum) ->
%%     digit_list_to_integer(Tail, (Accum * 10) + Head).


%% get_next_seq(0, PrevLast, Prev2ndLast, Accum) ->
%%     {Accum, PrevLast, Prev2ndLast}; 
%% get_next_seq(NumDigits, PrevLastDigit, _Prev2ndLastDigit, Accum) when PrevLastDigit =:= 1 ->
%%     NextDigit = 2,
%%     get_next_seq(NumDigits - 1, NextDigit, PrevLastDigit, Accum ++ [NextDigit]);
%% get_next_seq(NumDigits, PrevLastDigit, _Prev2ndLastDigit, Accum) when PrevLastDigit =:= 4 ->
%%     NextDigit = 3,
%%     get_next_seq(NumDigits - 1, NextDigit, PrevLastDigit, Accum ++ [NextDigit]);
%% get_next_seq(NumDigits, PrevLastDigit, Prev2ndLastDigit, Accum) when (PrevLastDigit =:= 2) and (Prev2ndLastDigit =:= 1) -> 
%%     NextDigit = 3,
%%     get_next_seq(NumDigits - 1, NextDigit, PrevLastDigit, Accum ++ [NextDigit]);
%% get_next_seq(NumDigits, PrevLastDigit, Prev2ndLastDigit, Accum) when (PrevLastDigit =:= 2) and (Prev2ndLastDigit =:= 3) -> 
%%     NextDigit = 1,
%%     get_next_seq(NumDigits - 1, NextDigit, PrevLastDigit, Accum ++ [NextDigit]);
%% get_next_seq(NumDigits, PrevLastDigit, Prev2ndLastDigit, Accum) when (PrevLastDigit =:= 3) and (Prev2ndLastDigit =:= 4) -> 
%%     NextDigit = 2,
%%     get_next_seq(NumDigits - 1, NextDigit, PrevLastDigit, Accum ++ [NextDigit]);
%% get_next_seq(NumDigits, PrevLastDigit, Prev2ndLastDigit, Accum) when (PrevLastDigit =:= 3) and (Prev2ndLastDigit =:= 2) -> 
%%     NextDigit = 4,
%%     get_next_seq(NumDigits - 1, NextDigit, PrevLastDigit, Accum ++ [NextDigit]).

