package;

import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import Sys.sleep;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import lime.ui.Window;
import lime.app.Application;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.StageDisplayState;
import debug.Dev;
import debug.FPS;

class Main extends Sprite
{	
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with. TitleState is default if you're not on debug.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	#if !desktop
	public static var framerate:Int = 60; // FPS for non-desktop environments.
	#else
	public static var framerate:Int = 120; // How many frames per second the game should run at.
	#end
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		// splashScreen();
		
		if (framerate > 999)
		{
			framerate = 999;
			trace('FPS is above 999!');
		}

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	public static function resize(width:Int, height:Int, resizable:Bool, borderless:Bool):Void
	{
		Application.current.window.x = Std.int(width / 2) - Std.int(width / 2);
		Application.current.window.y = Std.int(height / 2) - Std.int(height / 2);
		
		Application.current.window.resize(width, height);
		Application.current.window.resizable = false;
		Application.current.window.borderless = true;
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		setupGame();
	}

	private function splashScreen():Void
	{
		var maxX:Int;
		var maxY:Int;
		
		Lib.current.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

		maxX = Lib.current.stage.fullScreenWidth;
		maxY = Lib.current.stage.fullScreenHeight;

		Lib.current.stage.displayState = StageDisplayState.NORMAL;

		Application.current.window.x = Std.int(maxX / 2) - Std.int(640 / 2);
		Application.current.window.y = Std.int(maxY / 2) - Std.int(480 / 2);
		
		Application.current.window.resize(640, 480);
		Application.current.window.resizable = false;
		Application.current.window.borderless = true;

		// doesnt work but im leaving it here for something else
		var splash:Sprite;

		var daSprite = new FlxSprite().loadGraphic('platinumlogo/splash_screen.png');

		splash = new Sprite();
		splash.graphics.beginBitmapFill(daSprite.pixels);

		addChild(splash);
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end

		var game:FlxGame = new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen);
		#if debug
		var build:Dev = new Dev(10, 28, 0xFFFFFF, 'Dev Build');
		#elseif tester
		var build:Dev = new Dev(10, 28, 0xFFFFFF, 'Tester Build');
		#end

		addChild(game);

		#if debug
		addChild(build);
		#end

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
	}
}
