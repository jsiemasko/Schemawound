//Blog post describing this class: http://schemawound.tumblr.com/post/22662485300/supercollider-slimlauncher

/*
SlimLauncher
by Jonathan Siemasko
Contact: schemawound@yahoo.com
Homepage: http://newkirk.biz/schemawound/
Blog: http://schemawound.tumblr.com/
Soundcloud: http://soundcloud.com/schemawound
Twitter: https://twitter.com/Schemawound

This is a launcher for frequently used windows.

userButtonsDef - expects an array of events with the following fields:
	buttonName: Display name for the button
	alwaysOnTop: true/false - window should always be on top?
	bounds: Bounds for the window.  This is something you will want to change based on the resolution of your machine and your personal preferences. In order
		to find the proper values set the windows the way you like them and hit the POS button.  This will post the current bounds for each window to the post
		window.  You can then edit the code with these values to set it for the future. (NOTE: ONLY WORKS FOR WINDOWS, NOT VIEWS)
	showButton: The function that should be called to show your button.  Should return a window or a view for other functions to work correctly.

launcherBounds: The bounds for the launcher window

showPositionButton: true/false - display position button.  This is used for setting up the position of your buttons.  See the description of windowsBounds above.

showGlobalButtons: This is a pair of buttons to show/hide all windows.

EXAMPLE:
	var userButtons = [
		(buttonName: "Server",		alwaysOnTop: true,	bounds: Rect(1285, 490, 290, 100),	showButton: {
			var window = Server.internal.makeWindow;
			window.window
		}),
		(buttonName: "Scope", 		alwaysOnTop: true,	bounds: Rect(1285, 203, 290, 250), 	showButton: {
			var window = Server.internal.scope;
			window.window
		}),
		(buttonName: "Freq", 		alwaysOnTop: true,	bounds: Rect(1610, 78, 712, 250), 	showButton: {
			var window = FreqScope.new;
			window.window
		}),
		(buttonName: "Class", 		alwaysOnTop: true,	bounds: Rect(1608, 366, 712, 697), 	showButton: {
			var window;
			Object.browse;
			Window.allWindows.do{|win|
				if(win.name == "class browser", {window = win})
			};
			window
		}),
		(buttonName: "SynthDef",	alwaysOnTop: true,	bounds: Rect(1608, 366, 712, 697), 	showButton: {
			var window;
			SynthDescLib.global.read;
			SynthDescLib.global.browse;
			Window.allWindows.do{|win|
				if(win.name == "SynthDef browser", {window = win})
			};
			window
		}),
		(buttonName: "SCCode",		alwaysOnTop: true,	bounds: Rect(2335, 135, 535, 986), 	showButton: {
			WebView()
				.bounds_(Rect(2335, 135, 535, 986))
				.url_("http://doc.sccode.org/Search.html")
				.front
		})
	];
	SlimLauncher.show(userButtons, Rect(1409, 923, 182, 205), false, true);
*/

SlimLauncher{
	classvar userButtons;

	*show{|userButtonsDef, launcherBounds, showPositionButton = true, showGlobalButtons = true|
		//----------VARIABLES----------
		var posButton, hideAllButton, showAllButton, nonUserButtonLayout, launcherWindow;
		userButtons = userButtonsDef;
		//----------CREATE WINDOW----------
		launcherWindow = Window("Launcher", launcherBounds)
			.layout_(VLayout())
			.alwaysOnTop_(true)
			.onClose_({userButtons.do({|buttonDef| this.closeWindow(buttonDef)})})
			.front;  //Create Window
		//----------ADD BUTTONS----------
		userButtons.do({|ev, index| ev.button = this.createButton(ev); launcherWindow.layout.add(ev.button)});
		//----------NON-USER BUTTONs----------
		posButton = Button()
			.states_([["Pos", Color.white, Color.grey]])
			.action_({Window.allWindows.do { |win| [win.name.asCompileString, win.bounds].postln}});
		hideAllButton = Button()
			.states_([["Hide All", Color.white, Color.grey]])
			.action_({userButtons.do({|buttonDef|
				if(buttonDef.window != nil, {buttonDef.button.valueAction = 0})})});
		showAllButton = Button()
			.states_([["Show All", Color.white, Color.grey]])
			.action_({userButtons.do({|buttonDef|
				if(buttonDef.window == nil, {buttonDef.button.valueAction = 1})})});
		nonUserButtonLayout = HLayout();
		if(showPositionButton == true, {nonUserButtonLayout.add(posButton)});
		if(showGlobalButtons == true, {
			nonUserButtonLayout.add(hideAllButton);
			nonUserButtonLayout.add(showAllButton);
		});
		if(showPositionButton == true || showGlobalButtons == true, {launcherWindow.layout.add(nonUserButtonLayout)});
	}

	*closeWindow{|buttonDef| if (buttonDef.window != nil, {buttonDef.button.value = 0; buttonDef.window.close; buttonDef.window = nil})}

	*setWindowOptions{|window, bounds, alwaysOnTop| window.bounds_(bounds).alwaysOnTop_(alwaysOnTop).userCanClose_(false)}

	*createButton{|buttonDef| //take an event and make a button out of it
		var	states = [[buttonDef.buttonName, Color.white, Color.grey],[buttonDef.buttonName, Color.white, Color.red]];
		var action = {|butt| if(butt.value == 1,
			{
				buttonDef.window = buttonDef.showButton;
				buttonDef.bound.postln;
				this.setWindowOptions(buttonDef.window, buttonDef.bounds, buttonDef.alwaysOnTop);
			},
			{this.closeWindow(buttonDef)}
		)};
		^Button().states_(states).action_(action)
	}
}