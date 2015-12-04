-module('adv_one').
-export([go/1]).

%Answer is 376 

% {numeric value, suit}
% T = 10, J = 11, Q = 12, K = 13, A = 14

% Hand Scoring:
% Idea: convert better hands to a score that would surpass any lower
%       hand but allows comparison of the same hands
% High Card:            1 * High card 
%  1-Pair              10 * sum of pair 
%  2-Pair              100 * sum of pairs 
%  3-of-a-kind         1,000 * sum of three cards
%  Straight            10,000 * high card
%  Flush               100,000 * high card
%  Full house          1,000,000 * sum of all cards
%  4-of-a-kind         10,000,000 * sum of all cards
%  Straight flush      1,000,000,000 * high card
%  Royal flush         100,000,000,000 

go(FileName) ->
    GameData = readlines(FileName),
    {P1Score, P2Score, Ties} = process_lines(GameData, 0, 0, 0),
    io:format("~w", [[P1Score, P2Score, Ties]]).

process_lines([{P1Hand, P2Hand} | Tail], P1Score, P2Score, Ties) ->
    Winner = process_hand({P1Hand, P2Hand}),
    case Winner of 
            player_one -> process_lines(Tail, P1Score + 1, P2Score, Ties);
            player_two -> process_lines(Tail, P1Score, P2Score + 1, Ties);
            tie -> process_lines(Tail, P1Score, P2Score, Ties + 1);
            _ -> error
    end;
process_lines([], P1Score, P2Score, Ties) ->
    {P1Score, P2Score, Ties}.

process_hand({P1Hand, P2Hand}) ->
    P1Score = score_hand(P1Hand),
    P2Score = score_hand(P2Hand),
    Result = if (P1Score > P2Score) -> player_one;
                (P2Score > P1Score) -> player_two;
                (P1Score =:= P2Score) -> 
                                P1Sorted = lists:reverse(sort_cards(P1Hand)),
                                P2Sorted = lists:reverse(sort_cards(P2Hand)),
                                resolve_tie(P1Sorted, P2Sorted);
                true -> error
            end,
    Result.

resolve_tie([P1Max | _P1Tail], [P2Max | _P2Tail]) when P1Max > P2Max ->
    player_one;
resolve_tie([P1Max | _P1Tail], [P2Max | _P2Tail]) when P1Max < P2Max ->
    player_two;
resolve_tie([P1Max | P1Tail], [P2Max | P2Tail]) when P1Max =:= P2Max ->
    resolve_tie(P1Tail, P2Tail);
resolve_tie([],[]) ->
    tie.


sort_cards(Cards) ->
    {ValCards, _} = lists:unzip(Cards),
    lists:sort(ValCards).

score_hand(Cards) ->
    SortedCards = sort_cards(Cards), %strips out suit
    High_Card = hd(lists:reverse(SortedCards)),
    One_pair = find_pair(SortedCards),
    Two_pair = find_2pair(SortedCards),
    Three_kind = find_3kind(SortedCards),
    Straight = find_straight(SortedCards),
    Flush = find_flush(Cards),
    Full_House = find_full_house(SortedCards),
    Four_kind = find_4kind(SortedCards),
    Straight_Flush = find_straight_flush(Flush, Straight),
    Royal_Flush = find_royal_flush(High_Card, Straight_Flush),
    ScoreList = [High_Card, One_pair, Two_pair, Three_kind, Straight, Flush,
                 Full_House, Four_kind, Straight_Flush, Royal_Flush],
    HighScore = hd(lists:reverse(lists:sort(ScoreList))),
    HighScore.
    
find_pair([First, Second, Third, Fourth, Fifth]) ->
    %22345, 23345, 23445, 23455
    Result = if (First =:= Second) or (Second =:= Third) -> Second * 2 * 10;
                (Third =:= Fourth) or (Fourth =:= Fifth) -> Fourth * 2 * 10;
                true -> 0
            end,
    Result.

find_2pair([First, Second, Third, Fourth, Fifth]) ->
    %22334, 23344,22344
    Result = if (First =:= Second) and (Third =:= Fourth) -> (Second + Fourth) * 2 * 100;
                (Second =:= Third) and (Fourth =:= Fifth) -> (Second + Fourth) * 2 * 100;
                (First =:= Second) and (Fourth =:= Fifth) -> (Second + Fourth) * 2 * 100;
                true -> 0
            end,
    Result.

find_3kind([First, Second, Third, Fourth, Fifth]) ->
    % 3-kind could be 3 patterns: 22233, 22333, 23334
    Result = if (First =:= Second) and (Second =:= Third) -> Second * 3 * 1000;
                (Second =:= Third) and (Third =:= Fourth) -> Second * 3 * 1000;
                (Third =:= Fourth) and (Fourth =:= Fifth) -> Fourth * 3 * 1000;
                true -> 0
            end,
    Result.

find_straight([Current, Next | Rest]) when (Next - Current) =:= 1 ->
    find_straight([Next] ++ Rest);
find_straight([Current, Next | _]) when (Next - Current) =/= 1 ->
    0;
find_straight(Last) when length(Last) =:= 1 ->
    hd(Last) * 10000.
    

find_flush(Cards) ->
    {_, Suit} = hd(Cards),
    SameSuit = [X || {X, XSuit} <- Cards, XSuit == Suit],
    case length(SameSuit) == 5 of 
        true -> 
            hd(lists:reverse(sort_cards(Cards))) * 100000;
        false -> 0
    end.

find_full_house([First, Second, Third, Fourth, Fifth]) ->
    %22333, 22233
    Result = if (First =:= Second) and (Third =:= Fifth) -> (First * 2 + Third * 3) * 1000000;
                (First =:= Third) and (Fourth =:= Fifth) -> (First * 3 + Fourth * 2) * 1000000;
                true -> 0
            end,
    Result.

find_4kind([First, Second, _Third, Fourth, Fifth]) ->
    Result = if (First =:= Fourth) -> Fourth * 4 * 10000000;
                (Second =:= Fifth) -> Fourth * 4 * 10000000;
                true -> 0
            end,
    Result.

    
find_straight_flush(Is_Flush, Is_Straight) ->
    Result = if (Is_Flush > 0) and (Is_Straight > 0) -> Is_Straight / 10000 * 1000000000;
                true -> 0
            end,
    Result.

find_royal_flush(High_Card, Is_Straight_Flush) when (Is_Straight_Flush  > 0) and (High_Card =:= 14) ->
    io:format("~s ~n", ["Royal Flush!"]),
    100000000000;
find_royal_flush(_, _) ->
    0.
readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    lists:reverse(get_all_lines(Device, [])).
 
get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), Accum;
        Line ->
            SLine = string:strip(Line, right, $\n),
            {P1Hand, P2Hand} = extract_hands(SLine), 
            P1_decoded_hand = decode_cards(P1Hand, []),
            P2_decoded_hand = decode_cards(P2Hand, []),
            get_all_lines(Device, [{P1_decoded_hand, P2_decoded_hand}|Accum])
    end.

extract_hands(Hands) ->
    BothHands = string:tokens(Hands, " "),
    Player1Hand = lists:reverse(lists:nthtail(5, lists:reverse(BothHands))),
    Player2Hand = lists:nthtail(5, BothHands),
    {Player1Hand, Player2Hand}.

decode_cards([Head | Tail], Accum) ->
    Card_Val = get_value(Head),
    Card_Suit = get_suit(Head),
    decode_cards(Tail, Accum ++ [{Card_Val, Card_Suit}]);
decode_cards([], Accum) ->
    Accum.  

get_value(Card) ->
    Digit = string:left(Card,1),
    {Result, _Rest} = string:to_integer(Digit),
    case Result of
        error ->
            case Digit of
                "T" -> 10;
                "J" -> 11;
                "Q" -> 12;
                "K" -> 13;
                "A" -> 14;
                _ -> error
                end;
        _ -> Result
    end.

get_suit(Card) ->
    Char = string:right(Card,1),
   %Char.
    case Char of
        "D" -> diamands;
        "C" -> clubs;
        "H" -> hearts;
        "S" -> spades
    end.
