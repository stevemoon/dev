-module(euler059).
-export([go/0, foobar/1]).

%need to fix file read using fread instead of read so I get integers
%http://stackoverflow.com/questions/10295557/erlang-reading-integers-from-file
% based on excel analysis 79, 68, and 71 are the 3 most common characters.
% The most common text character is a space, so the key is likey a combination of d-g-o
% xor space (32) with each of the common numbers and you get d-g-o.

go() ->
    FileData = readlines("p059_cipher.txt"),
    CipherText = hd(hd(string:tokens(FileData, ","))),
    %io:format("~s~n", [CipherText]),
    %Key = [103,104,105],
    brute_force(CipherText, 97, 97, 97).
    %brute_force(97, 97, 97).

foobar(Key) ->
    FileData = readlines("p059_cipher.txt"),
    CipherText = string_to_list(FileData),
    io:format("~w~n", [CipherText]),
    decrypt(CipherText, Key, []).

brute_force(CipherText, Key1, Key2, Key3) when (Key1 =< 122) and (Key2 =< 122) and (Key3 =< 122) ->
	Trial = decrypt(CipherText, [Key1, Key2, Key3], []),
    Result = re:run(Trial, " THE "),
    case Result of
    	nomatch -> 	brute_force(CipherText, Key1, Key2, Key3 + 1);
    	_ -> 		io:format("~w ~w ~n", [Result, {Key1, Key2, Key3}]),
    				io:format("~s ~n", [Trial]),
    				brute_force(CipherText, Key1, Key2, Key3 + 1)
    end;
brute_force(CipherText, Key1, Key2, Key3) when Key3 =:= 123 ->
	brute_force(CipherText, Key1, Key2 + 1, 97);
brute_force(CipherText, Key1, Key2, _) when Key2 =:= 123  ->
	brute_force(CipherText, Key1 + 1, 97, 97);
brute_force(_, Key1, _, _) when Key1 =:= 123 ->
	done.

decrypt([CipherHead | CipherTail], [KeyHead | KeyTail], Accum) ->
	PlainText = CipherHead bxor KeyHead,
	%PlainText = CipherHead,
	%io:format("~s xor ~s ~n", [[CipherHead], [KeyHead]]),
	decrypt(CipherTail, KeyTail ++ [KeyHead], Accum ++ [PlainText]);
decrypt([],_,Accum) ->
	%io:format("~s ~n", [Accum]).
	Accum.

get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), Accum;
        Line ->
            SLine = string:strip(Line, right, $\n),
            get_all_lines(Device, [SLine|Accum])
    end.

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    lists:reverse(get_all_lines(Device, [])).
 