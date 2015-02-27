-module(euler059).
-export([go/0, foobar/1, sum_plaintext/1]).

% based on excel analysis 79, 68, and 71 are the 3 most common characters.
% The most common text character is a space, so the key is likey a combination of d-g-o
% xor space (32) with each of the common numbers and you get d-g-o.

% 1> c(euler059).
% {ok,euler059}
% 2> euler059:go().
% {match,[{36,5}]} {103,111,100} 
% (The Gospel of John, chapter 1) 1 In the beginning the Word already existed. He was with God, 
% Based on brute force the key is "god".
%
% 3> euler059:foobar([103,111,100]).
% "(The Gospel of John, chapter 1) 1 In the beginning the Word al
% -- Sure enough -- that works!
%
% my fread function doesn't catch the last integer correctly. Rather than fix the function I just added
% a trailing comma so the pattern matches correctly.

% And the answer is (drumroll please...)
% 5> euler059:sum_plaintext([103,111,100]).
% 107359

go() ->
    CipherText = readlines("p059_cipher.txt"),
    brute_force(CipherText, 97, 97, 97).

foobar(Key) ->
    CipherText = readlines("p059_cipher.txt"),
    decrypt(CipherText, Key, []).

sum_plaintext(Key) ->
    CipherText = readlines("p059_cipher.txt"),
    PlainText = decrypt(CipherText, Key, []),
    lists:foldl(fun(X, Sum) -> X + Sum end, 0, PlainText).



brute_force(CipherText, Key1, Key2, Key3) when (Key1 =< 122) and (Key2 =< 122) and (Key3 =< 122) ->
	Trial = decrypt(CipherText, [Key1, Key2, Key3], []),
    Result = re:run(Trial, " the "),
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
	decrypt(CipherTail, KeyTail ++ [KeyHead], Accum ++ [PlainText]);
decrypt([],_,Accum) ->
	Accum.

readlines(Filename) ->
    {ok, IoDev} = file:open(Filename, [read]),
    read([], IoDev).

read(List, IoDev) ->
    case io:fread(IoDev, "", "~d,") of
        {ok, [A]} ->
            %io:format("~w ", [A]),
            read([A | List], IoDev);
        eof ->
            lists:reverse(List);
        {error, _} ->
            failed,
            read(List, IoDev)
    end.
 