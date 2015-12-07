-module(euler054).
-export([go/1]).

go(FileName) ->
    GameData = readlines(FileName),
    io:format("~w", [[P1Score, P2Score, Ties]]).


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
