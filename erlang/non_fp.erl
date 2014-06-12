-module(non_fp).
-export([generate_teeth/2,test_teeth/0]).
-spec(generate_teeth(string(), float()) -> list(list(integer()))).

%% Since I had a long break from last time I worked an etude I just typed this one in from the
%% solution. Very interesting how the head | tail construct is worked into the recursive 
%% function definition.

generate_teeth(TeethPresent, ProbGood) ->
    random:seed(now()),
    generate_teeth(TeethPresent, ProbGood, []).

-spec(generate_teeth(string(), float(), [[integer()]]) -> [[integer()]]).

generate_teeth([], _Prob, Result) ->
    lists:reverse(Result);
generate_teeth([$F | Tail], ProbGood, Result) ->
    generate_teeth(Tail, ProbGood, [[0] | Result]);
generate_teeth([$T | Tail], ProbGood, Result) ->
    generate_teeth(Tail, ProbGood, [generate_tooth(ProbGood) | Result]).

-spec(generate_tooth(float()) -> list(integer())).

generate_tooth(ProbGood) ->
    Good = random:uniform() < ProbGood,
    case Good of
	true ->
	    BaseDepth = 2;
	false ->
	    BaseDepth = 3
	end,
    generate_tooth(BaseDepth, 6, []).

generate_tooth(_Base, 0, Result) ->
    Result;
generate_tooth(Base, N, Result) ->
    [Base + random:uniform(3) - 2 | generate_tooth(Base, N - 1, Result)].

test_teeth() ->
    TList = "FTTTTTTTTTTTTTTFTTTTTTTTTTTTTTTT",
    N = generate_teeth(TList, 0.05),
    print_tooth(N).

print_tooth([]) ->
    io:format("Finished.~n");
print_tooth([H|T]) ->
    io:format("~p~n", [H]),
    print_tooth(T).




								


