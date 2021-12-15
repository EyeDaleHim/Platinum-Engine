package;

import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxSpriteUtil;
import flixel.input.FlxKeyManager;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	public static var lastSelected:Int = 0;

	public var keyboardTracker:FlxKeyboard;

	var nextLetter:Int = 0;
	var validLetters:Array<Int> = [FlxKey.ONE, FlxKey.Y, FlxKey.E, FlxKey.A, FlxKey.R]; // 1 YEAR

	public var songName:String = '';

	public static var camFollow:FlxObject;

	var songs:Array<SongMetadata> = [];
	var difficulty:Array<Float> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;
	var daWeekSelected:Int = 0;

	var bg:FlxSprite;
	var mainBG:FlxSprite;
	var fakeMouse:FlxSprite;

	var scoreText:FlxText;
	var diffText:FlxText;
	var songDiff:FlxText;
	var totalText:FlxText;
	var scoreBG:FlxSprite;
	var infoBG:FlxSprite;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var waitTime:Float = 0;

	var bpmTxt:FlxText;

	var canNowMove:Bool = false;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<FreeplayIcon> = [];

	override function create()
	{
		// var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		Settings.init();

		initData();

		keyboardTracker = new FlxKeyboard();

		if (lastSelected != 0)
			curSelected = lastSelected;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(GameData.globalMusic);
		}

		camFollow = new FlxObject();
		camFollow.screenCenter(X);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		FlxG.mouse.visible = true;

		if (StoryMenuState.weekUnlocked[2] || isDebug)
			addWeek(['Tutorial', 'Bopeebo', 'Fresh', 'Dad-battle'], 1, ['gf', 'dad', 'dad', 'dad'], [100, 100, 120, 180]);

		addWeek(['Restless-Dreams'], 2, ['james'], [120]);

		#if debug
		// addWeek(['judgement'], 7, ['dad'], [210]);
		#end

		difficulty = [1, 3, 5, 9, 8, 12, 7, 6, 9, 11, 10, 12, 16, 11, 13, 9, 7, 14, 12];

		// LOAD MUSIC

		// LOAD CHARACTERS

		persistentUpdate = true;
		persistentDraw = true;

		bg = new FlxSprite(-30, -30).loadGraphic(Paths.image('menuBGBlue-SH'));
		bg.scrollFactor.set(0, 0.05);
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		add(bg);

		mainBG = new FlxSprite(-80).loadGraphic(Paths.image('menuBG-SH'));
		mainBG.scrollFactor.x = 0;
		mainBG.scrollFactor.y = 0.15;
		mainBG.setGraphicSize(Std.int(bg.width * 1.1));
		mainBG.updateHitbox();
		mainBG.screenCenter();
		mainBG.antialiasing = true;
		mainBG.alpha = 0;
		add(mainBG);

		darkBG = new FlxSprite(-30, -30).loadGraphic(Paths.image('menuBGDark'));
		darkBG.scrollFactor.set(0, 0.05);
		darkBG.setGraphicSize(Std.int(darkBG.width * 1.2));
		darkBG.alpha = 0;
		add(darkBG);

		fakeMouse = new FlxSprite().makeGraphic(16, 16);
		fakeMouse.scrollFactor.set(0, 0);
		fakeMouse.alpha = 0;
		add(fakeMouse);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			songText.scrollFactor.set(0, 0);
			grpSongs.add(songText);
			songText.x = -950;

			var bullShit:Int = 0;

			for (item in grpSongs.members)
			{
				item.positionY = bullShit - lastSelected;
				bullShit++;
			}

			songText.y = (FlxMath.remapToRange(songText.positionY, 0, 1, 0, 1.3) * 120) + (FlxG.height * 0.48);

			// selective delaying

			var delay:Float = 0;

			if (lastSelected == 0)
				delay = Math.abs(0.1 * i);
			else if (lastSelected == songs.length)
				delay = Math.abs(1.8 - (0.1 * i));
			else
				delay = Math.abs(0.1 * (i - lastSelected));

			FlxTween.tween(songText, {x: lastSelected * 20 + 90}, 0.3, {
				ease: FlxEase.quartOut,
				onComplete: function(twn:FlxTween)
				{
					songText.actPositionMenu = true;
					trace('$delay, ' + songText.text);
				},
				startDelay: delay
			});

			waitTime++;

			var icon:FreeplayIcon = new FreeplayIcon(songs[i].songCharacter, false, songs[i].week);
			icon.sprTracker = songText;
			icon.scrollFactor.set(0, 0);
			icon.parentY = Std.int(songText.targetY);

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.65, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(GameData.globalFont, 32, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		scoreText.scrollFactor.set(0, 0);
		// scoreText.alignment = RIGHT;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.60), 66, FlxColor.BLACK);
		scoreBG.alpha = 0.6;
		scoreBG.scrollFactor.set(0, 0);
		add(scoreBG);
		scoreBG.x += 770;
		FlxTween.tween(scoreBG, {x: scoreBG.x - 770}, 0.6, {ease: FlxEase.quartOut});

		// ill figure what this shit is later
		// FlxSpriteUtil.drawRoundRect(scoreBG, scoreText.x - 6, 0, Std.int(FlxG.width * 0.60), 66, 16, 16, FlxColor.RED);

		infoBG = new FlxSprite(scoreBG.x, 0 + scoreBG.height * 1.4).makeGraphic(Std.int(FlxG.width * 0.45), 66, 0xFF000000);
		infoBG.alpha = 0.6;
		infoBG.scrollFactor.set(0, 0);
		add(infoBG);
		infoBG.x += 770;
		FlxTween.tween(infoBG, {x: 826}, 0.6, {ease: FlxEase.quartOut});

		songDiff = new FlxText(infoBG.x + 6, infoBG.y + 6);
		songDiff.setFormat(GameData.globalFont, 32, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		songDiff.scrollFactor.set(0, 0);
		add(songDiff);
		songDiff.x += 770;
		FlxTween.tween(songDiff, {x: 826 + 6}, 0.6, {ease: FlxEase.quartOut});

		totalText = new FlxText(FlxG.width * 0.85, FlxG.height - 28, 0, "", 24);
		totalText.setFormat(GameData.globalFont, 24, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		totalText.scrollFactor.set(0, 0);
		add(totalText);
		totalText.x += 770;
		FlxTween.tween(totalText, {x: totalText.x - 770}, 0.6, {ease: FlxEase.quartOut});

		diffText = new FlxText(scoreText.x + 128, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		diffText.setFormat(GameData.globalFont, 24, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		diffText.scrollFactor.set(0, 0);
		add(diffText);
		diffText.x += 770;
		FlxTween.tween(diffText, {x: 960}, 0.6, {ease: FlxEase.quartOut});

		bpmTxt = new FlxText(diffText.x - 138, diffText.y + 128, 0, "Press SPACE to play the selected Song.", 24);
		bpmTxt.font = scoreText.font;
		bpmTxt.setFormat(GameData.globalFont, 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		bpmTxt.scrollFactor.set(0, 0);
		bpmTxt.fieldWidth = (FlxG.width - bpmTxt.x);
		add(bpmTxt);
		bpmTxt.x += 770;
		FlxTween.tween(bpmTxt, {x: 960 - 138}, 0.6, {ease: FlxEase.quartOut});

		add(scoreText);
		scoreText.x += 770;
		FlxTween.tween(scoreText, {x: scoreText.x - 770}, 0.6, {ease: FlxEase.quartOut});

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			scoreText.x = FlxG.width * 0.65;
			scoreBG.x = infoBG.x = scoreText.x - 6;
			songDiff.x = infoBG.x + 6;
			totalText.x = FlxG.width * 0.85;
			diffText.x = scoreText.x + 128;
			bpmTxt.x = diffText.x - 138;
			trace(scoreText.x);
			trace(scoreBG.x);
			trace(totalText.x);
			trace(diffText.x);
			trace(bpmTxt.x);
			trace(songDiff.x);
		});

		new FlxTimer().start(0.05 * waitTime, function(tmr:FlxTimer)
		{
			canNowMove = true;
		});
		changeSelection(0, true);
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, bpm:Int, ?http:String = '')
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, bpm, http));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, ?bpm:Array<Int>)
	{
		if (songCharacters == null)
		{
			songCharacters = ['face'];
			FlxG.log.error("unknown character " + songCharacters + " in song" + songs);
		}

		var charNum:Int = 0;
		var bpmNum:Int = 0;

		for (song in songs)
		{
			var http:String = Assets.getText('site.txt');

			addSong(song, weekNum, songCharacters[charNum], bpm[bpmNum], http);

			if (songCharacters.length != 1)
				charNum++;
			if (bpm.length != 1)
				bpmNum++;
		}
	}

	var freeplaySong:Bool = false;

	public function playSong(song:String, selected:Int)
	{
		var renamedSong:String = '';

		FlxG.sound.music.fadeOut((Conductor.crochet / 1000) * 2, 0, function(snd:FlxTween)
		{
			switch (song.toLowerCase())
			{
				case 'philly-nice':
					renamedSong = 'philly';
				case 'dad-battle':
					renamedSong = 'dadbattle';
				default:
					renamedSong = song;
			}
			Conductor.changeBPM(songs[curSelected].bpm);
			freeplaySong = true;
			FlxG.sound.playMusic(Paths.inst(renamedSong), 0, false);
			songName = renamedSong.toLowerCase();
			bpmTxt.text = 'PLAYING: ' + StringTools.replace(song.toUpperCase(), "-", " ") + '...';
			daWeekSelected = songs[selected].week;
			FlxG.sound.music.fadeIn((Conductor.crochet / 1000) * 2, 1);
			FlxTween.tween(darkBG, {alpha: 0}, (Conductor.crochet / 1000) * 6, {ease: FlxEase.quartOut});
			FlxTween.tween(bg, {alpha: 1}, (Conductor.crochet / 1000) * 6, {ease: FlxEase.quartIn});
		});
	}

	var beatList:Array<Int> = [];
	var canBop:Bool = false;
	var isTweening:Bool = false;
	var darkBG:FlxSprite;

	var mouseDelay:Float = 0.60;
	var lastMousePress:Float = 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.watch.addQuick("curBeat", curBeat);
		FlxG.watch.addQuick("curStep", curStep);

		fakeMouse.x = FlxG.mouse.x;
		fakeMouse.y = FlxG.mouse.y;

		Conductor.songPosition = FlxG.sound.music.time;
		lastSelected = curSelected;
		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

		lastMousePress += 0.05;

		if (FlxG.keys.justPressed.ANY)
		{
			if (keyboardTracker.firstJustPressed() == validLetters[nextLetter] && keyboardTracker.firstJustPressed() != -1)
			{
				trace(validLetters[nextLetter]);

				nextLetter++;

				trace('next letter is ' + validLetters[nextLetter]);

				if (nextLetter == 5)
				{
					persistentUpdate = false;

					var coolSong:String = '';
					coolSong = 'secret-tutorial';

					curDifficulty = 1;
					var poop:String = Highscore.formatSong(coolSong, curDifficulty);

					trace(coolSong);
					trace(poop);

					PlayState.SONG = Song.loadFromJson(poop, coolSong);
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 2;

					PlayState.storyWeek = songs[curSelected].week;
					PlayState.lastSelected = lastSelected;

					trace('CUR WEEK' + PlayState.storyWeek);
					trace(poop, 'secret-tutorial');
					switchState(new PlayState());
				}
			}
			else if (keyboardTracker.firstJustPressed() != validLetters[nextLetter] && nextLetter != 0)
			{
				trace('YOU FAILED DUMBASS!!');
				nextLetter = 0;
			}
		}

		if (FlxG.keys.justPressed.Q)
		{
			beatList.push(curStep);
			FlxG.camera.zoom += 0.015;
			trace(beatList);
		}

		/*
			if (FlxG.mouse.pressed && lastMousePress >= mouseDelay)
			{
				grpSongs.forEach(function(spr:Alphabet)
				{
					if ((fakeMouse.x >= spr.x && fakeMouse.x <= spr.x + spr.width)
						&& (fakeMouse.y >= spr.y && fakeMouse.y <= spr.y + spr.height)
						&& (spr.targetY != curSelected))
					{
						changeSelection(Std.int(spr.targetY));
						lastMousePress = 0;
					}
				});

				for (spr in iconArray)
				{
					if ((fakeMouse.x >= spr.x && fakeMouse.x + fakeMouse.width <= spr.x + spr.width)
						&& (fakeMouse.y >= spr.y && fakeMouse.y + fakeMouse.height <= spr.y + spr.height))
					{
						changeSelection(Std.int(spr.parentY));
						lastMousePress = 0;
					}
				}
		}*/

		if (FlxG.keys.justPressed.E)
		{
			beatList = [];
			trace(beatList);
			trace(songName);
		}

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(GameData.globalMusic, 0);
				freeplaySong = false;
				bpmTxt.text = "Press SPACE to play the selected Song.";
			}
		}

		if (FlxG.save.data.musicVolume > 70)
		{
			if (FlxG.sound.music.volume < 0.7)
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		else
		{
			if (FlxG.sound.music.volume < FlxG.save.data.musicVolume / 100)
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		totalText.text = curSelected + 1 + " / " + songs.length + " Songs";
		songDiff.text = "Difficulty: " + difficulty[curSelected];

		totalText.y = Math.floor(FlxMath.lerp(totalText.y, FlxG.height - 28, 0.14 * (60 / Main.framerate)));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		var coolLerpScore:Int = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));
		var coolScore:String = FlxStringUtil.formatMoney(coolLerpScore, false, true);

		scoreText.text = "PERSONAL BEST: " + coolScore;
		// scoreText.text = "PERSONAL BEST: " + coolScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = FlxG.keys.justPressed.ENTER;
		var accepted2 = FlxG.keys.justPressed.SPACE;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			if (!isTweening)
			{
				isTweening = true;

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;

				FlxG.camera.follow(MainMenuState.camFollow, LOCKON, 0.06 * (60 / Main.framerate));

				FlxTween.tween(mainBG, {alpha: 1}, 0.4, {ease: FlxEase.quintIn});
				FlxTween.tween(bpmTxt, {x: 1550}, 0.42, {ease: FlxEase.quintIn});
				FlxTween.tween(diffText, {x: 1550}, 0.44, {ease: FlxEase.quintIn});
				FlxTween.tween(songDiff, {x: 1550}, 0.44, {ease: FlxEase.quintIn});
				FlxTween.tween(scoreText, {x: 1550}, 0.46, {ease: FlxEase.quintIn});
				FlxTween.tween(scoreBG, {x: 1550}, 0.48, {ease: FlxEase.quintIn});
				FlxTween.tween(infoBG, {x: 1550}, 0.5, {ease: FlxEase.quintIn});
				FlxTween.tween(totalText, {x: 1550}, 0.52, {ease: FlxEase.quintIn});
				for (item in grpSongs.members)
				{
					item.actPositionMenu = false;
					FlxTween.tween(item, {x: -750}, 0.6, {ease: FlxEase.quintIn});
				}

				new FlxTimer().start(0.8, function(tmr:FlxTimer)
				{
					switchState(new MainMenuState());
				});
			}
		}

		if (accepted)
		{
			persistentUpdate = false;

			var coolSong:String = '';
			switch (songs[curSelected].songName.toLowerCase())
			{
				case 'philly-nice':
					coolSong = 'philly';
				case 'dad-battle':
					coolSong = 'dadbattle';
				default:
					coolSong = songs[curSelected].songName.toLowerCase();
			}

			var poop:String = Highscore.formatSong(coolSong, curDifficulty);

			trace(coolSong);
			trace(poop);

			/*if (songs[curSelected].site.length > 2)
			{
				var txt:FlxText = new FlxText(0, 0, 0, 'Loading...', 36);
				txt.font = GameData.globalFont;
				txt.screenCenter();
				add(txt);

				new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					PlayState.SONG = Song.loadFromHttp(songs[curSelected].site);
				});
			}
			else*/
				PlayState.SONG = Song.loadFromJson(poop, coolSong);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			PlayState.lastSelected = lastSelected;
			
			FlxG.sound.cache('songs:assets/songs/${PlayState.SONG.song}/Inst' + TitleState.soundExt);
			if (PlayState.SONG.needsVoices)
				FlxG.sound.cache('songs:assets/songs/${PlayState.SONG.song}/Voices' + TitleState.soundExt);

			trace('CUR WEEK' + PlayState.storyWeek);
			trace(poop, songs[curSelected].songName.toLowerCase());
			LoadingState.loadAndSwitchState(new PlayState());
		}
		if (accepted2)
		{
			playSong(songs[curSelected].songName, curSelected);
		}
	}

	override function stepHit()
	{
		if (BeatSync.getSteps(songName.toLowerCase()).contains(curStep) && freeplaySong)
		{
			if (!canBop)
			{
				if (curBeat >= 168 && curBeat <= 232 && songName.toLowerCase() == 'philly-nice')
					FlxG.camera.zoom += 0.03 * (FlxG.save.data.musicVolume / 100);
				else if (curBeat >= 128 && curBeat <= 192 && songName.toLowerCase() == 'blammed')
					FlxG.camera.zoom += 0.09 * (FlxG.save.data.musicVolume / 100);
				else
					FlxG.camera.zoom += 0.015 * (FlxG.save.data.musicVolume / 100);
			}

			for (i in 0...iconArray.length)
			{
				if (iconArray[i].week == daWeekSelected)
				{
					FlxTween.cancelTweensOf(iconArray[i].scale);

					iconArray[i].scale.x = 1;
					iconArray[i].scale.y = 1;

					FlxTween.tween(iconArray[i].scale, {x: 1.15, y: 1.15}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
				}
			}

			canBop = true;
		}
		else
		{
			canBop = false;
		}

		// huh?
		if (curStep % 4 == 0)
			beatHit();
	}

	override function beatHit()
	{
		if (curBeat % 8 == 7)
		{
			if (songName.toLowerCase() == 'bopeebo')
			{
				for (icon in iconArray)
				{
					if (icon.animation.curAnim.name == 'gf')
					{
						icon.animation.play('gf-cheer');
						icon.offset.y -= 11;
					}
				}
			}
		}
		else
		{
			if (songName.toLowerCase() == 'bopeebo')
			{
				for (icon in iconArray)
				{
					if (icon.animation.curAnim.name == 'gf-cheer')
					{
						icon.animation.play('gf');
						icon.offset.y += 11;
					}
				}
			}
		}

		if (curBeat == 128 && songName.toLowerCase() == 'blammed')
		{
			FlxTween.tween(darkBG, {alpha: 1}, (Conductor.crochet / 1000) * 4, {ease: FlxEase.quartOut});
			FlxTween.tween(bg, {alpha: 0}, (Conductor.crochet / 1000) * 4, {ease: FlxEase.quartIn});
			FlxG.camera.flash(FlxColor.WHITE, 0.3, null, true);
		}
		if (curBeat == 192 && songName.toLowerCase() == 'blammed')
		{
			FlxTween.tween(darkBG, {alpha: 0}, (Conductor.crochet / 1000) * 6, {ease: FlxEase.quartOut});
			FlxTween.tween(bg, {alpha: 1}, (Conductor.crochet / 1000) * 6, {ease: FlxEase.quartIn});
		}
		if (songName.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200)
		{
			FlxG.camera.zoom += 0.03;
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		if (FlxG.save.data.soundVolume > 0.4)
			FlxG.sound.play(Paths.sound('scrollMenu_SH'), 0.4);
		else
			FlxG.sound.play(Paths.sound('scrollMenu_SH'), FlxG.save.data.soundVolume);

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		diffText.text = "< ";

		switch (curDifficulty)
		{
			case 0:
				diffText.text += "EASY >";
			case 1:
				diffText.text += 'NORMAL >';
			case 2:
				diffText.text += "HARD >";
		}
	}

	function changeSelection(change:Int = 0, force:Bool = false)
	{
		if (canNowMove || force)
		{
			// NGio.logEvent('Fresh');
			// FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			if (FlxG.save.data.soundVolume > 0.4)
				FlxG.sound.play(Paths.sound('scrollMenu_SH'), 0.4);
			else
				FlxG.sound.play(Paths.sound('scrollMenu_SH'), FlxG.save.data.soundVolume);

			curSelected += change;

			if (curSelected < 0)
				curSelected = songs.length - 1;
			if (curSelected >= songs.length)
				curSelected = 0;

			camFollow.y = curSelected * 30;

			// selector.y = (70 * curSelected) + 30;

			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			// lerpScore = 0;
			#end

			#if PRELOAD_ALL
			// FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
			#end

			var bullShit:Int = 0;

			totalText.y -= 25;

			for (i in 0...iconArray.length)
			{
				iconArray[i].alpha = 0.6;
			}

			iconArray[curSelected].alpha = 1;

			for (item in grpSongs.members)
			{
				item.targetY = bullShit - curSelected;
				bullShit++;

				item.alpha = 0.6;
				item.selected = false;
				// item.setGraphicSize(Std.int(item.width * 0.8));

				if (item.targetY == 0)
				{
					item.selected = true;
					item.alpha = 1;
					// item.setGraphicSize(Std.int(item.width));
				}
			}
		}
	}
}

class FreeplayIcon extends HealthIconOld
{
	public var week:Int = 0;

	override public function new(char:String = 'bf', isPlayer:Bool = false, week:Int = 0)
	{
		this.week = week;

		super(char, isPlayer);
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var difficulty:Float = 0;
	public var bpm:Int = 0;
	public var site:String = '';

	public function new(song:String, week:Int, songCharacter:String, bpm:Int = 100, ?site:String = '')
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.bpm = bpm;
		this.site = site;
	}
}
