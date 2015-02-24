-module(euler054).
-export([go/1]).

% {numeric value, suit}
% T = 10, J = 11, Q = 12, K = 13, A = 14

% Hand Scoring:
% Idea: convert better hands to a score that would surpass any lower
%       hand but allows comparison of the same hands
% High Card:        1 * High card 
% 1-Pair            10 * sum of pair
% 2-Pair            100 * sum of pairs
% 3-of-a-kind       1,000 * sum of three cards
% Straight          10,000 * high card
% Flush             100,000 * high card
% Full house        1,000,000 * sum of all cards
% 4-of-a-kind       10,000,000 * sum of all cards
% Straight flush    100,000,000 * high card
% Royal flush       10,000,000,000 

go(FileName) ->
    GameData = readlines(FileName),
%    print_line(FileData),
    %process_hand(hd(GameData)).
    %extract_hands(GameData).
    %hd(GameData),
    process_hand(hd(GameData)).

process_hand({P1Hand, _P2Hand}) ->
    P1Score = score_hand(P1Hand),
    P1Score.

score_hand(Cards) ->
    % Strategy: Create a list pushing the result of each possible score
    %           Return the list. This will result in duplication of effort
    {ValCards, _} = lists:unzip(Cards),
    SortedCards = lists:sort(ValCards),
    Is_Flush = find_flush(Cards),
    Is_Straight = find_straight(SortedCards),
    Is_4kind = find_4kind(SortedCards),
    Is_3kind = find_3kind(SortedCards),
    Is_3kind.
    %Is-full-house == 3 kind + pair true
    % 2 pair == pair true + that pair subtracted and pair there
    % High card is tl(SortedCards).

find_3kind(SortedCards) ->
    % 3-kind could be 3 patterns: 22233, 22333, 23334
    % 1st 2 detected as in 4-kind, last just look at the last 4 cards with
    % same function...
    Result = find_3kind2(SortedCards),
    case Result of
        {true, _, _} -> Result;
        {false, _, _} -> find_3kind2(tl(SortedCards))
    end.

find_3kind2(SortedCards) ->
    First = hd(SortedCards),
    Third = lists:nth(3, SortedCards),
    Last = hd(lists:reverse(SortedCards)),
    case(First =:= Third) or (Third =:= Last) of
        true -> {true, three_kind, Third};
        _ ->    {false, not_three_kind, 0}
    end.

find_4kind(SortedCards) ->
    First = hd(SortedCards),
    Second = lists:nth(2, SortedCards),
    Last = hd(lists:reverse(SortedCards)),
    case(First =:= Second) or (Second =:= Last) of
        true -> {true, four_kind, Second};
        _ ->    {false, not_four_kind, 0}
    end.

find_straight([Current, Next | Rest]) when (Next - Current) =:= 1 ->
    find_straight([Next] ++ Rest);
find_straight([Current, Next | _]) when (Next - Current) =/= 1 ->
    {false, not_a_straight};
find_straight(Last) when length(Last) =:= 1 ->
    case Last of
        [14] -> {true, royal_straight};
        _  -> {true, standard_straight}
    end.

find_flush(Cards) ->
    {_, Suit} = hd(Cards),
    SameSuit = [X || {X, XSuit} <- Cards, XSuit == Suit],
    length(SameSuit) == 5.

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
