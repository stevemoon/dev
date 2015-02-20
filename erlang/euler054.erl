-module(euler054).
-export([go/1]).

% {numeric value, suit}
% T = 10, J = 11, Q = 12, K = 13, A = 14

go(FileName) ->
    GameData = readlines(FileName),
%    print_line(FileData),
    get_score(GameData).
    %extract_hands(GameData).

get_score([Head|_GameData]) ->
    score_round(Head).
%    get_score(_GameData).

score_round(Hands) ->
    extract_hands(Hands).

extract_hands(Hands) ->
    BothHands = string:tokens(Hands, " "),
    Player1Hand = lists:reverse(lists:nthtail(5, lists:reverse(BothHands))),
    Player2Hand = lists:nthtail(5, BothHands),
    {Player1Hand, Player2Hand}.

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    lists:reverse(get_all_lines(Device, [])).
 
get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), Accum;
        Line -> get_all_lines(Device, [string:strip(Line, right, $\n)|Accum])
    end.

%print_line([Head|_Tail]) ->
%    io:format("~s", [Head]).
