%%% Prime permutations
%%% Problem 49
%%% The arithmetic sequence, 1487, 4817, 8147, in which each of the terms increases by 3330, 
%%% is unusual in two ways: (i) each of the three terms are prime, and, (ii) each of the 
%%% 4-digit numbers are permutations of one another.
%%%
%%% There are no arithmetic sequences made up of three 1-, 2-, or 3-digit primes, exhibiting 
%%% this property, but there is one other 4-digit increasing sequence.
%%%
%%% What 12-digit number do you form by concatenating the three terms in this sequence?
%%% euler049:go("4digitprimes.txt").
%%% Found one! [2969,6299,9629] 
%%% Answer is 296962999629
%%%
%%% I downloaded a file of primes to 100,000, deleted anything that wasn't 4-digits -- reading in
%%% the resulting file was simple and avoided any errors in calculating the primes, probably helped
%%% runtime too.

-module(euler049).
-export([go/1]).

go(FileName) ->
    PrimeList = readlines(FileName),
    PrimeSet = sets:from_list(PrimeList),
    PermutedPrimeList = get_permuted_prime_list(PrimeList, PrimeSet, []),
    [ find_differences(X) || X <- PermutedPrimeList ],
    ok.

find_differences([_Z, A, B, C]) -> % hacky, but I tried all 3-element lists with no luck.
    % Then tried 4-element lists ignoring the 1st element and happened to find it...
    case ((C - B) == (B - A)) of
	true ->
	    io:format("Found one! ~p ~n", [[A, B, C]]);
	false ->
	    ok
    end;
find_differences(_) ->
    ok.


get_permuted_prime_list([], _, Accum) ->
    Accum;
get_permuted_prime_list([Head | Rest], PrimeSet, Accum) ->
    X = get_permuted_primes(Head, PrimeSet),
    get_permuted_prime_list(Rest, PrimeSet, [X | Accum]).


get_permuted_primes(Candidate, PrimeSet) ->
    X = integer_to_list(Candidate),
    Y = permutations(X),
    Z = gpp(Y, PrimeSet, []),
    A = lists:flatten(Z),
    lists:usort(A).
gpp([], _, Accum) ->
    Accum;
gpp([Test | Rest], PrimeSet, Accum) ->
    Temp = list_to_integer(Test),
    case sets:is_element(Temp, PrimeSet) of
	true ->  gpp(Rest, PrimeSet, [Temp | Accum]);
	false -> gpp(Rest, PrimeSet, Accum)
    end.
    
%Lifted from erlang documentation...
permutations([]) ->
    [[]];
permutations(X) ->
    [[H|T] || H <- X,
	       T <- permutations(X --[H])].



readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    get_all_lines(Device, []).
get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), lists:reverse(Accum);
        Line ->
            SLine = string:strip(Line, right, $\n),
	    ILine = list_to_integer(SLine),
            get_all_lines(Device, [ILine | Accum])
    end.

