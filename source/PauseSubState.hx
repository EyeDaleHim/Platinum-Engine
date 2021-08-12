package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends MusicBeatSubstate
{
	public var grpMenuShit:FlxTypedGroup<Alphabet>;
	public var menuItems:Array<String> = ['Resume', 'Restart Song', 'Change difficulty', 'Exit to menu'];

	var curSelected:Int = 0;
	var selectedString:String = '';
	var daSelected:String;

	var pauseMusic:FlxSound;
	var selectTxt:FlxText;

	var focus:Int = 0;

	public function new(x:Float, y:Float)
	{
		super();

		if (PlayState.isStoryMode)
			menuItems = ['Resume', 'Restart Song', 'Exit to menu'];

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		selectTxt = new FlxText(0, 0, FlxG.width / 2.5, "", 24);
		selectTxt.setFormat(Paths.font("vcr.ttf"), 24);
		add(selectTxt);

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		daSelected = menuItems[curSelected];

		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		switch (daSelected)
		{
			case 'Resume':
				selectedString = 'Go back to playing the game.';
			case 'Restart Song':
				selectedString = 'Restart the song from the beginning.';
			case 'Change difficulty':
				selectedString = 'Change the difficulty. But restarts the song.';
			case 'Exit to menu':
				selectedString = 'Go back to the menu.';
			default:
				selectedString = 'PAUSED';
		}

		selectTxt.text = selectedString;

		if (upP /* || focusUp */)
		{
			changeSelection(-1);
		}
		if (downP /* || focusDown */)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					PlayState.isPaused = false;
					close();
				case "Restart Song":
					LoadingState.loadAndSwitchState(new PlayState());
				case "Change difficulty":
					changeItems(1);
				case "Exit to menu":
					if (PlayState.isStoryMode)
						FlxG.switchState(new StoryMenuState());
					else if (!PlayState.isStoryMode)
						FlxG.switchState(new FreeplayState());
					else
					{
						// use it if we somehow broke lmao
						FlxG.switchState(new MainMenuState());
					}
				case 'EASY' | "NORMAL" | "HARD":
					if (daSelected == 'EASY')
						PlayState.storyDifficulty = 0;
					else if (daSelected == "NORMAL")
						PlayState.storyDifficulty = 1;
					else if (daSelected == "HARD")
						PlayState.storyDifficulty = 2;
					var poop:String = Highscore.formatSong(PlayState.SONG.song.toLowerCase(), PlayState.storyDifficulty);

					trace(poop);

					trace(poop, menuItems[curSelected].toLowerCase());
					PlayState.SONG = Song.loadFromJson(poop, PlayState.SONG.song.toLowerCase());

					LoadingState.loadAndSwitchState(new PlayState());
				case 'Back':
					curSelected = 0;
					changeItems(0);
				default:
					PlayState.storyDifficulty = 1;
					LoadingState.loadAndSwitchState(new PlayState());
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeItems(focus:Int):Void
	{
		switch (focus)
		{
			case 0:
				switch (PlayState.isStoryMode)
				{
					case false:
						menuItems = ['Resume', 'Restart Song', 'Change difficulty', 'Exit to menu'];
					case true:
						// i understand but you can't do that
						menuItems = ['Resume', 'Restart Song', 'Exit to menu'];
				}
			case 1:
				menuItems = ['EASY', "NORMAL", "HARD", 'Back'];
		}

		grpMenuShit.clear();

		curSelected = 0;
		changeSelection();

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}
		// call it twice to fix white text??
		changeSelection();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));
			item.selected = false;

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
				item.selected = true;
			}
		}
	}
}
