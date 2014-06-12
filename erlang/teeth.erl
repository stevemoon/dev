-module(teeth).
-export([alert/1]).

alert(LoL) ->
    ToothNum = 0,
    BadTeeth = [],
    alert(LoL, ToothNum, BadTeeth).

alert(LoL, ToothNum, BadTeeth) when length(LoL) >= 1 ->
    CurTooth = ToothNum + 1,
    [HeadLoL | TailLoL] = LoL,
    case stats:maximum(HeadLoL) >= 4 of
	true -> BadTeethX = [CurTooth | BadTeeth];
	false -> BadTeethX = BadTeeth
    end,
    alert(TailLoL, CurTooth, BadTeethX);
alert(LoL, ToothNum, BadTeeth) ->
    lists:reverse(BadTeeth).

