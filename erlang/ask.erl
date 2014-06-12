-module(ask).
-export([line/0]).

line() ->
    Goober = get_goober(),
    H = get_distance() * 1.0,
    W = get_distance() * 1.0,
    Shape = char_to_shape(Goober),
    %Area = geom:area({Shape, H, W}),
    Area = calculate(Shape, H, W),
    Area. 
%,
    %io:format("~p ~s ~f ~f Area is: ~f ~n", [Shape, [Goober], H, W, Area]).

calculate(_, A, B) when A < 0; B < 0 ->
    io:format("Both numbers must be greater than or equal to zero~n"),
	0;
calculate(Shape, H, W) when H >= 0; W >= 0 -> 
    Area = geom:area({Shape, H, W}),
    io:format("~p ~f ~f Area is: ~f ~n", [Shape, H, W, Area]),
    Area.
    
get_goober() ->
    hd(io:get_line("Give me character, goober!> ")).

get_distance()->     
    Input = io:get_line("Give me a number, n00b!> "),
    {Test, _} = string:to_float(Input),
    case Test of
	error -> {Distance, _} = string:to_integer(Input);
	_ -> Distance = Test
    end,
    Distance.

char_to_shape(Char) ->
    LC_Char = string:to_lower(Char),
    if 
         [Char] == "r" -> rectangle;
         [LC_Char] == "t" -> triangle;
         [LC_Char] == "e" -> ellipse;
	 true -> unknown 
    end.
					       
