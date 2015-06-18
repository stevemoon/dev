%% A micro-blog, which sets up a frame with menus, and allows an
%% "about" box to be displayed.

-module(wxtest).
-compile(export_all).

%-include_lib("c:/Program Files/erl6.3/lib/wx-1.3.2/include/wx.hrl").
-include_lib("wx/include/wx.hrl").

-define(ABOUT,?wxID_ABOUT).
-define(EXIT,?wxID_EXIT).
%% Top-level function: create the wx-server, the graphical objects,
%% show the application, process and clean up on termination.
start() ->
	wx:new(),
	Frame = wxFrame:new(wx:null(), ?wxID_ANY, "wxtest"),
	setup(Frame),
	wxFrame:show(Frame),
	loop(Frame),
	wx:destroy().

%% Top-level frame: create a menu bar, two menus, two menu items
%% and a status bar. Connect the frame to handle events.
setup(Frame) ->
	MenuBar = wxMenuBar:new(),
	File = wxMenu:new(),
	Help = wxMenu:new(),
	wxMenu:append(Help,?ABOUT,"About MicroBlog"),
	wxMenu:append(File,?EXIT,"Quit"),
	wxMenuBar:append(MenuBar,File,"&File"),
	wxMenuBar:append(MenuBar,Help,"&Help"),
	wxFrame:setMenuBar(Frame,MenuBar),
	wxFrame:createStatusBar(Frame),
	wxFrame:setStatusText(Frame,"Welcome to wxErlang"),
	wxFrame:connect(Frame, command_menu_selected),
	wxFrame:connect(Frame, close_window).

loop(Frame) ->
	receive
	#wx{id=?ABOUT, event=#wxCommand{}} ->
		Str = "MicroBlog is a minimal WxErlang example.",
		MD = wxMessageDialog:new(Frame,Str,
		[{style, ?wxOK bor ?wxICON_INFORMATION},
		{caption, "About MicroBlog"}]),
		wxDialog:showModal(MD),
		wxDialog:destroy(MD),
		loop(Frame);
	#wxKey{keyCode=undefined, integer() } -> 
			Str = "Goober!",
		MD = wxMessageDialog:new(Frame,Str,
		[{style, ?wxOK bor ?wxICON_INFORMATION},
		{caption, "About MicroBlog"}]),
		wxDialog:showModal(MD),
		wxDialog:destroy(MD),
		loop(Frame);
%% Good example here: https://code.google.com/p/erlnoob/source/browse/trunk/erlang/snake/src/snake_wxgui.erl?spec=svn15&r=15			
	  % wxKey() = #wxKey{type=undefined | wxKeyEventType(), x=undefined | integer(), y=undefined | integer(), keyCode=undefined | integer(), controlDown=undefined | boolean(), shiftDown=undefined | boolean(), altDown=undefined | boolean(), metaDown=undefined | boolean(), scanCode=undefined | boolean(), uniChar=undefined | integer(), rawCode=undefined | integer(), rawFlags=undefined | integer()} 
	#wx{id=?EXIT, event=#wxCommand{type=command_menu_selected}} ->
		wxWindow:close(Frame,[])

	end.
