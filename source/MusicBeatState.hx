package;

import flixel.util.FlxSave;
#if desktop
import Discord.DiscordClient;
#end
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxGame;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.TransitionData;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.ui.FlxSoundTray;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class MusicBeatState extends FlxUIState
{
	public static var currentState:FlxState;

	// html5
	#if web
	var saveData:FlxSave;
	#end

	private var lastUpdate:Float = 0;

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
	}

	var coolElapsed:Float = 0;

	override function update(elapsed:Float)
	{
		// everyStep();
		Conductor.offsetPos = Conductor.songPosition - Conductor.offset;
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		coolElapsed += elapsed;
		// yeh... idk how to make an elapsed thing

		// updateVirtual(elapsed / (Main.framerate / Main.fakeFramerate));

		if (oldStep != curStep && curStep > 0)
			stepHit();

		FlxG.watch.addQuick("songPos", Math.round(Conductor.songPosition));
		FlxG.watch.addQuick("offsetPos", Math.round(Conductor.songPosition - Conductor.offset));

		super.update(elapsed);
	}

	public function initData()
	{
		if (!TitleState.initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, -1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);

			#if !web
			trace("User data is " + Sys.getEnv("USERNAME"));
			FlxG.save.bind(GameData.modName, Sys.getEnv("USERNAME"));
			#else
			saveData = new FlxSave();
			saveData.bind(GameData.modName + '_html5');
			#end

			PlayerSettings.init();
			PlayerSettings.setBindingsFromFile();
			Highscore.load();
			GameData.initSettings();

			if (FlxG.save.data.weekUnlocked != null)
			{
				// FIX LATER!!!
				// WEEK UNLOCK PROGRESSION!!
				// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

				if (StoryMenuState.weekUnlocked.length < 4)
					StoryMenuState.weekUnlocked.insert(0, true);

				// QUICK PATCH OOPS!
				if (!StoryMenuState.weekUnlocked[0])
					StoryMenuState.weekUnlocked[0] = true;
			}

			#if FREEPLAY
			FlxG.switchState(new FreeplayState());
			#elseif CHARTING
			FlxG.switchState(new ChartingState());
			#end

			#if desktop
			DiscordClient.initialize();

			Application.current.onExit.add(function(exitCode)
			{
				DiscordClient.shutdown();
			});
			#end
			TitleState.initialized = true;
		}
		PlayerSettings.setBindingsFromFile();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function fakeUpdate(elapsed:Float):Void
	{
		// a
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		// do literally nothing dumbass
	}
}
