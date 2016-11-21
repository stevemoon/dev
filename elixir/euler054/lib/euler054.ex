defmodule Euler054 do
  @chunksize 5
  @cardval %{'1' => 1,  '2' => 2,  '3' => 3,  '4' => 4, '5' => 5,
             '6' => 6,  '7' => 7,  '8' => 8,  '9' => 9, 'T' => 10,
             'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14}
  @cardsuit %{'C' => :clubs, 'D' => :diamands, 'H' => :hearts, 'S' => :spades}
  def score_file(filename \\ './lib/poker.txt') do
    File.stream!(filename)
    |> Stream.chunk(@chunksize, @chunksize, [])
    # |> Enum.each(&IO.inspect(extract_hands(&1) |> IO.inspect))
    |> Enum.each(&IO.inspect(extract_hands(&1) ))
    #|> Enum.each(&IO.inspect(extract_hands(&1) |> decode_hands([])))
    # |> Enum.each(&IO.inspect(extract_hands(&1) |> process_hands))
    #probably replace Enum.each with Enum.map then pipe the resulting list to a reduce

    #Enum.each IO.stream(file, :line), &IO.inspect(extract_hands(&1))
    #    IO.read(file, :line)
#    File.close(file)
    #stream contents
    #parallel map each line:
    # Line |>
    # Score hands |> <-- can be parallelized
    # List of {p1win, p2win, tie} |>
    # reduce list to one tuple with sums <-- could be messages sent to a process instead of building a giant in-memory list
    #
  end

#Answer is 376

# {numeric value, suit}
# T = 10, J = 11, Q = 12, K = 13, A = 14

# Hand Scoring:
# Idea: convert better hands to a score that would surpass any lower
#       hand but allows comparison of the same hands
# High Card:            1 * High card
#  1-Pair              10 * sum of pair
#  2-Pair              100 * sum of pairs
#  3-of-a-kind         1,000 * sum of three cards
#  Straight            10,000 * high card
#  Flush               100,000 * high card
#  Full house          1,000,000 * sum of all cards
#  4-of-a-kind         10,000,000 * sum of all cards
#  Straight flush      1,000,000,000 * high card
#  Royal flush         100,000,000,000
#
#
#go(FileName) ->
#    GameData = readlines(FileName),
#    {P1Score, P2Score, Ties} = process_lines(GameData, 0, 0, 0),
#    io:format("~w", [[P1Score, P2Score, Ties]]).
#
def process_hands(hands, accum \\ {0, 0, 0})
def process_hands([], accum) do
  accum
end
def process_hands([{p1hand, p2hand} | rest], {p1, p2, ties}) do
  winner = process_hand({p1hand, p2hand})
  case winner do
    :p1 -> process_hands(rest, {p1 + 1, p2, ties})
    :p2 -> process_hands(rest, {p1, p2 + 1, ties})
    :tie -> process_hands(rest, {p1, p2, ties + 1})
    _ -> :error
  end
end

def process_hand({p1hand, p2hand}) do
  p1score = score_hand(p1hand)
  p2score = score_hand(p2hand)
  cond do
    p1score > p2score -> :p1
    p2score > p1score -> :p2
    p1score == p2score ->
      p1sorted = sort_cards(p1hand)
      p2sorted = sort_cards(p2hand)
      IO.inspect(p1sorted)
      resolve_tie(p1sorted, p2sorted)
  end
end

def score_hand(_), do: 100

def resolve_tie(_, _) do
  :tie
end
#resolve_tie([P1Max | _P1Tail], [P2Max | _P2Tail]) when P1Max > P2Max ->
#    player_one;
#resolve_tie([P1Max | _P1Tail], [P2Max | _P2Tail]) when P1Max < P2Max ->
#    player_two;
#resolve_tie([P1Max | P1Tail], [P2Max | P2Tail]) when P1Max =:= P2Max ->
#    resolve_tie(P1Tail, P2Tail);
#resolve_tie([],[]) ->
#    tie.
#
def sort_cards(cards) do
  IO.inspect(cards)
  {val, _} = Enum.unzip(cards)
  Enum.sort(val)
end
#
#score_hand(Cards) ->
#    SortedCards = sort_cards(Cards), %strips out suit
#    High_Card = hd(lists:reverse(SortedCards)),
#    One_pair = find_pair(SortedCards),
#    Two_pair = find_2pair(SortedCards),
#    Three_kind = find_3kind(SortedCards),
#    Straight = find_straight(SortedCards),
#    Flush = find_flush(Cards),
#    Full_House = find_full_house(SortedCards),
#    Four_kind = find_4kind(SortedCards),
#    Straight_Flush = find_straight_flush(Flush, Straight),
#    Royal_Flush = find_royal_flush(High_Card, Straight_Flush),
#    ScoreList = [High_Card, One_pair, Two_pair, Three_kind, Straight, Flush,
#                 Full_House, Four_kind, Straight_Flush, Royal_Flush],
#    HighScore = hd(lists:reverse(lists:sort(ScoreList))),
#    HighScore.
#
#find_pair([First, Second, Third, Fourth, Fifth]) ->
#    %22345, 23345, 23445, 23455
#    Result = if (First =:= Second) or (Second =:= Third) -> Second * 2 * 10;
#                (Third =:= Fourth) or (Fourth =:= Fifth) -> Fourth * 2 * 10;
#                true -> 0
#            end,
#    Result.
#
#find_2pair([First, Second, Third, Fourth, Fifth]) ->
#    %22334, 23344,22344
#    Result = if (First =:= Second) and (Third =:= Fourth) -> (Second + Fourth) * 2 * 100;
#                (Second =:= Third) and (Fourth =:= Fifth) -> (Second + Fourth) * 2 * 100;
#                (First =:= Second) and (Fourth =:= Fifth) -> (Second + Fourth) * 2 * 100;
#                true -> 0
#            end,
#    Result.
#
#find_3kind([First, Second, Third, Fourth, Fifth]) ->
#    % 3-kind could be 3 patterns: 22233, 22333, 23334
#    Result = if (First =:= Second) and (Second =:= Third) -> Second * 3 * 1000;
#                (Second =:= Third) and (Third =:= Fourth) -> Second * 3 * 1000;
#                (Third =:= Fourth) and (Fourth =:= Fifth) -> Fourth * 3 * 1000;
#                true -> 0
#            end,
#    Result.
#
#find_straight([Current, Next | Rest]) when (Next - Current) =:= 1 ->
#    find_straight([Next] ++ Rest);
#find_straight([Current, Next | _]) when (Next - Current) =/= 1 ->
#    0;
#find_straight(Last) when length(Last) =:= 1 ->
#    hd(Last) * 10000.
#
#
#find_flush(Cards) ->
#    {_, Suit} = hd(Cards),
#    SameSuit = [X || {X, XSuit} <- Cards, XSuit == Suit],
#    case length(SameSuit) == 5 of
#        true ->
#            hd(lists:reverse(sort_cards(Cards))) * 100000;
#        false -> 0
#    end.
#
#find_full_house([First, Second, Third, Fourth, Fifth]) ->
#    %22333, 22233
#    Result = if (First =:= Second) and (Third =:= Fifth) -> (First * 2 + Third * 3) * 1000000;
#                (First =:= Third) and (Fourth =:= Fifth) -> (First * 3 + Fourth * 2) * 1000000;
#                true -> 0
#            end,
#    Result.
#
#find_4kind([First, Second, _Third, Fourth, Fifth]) ->
#    Result = if (First =:= Fourth) -> Fourth * 4 * 10000000;
#                (Second =:= Fifth) -> Fourth * 4 * 10000000;
#                true -> 0
#            end,
#    Result.
#
#
#find_straight_flush(Is_Flush, Is_Straight) ->
#    Result = if (Is_Flush > 0) and (Is_Straight > 0) -> Is_Straight / 10000 * 1000000000;
#                true -> 0
#            end,
#    Result.
#
#find_royal_flush(High_Card, Is_Straight_Flush) when (Is_Straight_Flush  > 0) and (High_Card =:= 14) ->
#    io:format("~s ~n", ["Royal Flush!"]),
#    100000000000;
#find_royal_flush(_, _) ->
#    0.
#readlines(FileName) ->
#    {ok, Device} = file:open(FileName, [read]),
#    lists:reverse(get_all_lines(Device, [])).
#
#get_all_lines(Device, Accum) ->
#    case io:get_line(Device, "") of
#        eof  -> file:close(Device), Accum;
#        Line ->
#            SLine = string:strip(Line, right, $\n),
#            {P1Hand, P2Hand} = extract_hands(SLine),
#            P1_decoded_hand = decode_cards(P1Hand, []),
#            P2_decoded_hand = decode_cards(P2Hand, []),
#            get_all_lines(Device, [{P1_decoded_hand, P2_decoded_hand}|Accum])
#    end.
#
def extract_hands(hands, accum \\ [])
def extract_hands([], accum) do accum end
def extract_hands([hand | rest], accum) do
    bothHands = String.trim(hand) |> String.split |> decode_cards([])
    player1Hand = Enum.slice(bothHands, 0, 5)
    player2Hand = Enum.slice(bothHands, 5, 5)
    extract_hands(rest, [{player1Hand, player2Hand} | accum])
    end
def decode_cards([], accum), do: accum
def decode_cards([card | rest], accum) do
  card_val = @cardval[String.at(card,0) |> to_charlist]
  card_suit = @cardsuit[String.at(card,1) |> to_charlist]
  decode_cards(rest, [{card_val, card_suit} | accum])
end

end
#Given: list of tuples where each tuple contains 2 lists
# these lists represent a hand for each player
#Returns: A list representing the same data but decoded from
# [{["2S", "2C"], ["4C", "5D"]}] into
#[ { [{2, :spades}, {2, :clubs}], [{4, :clubs}, {5, :diamonds}] } ]
# def decode_hands([], accum), do: accum
# def decode_hands([{p1, p2} | rest], accum) do
  # decoded_p1 = decode_cards(p1, [])
  # decoded_p2 = decode_cards(p2, [])
  # decode_hands(rest, [{decoded_p1, decoded_p2} | accum])
# end

#Given: list of cards in the format "2S" (in this case 2 of spades)
#Returns: list of tuples, each tuple is a card in the format
# {2, :spades}
