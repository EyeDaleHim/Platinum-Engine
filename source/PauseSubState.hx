package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

using StringTools;

class PauseSubState extends MusicBeatSubstate
{
	public var grpMenuShit:FlxTypedGroup<Alphabet>;
	public var menuItems:Array<String> = ['Resume', 'Restart Song', 'Change difficulty', 'Options', 'Exit to menu'];
	public var changeableValues:Array<Dynamic> = [null, null, null, null, null, null, null];
	public var defaultValues:Array<Dynamic> = [null, null, null, null, null, null, null];

	var bg:FlxSprite;

	var curSelected:Int = 0;
	var selectedString:String = '';
	var daSelected:String;

	var pauseMusic:FlxSound;
	var selectTxt:FlxText;
	var settingsTxt:FlxText;

	var selectedValue:Dynamic;

	var focus:Int = 0;

	// fix rotation camera shit
	var pauseCamera:FlxCamera;

	var renameSong:String = '';
	var wasRenamed:Bool = true;

	public function new(x:Float, y:Float)
	{
		super();

		if (PlayState.isStoryMode)
			menuItems = ['Resume', 'Restart Song', 'Options', 'Exit to menu'];

		#if debug
		menuItems.push('botplay');
		#end

		pauseCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
		pauseCamera.antialiasing = true;
		add(pauseCamera);

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		var lol = pauseMusic.length / 2;
		pauseMusic.volume = 0;
		if (lol > (FlxG.save.data.musicVolume / 100))
			pauseMusic.play(false, FlxG.random.int(0, Std.int(lol)));
		else
			pauseMusic.play(false, FlxG.random.int(0, Std.int(FlxG.save.data.musicVolume / 100)));

		FlxG.sound.list.add(pauseMusic);

		bg = new FlxSprite(-120, -120).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'dadbattle':
				renameSong = 'Dad Battle';
			case 'philly':
				renameSong = 'Philly Nice';
			case 'restless-dreams':
				renameSong = 'Restless Dreams';
			case 'stages-of-grief':
				renameSong = 'Stages of Grief';
			default:
				wasRenamed = false;
		}

		if (!wasRenamed)
		{
			levelInfo.text = PlayState.SONG.song.charAt(0).toUpperCase();
			// levelInfo.text += PlayState.SONG.song;
			levelInfo.text += PlayState.SONG.song.substring(1, PlayState.SONG.song.length);
		}
		else
			levelInfo.text += renameSong;
		levelInfo.scrollFactor.set();

		levelInfo.setFormat(GameData.globalFont, 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(GameData.globalFont, 32);
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
			songText.actPositionMenu = true;
			grpMenuShit.add(songText);
		}

		selectTxt = new FlxText(0, 0, FlxG.width / 2.5, "", 24);
		selectTxt.setFormat(GameData.globalFont, 24);
		add(selectTxt);

		settingsTxt = new FlxText(FlxG.width * 0.8, 560, 0, "a", 32);
		settingsTxt.setFormat(GameData.globalFont, 32, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		settingsTxt.alpha = 0;

		add(settingsTxt);

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		daSelected = menuItems[curSelected];

		if (PlayState.isPaused)
		{
			if ((FlxG.save.data.musicVolume / 100) < 0.5)
			{
				if (pauseMusic.volume < 0.5)
					pauseMusic.volume += 0.01 * elapsed;
			}
			else
			{
				if (pauseMusic.volume < (FlxG.save.data.musicVolume / 100))
					pauseMusic.volume += 0.01 * elapsed;
			}

			if (pauseMusic.volume > FlxG.save.data.musicVolume / 100)
				pauseMusic.volume = FlxG.save.data.musicVolume / 100;
		}

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;
		var left = FlxG.keys.pressed.LEFT;
		var right = FlxG.keys.pressed.RIGHT;
		var accepted = controls.ACCEPT;

		var someString:String = changeableValues[curSelected];

		if ((changeableValues[curSelected] is Float))
		{
			if (focus != 5)
				someString = "< " + changeableValues[curSelected] + " >";
			else
				someString = "< " + changeableValues[curSelected] + "% >";
		}

		if (someString.startsWith('false'))
			someString = 'off';
		else if (someString.startsWith('true'))
			someString = 'on';

		settingsTxt.text = someString.toUpperCase();

		switch (daSelected)
		{
			case 'Resume':
				selectedString = 'Go back to playing the game.';
			case 'Restart Song':
				selectedString = 'Restart the song from the beginning.';
			case 'Change difficulty':
				selectedString = 'Change the difficulty. But restarts the song.';
			case 'Options':
				selectedString = 'Change the Options.';
			case 'Exit to menu':
				selectedString = 'Go back to the menu.';
			case 'gameplay':
				selectedString = "Change the way you play your games.";
			case 'graphics':
				selectedString = "Change the way your games look.";
			case 'sounds':
				selectedString = "Change the way of how you hear the game's sounds.";
			case 'reset settings':
				selectedString = "Reset your settings to default.";
			case 'Back':
				switch (focus)
				{
					case 1 | 2:
						selectedString = "Head back to Menu.";
					case 3 | 4 | 5:
						selectedString = 'Exit this options sub-category.';
				}
			default:
				selectedString = 'PAUSED';
		}

		var optionSub:Array<Int> = [3, 4, 5];

		if (optionSub.contains(focus))
		{
			settingsTxt.alpha += 3.5 * elapsed;
		}
		else
			settingsTxt.alpha -= 3.5 * elapsed;

		selectTxt.text = selectedString;

		if (upP /* || focusUp */)
		{
			changeSelection(-1);
		}
		if (downP /* || focusDown */)
		{
			changeSelection(1);
		}

		if (leftP || left && curSelected == 5 && focus > 2)
		{
			changeSettings(changeableValues[curSelected], curSelected, true, false);
		}

		if (rightP || right && curSelected == 5 && focus > 2)
		{
			changeSettings(changeableValues[curSelected], curSelected, true, true);
		}

		if (daSelected == 'options' && focus == 2 || daSelected == 'gameplay settings' || daSelected == 'graphics settings' || daSelected == 'sounds settings')
			changeSelection(1);

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (focus)
			{
				case 3 | 4 | 5:
					if (daSelected.toLowerCase() != 'back')
					{
						changeSettings(changeableValues[curSelected], curSelected);
						trace('was returned');
						// return to avoid doing some shit down below
						return;
					}
			}

			switch (daSelected)
			{
				case "Resume":
					pauseMusic.volume = 0;
					FlxG.sound.list.remove(pauseMusic);
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
				case 'botplay':
					if (FlxG.save.data.botplay == null)
						FlxG.save.data.botplay = true;
					else
						FlxG.save.data.botplay = !FlxG.save.data.botplay;

					LoadingState.loadAndSwitchState(new PlayState());
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
				case 'gameplay':
					changeItems(3);
				case 'graphics':
					changeItems(4);
				case 'sounds':
					changeItems(5);
				case 'Options':
					changeItems(2);
				case 'reset settings':
					Settings.reset('downscroll', true);
					var redBG:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 1.2), Std.int(FlxG.height * 1.2));
					redBG.color = 0xFFFF2137;
					redBG.alpha = 0.6;
					FlxTween.color(redBG, 0.8, 0xFFFF2137, 0xFFea71fd, {ease: FlxEase.quintOut});
				case 'Back':
					curSelected = 0;
					switch (focus)
					{
						case 3 | 4 | 5:
							changeItems(2);
						default:
							changeItems(0);
					}
				default:
					FlxG.log.error("This option doesn't have a selection data.");
					// PlayState.storyDifficulty = 1;
					// LoadingState.loadAndSwitchState(new PlayState());
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	function changeItems(focus:Int):Void
	{
		this.focus = focus;

		switch (focus)
		{
			case 0:
				switch (PlayState.isStoryMode)
				{
					case false:
						menuItems = ['Resume', 'Restart Song', 'Change difficulty', 'Options', 'Exit to menu'];
					case true:
						// i understand but you can't do that
						menuItems = ['Resume', 'Restart Song', 'Options', 'Exit to menu'];
				}
			case 1:
				menuItems = ['EASY', "NORMAL", "HARD", 'Back'];
			case 2:
				menuItems = ['options', 'gameplay', 'graphics', 'sounds', 'reset settings', 'Back'];
				changeableValues = [null, null, null, null, null, null, null];
			case 3:
				menuItems = [
					'gameplay settings',
					'downscroll',
					'ghost tapping',
					'accuracy type',
					'score complexity',
					'note offset',
					'Back'
				];
				changeableValues = [
					null,
					FlxG.save.data.downscroll,
					FlxG.save.data.ghostTap,
					FlxG.save.data.accuracy,
					FlxG.save.data.scoreType,
					FlxG.save.data.noteOffset
				];
				defaultValues = [null, false, false, 'simple', 'old', 0];
			case 4:
				menuItems = ['graphics settings', 'graphic presets', 'antialiasing', 'Back'];
				changeableValues = [null, FlxG.save.data.quality, FlxG.save.data.antialiasing];
				defaultValues = [null, 'medium', true];
			case 5:
				menuItems = ['sounds settings', 'music volume', 'sound volume', 'vocal volume', 'Back'];
				changeableValues = [
					null,
					FlxG.save.data.musicVolume,
					FlxG.save.data.soundVolume,
					FlxG.save.data.vocalVolume,
					null
				];
				defaultValues = [null, 100, 100, 100, null];
		}
		trace(changeableValues);

		grpMenuShit.clear();

		switch (focus)
		{
			case 2 | 3 | 4 | 5:
				curSelected = 1;
			default:
				curSelected = 0;
		}
		changeSelection();

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			songText.actPositionMenu = true;
			grpMenuShit.add(songText);
		}
		// call it twice to fix white text??
		changeSelection();
	}

	function changeSettings(item:Dynamic, selected:Int, isOffset:Bool = false, dir:Bool = false):Void
	{
		// go to hell i just copy pasted this
		switch (focus)
		{
			case 3:
				if (item == null)
				{
					changeableValues[selected] = defaultValues[selected];
					trace('lol null error' + changeableValues[selected]);
				}

				if ((item is Bool))
					item = !item;
				if ((item is Float))
				{
					if (isOffset)
					{
						if (FlxG.keys.pressed.SHIFT)
						{
							if (!dir)
								item -= 1;
							else
								item += 1;
						}
						else
						{
							if (!dir)
								item -= 10;
							else
								item += 10;
						}
					}
				}
				if ((item is String))
				{
					if (selected == 4)
					{
						if (item == 'new')
							item = 'old';
						else if (item == 'old')
							item = 'new';
					}
					else if (selected == 3)
					{
						if (item == 'simple')
							item = 'complex';
						else if (item == 'complex')
							item = 'none';
						else if (item == 'none')
							item = 'simple';
					}
				}

				trace(item);
			case 4:
				if (item == null)
					changeableValues[selected] = defaultValues[selected];

				if ((item is Bool))
					item = !item;
				if ((item is String))
				{
					if (selected == 1)
					{
						if (item == 'low')
							item = 'medium';
						else if (item == 'medium')
							item = 'high';
						else if (item == 'high')
							item = 'low';
					}
				}
			case 5:
				if (item == null)
				{
					changeableValues[selected] = defaultValues[selected];
					trace('lol null error' + changeableValues[selected]);
				}

				if ((item is Bool))
					item = !item;
				if ((item is Float))
				{
					if (isOffset)
					{
						if (!dir)
						{
							if (!FlxG.keys.pressed.SHIFT)
								item -= 10;
							else
								item -= 1;
						}
						else
						{
							if (!FlxG.keys.pressed.SHIFT)
								item += 10;
							else
								item += 1;
						}
					}
				}

				// failsafe
				if (item > 100)
					item = 100;
				if (item < 0)
					item = 0;
		}
		changeableValues[selected] = item;
		saveSettings(selected);
	}

	function saveSettings(selected:Int):Void
	{
		var valueString:String = '';

		switch (focus)
		{
			case 3:
				{
					switch (selected)
					{
						case 1:
							valueString = 'downscroll';
						case 2:
							valueString = 'ghostTap';
						case 3:
							valueString = 'accuracy';
						case 4:
							valueString = 'scoreType';
						case 5:
							valueString = 'noteOffset';
					}
				}
			case 4:
				{
					switch (selected)
					{
						case 1:
							valueString = 'quality';
						case 2:
							valueString = 'antialiasing';
					}
					// im so dumb??
					PlayState.bgSprites.forEach(function(spr:FlxSprite)
					{
						spr.antialiasing = FlxG.save.data.antialiasing;
					});
					PlayState.characterSprites.forEach(function(spr:FlxSprite)
					{
						spr.antialiasing = FlxG.save.data.antialiasing;
					});
				}
			case 5:
				{
					switch (selected)
					{
						case 1:
							valueString = 'musicVolume';
						case 2:
							valueString = 'soundVolume';
						case 3:
							valueString = 'vocalVolume';
					}
				}
		}

		Settings.oldSave(changeableValues[selected], valueString);
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

			if (item.text != 'gameplay settings' || item.text != 'graphics settings' || item.text != 'sounds settings' || item.text != 'options')
			{
				item.alpha = 0.6;
				item.selected = false;
			}

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
				item.selected = true;
			}
		}
	}
}
