%%%-------------------------------------------------------------------
%%% @author  <moonsr@MOONS1>
%%% @copyright (C) 2014, 
%%% @doc
%%%
%%% @end
%%% Created : 10 Mar 2014 by  <moonsr@MOONS1>
%%%-------------------------------------------------------------------
-module(cards).
-export([make_deck/0,show_deck/1,shuffle/1]).

make_deck() ->
    [{Card, Suit} || Card <- ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"], Suit <- ["Clubs", "Diamonds", "Hearts", "Spades"]].
 
show_deck(Deck) ->
    lists:foreach(fun(Item) ->
			  io:format("~p~n", [Item]) end, Deck).


shuffle(List) -> shuffle(List, []).
shuffle([], Acc) -> Acc;
shuffle(List, Acc) ->
  {Leading, [H | T]} = lists:split(random:uniform(length(List)) - 1, List),
  shuffle(Leading ++ T, [H | Acc]).
