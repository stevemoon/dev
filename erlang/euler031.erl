-module(euler031).
-export([count/2]).

% euler031:go(200,[200,100,50,20,10,5,2,1]).
% 73682
% Algorithm lifted from: http://www.algorithmist.com/index.php/Coin_Change

count(AmountRem, _) when AmountRem == 0 ->
    1;
count(AmountRem, _) when AmountRem < 0 -> 
    0;
count(_, []) -> 
    0;
count(AmountRem, CoinList) ->
    count(AmountRem, tl(CoinList)) + count(AmountRem - hd(CoinList), CoinList).



