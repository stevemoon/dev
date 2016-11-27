defmodule Euler054 do
  @chunksize 10000
  @cardval %{'1' => 1,  '2' => 2,  '3' => 3,  '4' => 4, '5' => 5,
             '6' => 6,  '7' => 7,  '8' => 8,  '9' => 9, 'T' => 10,
             'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14}
  @cardsuit %{'C' => :clubs, 'D' => :diamonds, 'H' => :hearts, 'S' => :spades}
  def time(fun) do
    {time, result} = :timer.tc(fun)
    # {time, result} = :timer.tc(fn -> Euler054.score_file_parallel('./../../../poker/poker_1mil.txt') end )
    IO.inspect(result)
    IO.puts"Completed in #{time / 1_000_000} seconds."
  end
  def score_file_parallel(filename \\ './lib/poker.txt') do
    File.stream!(filename)
    |> Stream.chunk(@chunksize, @chunksize, [])
    |> Enum.map(&(Task.async(fn -> partask(&1) end)))
    |> Enum.map(&Task.await/1)
    # |> sum_tuples({0, 0, 0})
    |> Enum.reduce(fn {r1, r2, r3}, {a1, a2, a3} -> {r1 + a1, r2 + a2, r3 + a3} end)
    # |> Enum.reduce({0, 0, 0}, fn {r1, r2, r3}, {a1, a2, a3} -> {r1 + a1, r2 + a2, r3 + a3} end)
  end
  def sum_tuples([], accum), do: accum
  def sum_tuples([{x, y, z} | rest], {a, b, c}) do
    sum_tuples(rest, {x + a, y + b, z + c})
  end
  def partask(chunk) do
    chunk
    |> Enum.to_list
    |> List.flatten
    |> extract_hands
    |> process_hands
  end
  def score_file(filename \\ './lib/poker.txt') do
    File.stream!(filename)
    |> Stream.chunk(@chunksize, @chunksize, [])
    |> Enum.to_list
    |> List.flatten
    |> extract_hands
    |> process_hands
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
      p1sorted = sort_cards(p1hand) |> Enum.reverse
      p2sorted = sort_cards(p2hand) |> Enum.reverse
      resolve_tie(p1sorted, p2sorted)
  end
end


def resolve_tie([],[]), do: :tie
def resolve_tie([p1max | _p1tail], [p2max | _p2tail]) when p1max > p2max, do: :p1
def resolve_tie([p1max | _p1tail], [p2max | _p2tail]) when p1max < p2max, do: :p2
def resolve_tie([p1max | p1tail], [p2max | p2tail]) when p1max == p2max do
  resolve_tie(p1tail, p2tail)
end
def resolve_tie(_, _), do: :error

def sort_cards(cards) do
  #IO.inspect(cards)
  {val, _} = Enum.unzip(cards)
  Enum.sort(val)
end

def score_hand(cards) do
  sc = sort_cards(cards)
  scorelist = [
    Enum.max(sc), #High card
    one_pair?(sc),
    two_pair?(sc),
    three_kind?(sc),
    straight?(sc),
    flush?(cards, sc),
    full_house?(sc),
    four_kind?(sc),
    straight_flush?(cards, sc),
    royal_flush?(cards,sc)
  ]
  # IO.inspect(scorelist)
  Enum.max(scorelist)
end

def one_pair?([a, b, c, d, e]) do
  #22345, 23345, 23445, 23455
  cond do
    d == e -> e * 2 * 10
    c == d -> d * 2 * 10
    b == c -> c * 2 * 10
    a == b -> b * 2 * 10
    true -> 0
  end
end

def two_pair?([a, b, c, d, e]) do
  #22334, 23344, 22344
  cond do
  a == b && c == d -> (b + d) * 2 * 100
  b == c && d == e -> (c + e) * 2 * 100
  a == b && d == e -> (b + e) * 2 * 100
  true -> 0
  end
end

def three_kind?([a, b, c, d, e]) do
  #22234, 23334, 23444
  cond do
    a == c -> c * 3 * 1000
    b == d -> d * 3 * 1000
    c == e -> e * 3 * 1000
    true -> 0
  end
end

def straight?([current, next | rest]) when (next - current) == 1 do
  straight?([next] ++ rest)
end
def straight?([current, next | _ ]) when (next - current) != 1, do: 0
def straight?(last) when length(last) == 1, do: hd(last) * 10000

def flush?(cards, sc) do
  {_, suit} = hd(cards)
  samesuit = for {_, xsuit} <- cards, suit == xsuit do xsuit end
  case length(samesuit) do
    5 -> Enum.max(sc) * 100000
    _ -> 0
  end
end

def full_house?([a, b, c, d, e]) do
  #22233, 22333
  cond do
    a == c && d == e -> (a * 3 + d * 2) * 1000000
    a == b && c == e -> (a * 2 + c * 3) * 1000000
    true -> 0
  end
end

def four_kind?([a, b, _c, d, e]) do
  #22223, 23333
  cond do
    a == d -> d * 4 * 10000000
    b == e -> e * 4 * 10000000
    true -> 0
  end
end

def straight_flush?(cards, sc) do
  cond do
    straight?(sc) > 0 && flush?(cards, sc) > 0 -> Enum.max(sc) / 10000 * 1000000000
    true -> 0
  end
end

def royal_flush?(cards,sc) do
  cond do
    straight?(sc) > 0 && flush?(cards, sc) > 0 && Enum.max(sc) == 14 -> 100000000000
    true -> 0
  end
end

def extract_hands(hands, accum \\ [])
def extract_hands([], accum) do accum end
def extract_hands([hand | rest], accum) do
    bothHands = String.trim(hand) |> String.split |> decode_cards([])
    player1Hand = Enum.slice(bothHands, 0, 5)
    player2Hand = Enum.slice(bothHands, 5, 5)
    extract_hands(rest, [{player1Hand, player2Hand} | accum])
    end
def decode_cards([], accum), do: Enum.reverse(accum)
def decode_cards([card | rest], accum) do
  card_val = @cardval[String.at(card,0) |> to_charlist]
  card_suit = @cardsuit[String.at(card,1) |> to_charlist]
  decode_cards(rest, [{card_val, card_suit} | accum])
end

end
