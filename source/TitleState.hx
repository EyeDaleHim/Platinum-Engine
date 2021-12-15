package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
import lime.system.System;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if web
import flixel.util.FlxSave;
#end
// import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

using StringTools;

class TitleState extends MusicBeatState
{
	#if !web
	public static var soundExt = ".ogg";
	#else
	public static var soundExt = ".mp3";
	#end
	public static var initialized:Bool = false;

	public static var daSettings:Array<Dynamic>;

	public static var canNowGo:Bool = false;

	var introStarted:Bool = false;

	var coolBool:Bool = false;

	var exitSprite:FlxSprite;
	var followCam:FlxObject;
	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var silentLogo:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	var isInExit:Bool = false;

	var smokeFG:FlxSprite;
	var smokeBG:FlxSprite;

	override public function create():Void
	{
		followCam = new FlxObject(FlxG.width * 0.5, FlxG.height * 0.5);
		curWacky = FlxG.random.getObject(getIntroTextShit());

		// persistentUpdate = persistentDraw = true;

		FlxG.camera.follow(followCam, 1);

		#if tester
		trace('man is a tester');
		#end

		// DEBUG BULLSHIT

		super.create();

		#if !web
		trace("User data is " + Sys.getEnv("USERNAME"));
		FlxG.save.bind(GameData.modName, Sys.getEnv("USERNAME"));
		#else
		saveData = new FlxSave();
		saveData.bind(GameData.modName + '_html5');
		#end

		PlayerSettings.init();
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
		switchState(new FreeplayState());
		#elseif CHARTING
		switchState(new ChartingState());
		#else
		if (!initialized)
		{
			var splashScreen:FlxSprite = new FlxSprite().loadGraphic('platinumlogo/splash_platinum.png');
			splashScreen.antialiasing = true;
			splashScreen.screenCenter();
			add(splashScreen);

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				startIntro();
				remove(splashScreen);
				introStarted = true;
			});
		}
		#end

		#if desktop
		DiscordClient.initialize();

		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
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
			FlxG.sound.playMusic(GameData.globalMusic, 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(90);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 5, FlxG.height * 5, FlxColor.BLACK);
		bg.screenCenter();
		// bg.antialiasing = FlxG.save.data.antialiasing;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		smokeFG = new FlxSprite().loadGraphic(Paths.image('smokeTitle'), true, 1500, 350);
		smokeFG.antialiasing = FlxG.save.data.antialiasing;
		smokeFG.animation.add('smoke', [0], 0, false);
		smokeFG.alpha = 0.5;
		smokeFG.animation.play('smoke');
		smokeFG.scale.x = 1.06;
		smokeFG.updateHitbox();
		// smokeFG.x = FlxG.width - smokeFG.width + ;
		// smokeFG.screenCenter(X);
		smokeFG.y = 430;

		smokeFG.x = 0;
		FlxTween.tween(smokeFG, {x: FlxG.width - smokeFG.width}, 17, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(smokeFG.scale, {y: 1.07}, 6, {ease: FlxEase.quadInOut, startDelay: 2, type: PINGPONG});

		smokeBG = new FlxSprite().loadGraphic(Paths.image('smokeTitle'), true, 1500, 350);
		smokeBG.antialiasing = FlxG.save.data.antialiasing;
		smokeBG.animation.add('smoke', [1], 0, false);
		smokeBG.alpha = 0.5;
		smokeBG.animation.play('smoke');
		smokeBG.scale.x = 1.10;
		smokeBG.updateHitbox();
		// smokeFG.x = FlxG.width - smokeFG.width + ;
		// smokeFG.screenCenter(X);
		smokeBG.y = 390;

		smokeBG.x = FlxG.width - smokeBG.width;

		FlxTween.tween(smokeBG, {x: 0}, 17, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(smokeBG.scale, {y: 1.07}, 6, {ease: FlxEase.quadInOut, startDelay: 2, type: PINGPONG});

		logoBl = new FlxSprite(-30, -65);
		if (GameData.platinumLogo)
			logoBl.frames = FlxAtlasFrames.fromSparrow('platinumlogo/Platinum_Logo_Bumpin.png', 'platinumlogo/Platinum_Logo_Bumpin.xml');
		else
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.scale.set(0.84, 0.84);
		logoBl.antialiasing = FlxG.save.data.antialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		// logoBl.y += FlxG.height + 200;
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('signTitle');
		gfDance.animation.addByPrefix('signLight', 'gfDance', 24, true);
		gfDance.animation.addByIndices('lightOn', 'gfDance', CoolUtil.numberArray(4), "", 24, false);
		gfDance.animation.addByIndices('lightOff', 'gfDance', CoolUtil.numberArray(7, 4), "", 24, false);
		gfDance.antialiasing = FlxG.save.data.antialiasing;
		// gfDance.animation.play('signLight');

		add(smokeBG);
		add(gfDance);
		add(logoBl);
		add(smokeFG);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = FlxG.save.data.antialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		titleText.centerOffsets();
		// uhh idk what i was doing
		titleText.offset.x -= 13;
		titleText.offset.y -= 13;
		titleText.x -= 13;
		titleText.y -= 13;
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = FlxG.save.data.antialiasing;
		// add(logo);

		exitSprite = new FlxSprite(-600, FlxG.height * 0.5);
		exitSprite.loadGraphic(Paths.image('titleExit'));
		exitSprite.antialiasing = FlxG.save.data.antialiasing;

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		blackScreen = new FlxSprite(-1280).makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.BLACK);
		add(blackScreen);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = FlxG.save.data.antialiasing;

		silentLogo = new FlxSprite().loadGraphic(Paths.image('silentHillLogo'));
		add(silentLogo);
		silentLogo.visible = false;
		silentLogo.scale.set(0.3, 0.3);
		silentLogo.updateHitbox();
		silentLogo.screenCenter();
		silentLogo.y = FlxG.height * 0.52;
		silentLogo.setColorTransform(1, 1, 1, 1, 255, 255, 255, 1);
		silentLogo.antialiasing = FlxG.save.data.antialiasing;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		if (Date.now().toString().startsWith(Std.string(Date.now().getFullYear()) + '-09-22'))
			swagGoodArray = [['happy', 'madness day']];

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		FlxG.camera.zoom = flixel.math.FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

		coolBool = FlxG.random.bool(50);

		if (FlxG.keys.justPressed.F11)
		{
			FlxG.fullscreen = false;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		#if desktop
		if (pressedEnter)
		{
			if (isInExit)
			{
				System.exit(0);
			}
		}
		#end

		if (curBeat > 16 && skippedIntro)
		{
			credGroup.forEach(function(spr:Dynamic)
			{
				if (spr.y > FlxG.height * 1.5)
				{
					spr.acceleration.y = 0;
					spr.velocity.y = 0;
					spr.velocity.x = 0;
				}
			});
		}

		if (pressedEnter && !transitioning && skippedIntro && curBeat > 2 && initialized && introStarted)
		{
			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			titleText.x += 13;
			titleText.y += 13;

			transitioning = true;
			// FlxG.sound.music.stop();

			#if !tester
			new FlxTimer().start(0.8, function(tmr:FlxTimer)
			{
				if (canNowGo)
					switchState(new MainMenuState());
				else
					switchState(new AccessState());
			});
			#else
			new FlxTimer().start(0.8, function(tmr:FlxTimer)
			{
				if (canNowGo)
					switchState(new OutdatedSubState());
				else
					switchState(new AccessState());
			});
			#end
		}

		if (pressedEnter && !skippedIntro && introStarted)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	/*
		function timeToExit()
		{
			isInExit = true;
			
			FlxTween.tween(exitSprite, {x: FlxG.width * 0.5}, 0.7, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween) 
			{

			}});
		}
	 */
	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var alsoCool:Float = (i * 60) + 200;

			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			// dont make text appear from newgrounds logo if text is newgrounds
			if (coolBool || textArray.contains('newgrounds'))
				money.y = alsoCool + 15;
			else
				money.y = alsoCool - 15;

			money.alpha = 0;
			// money.y += (i * 60) + 200;
			FlxTween.tween(money, {y: alsoCool, alpha: 1}, 0.3, {ease: FlxEase.quadInOut});
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolThingie:Float = (textGroup.length * 60) + 200;

		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		if (coolBool || text == 'newgrounds')
			coolText.y = coolThingie - 15;
		else
			coolText.y = coolThingie + 15;

		coolText.alpha = 0;
		FlxTween.tween(coolText, {y: coolThingie, alpha: 1}, 0.3, {ease: FlxEase.quadInOut});
		// coolText.y += coolThingie;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	var skippedIntro:Bool = false;

	var timeOfSign:Int = 0;

	override function beatHit()
	{
		super.beatHit();

		// FlxTween.tween(followCam, {x: FlxG.width * FlxG.random.float(0.47, 0.53), y: FlxG.height * FlxG.random.float(0.49, 0.51)}, 1, {ease: FlxEase.quadInOut});

		logoBl.animation.play('bump');

		if (FlxG.random.bool(10) && timeOfSign <= 4)
		{
			danceLeft = !danceLeft;

			timeOfSign++;

			if (danceLeft)
				gfDance.animation.play('lightOn');
			else
				gfDance.animation.play('lightOff');
		}

		// in case it flashy
		if (curBeat % 2 == 0)
			timeOfSign--;

		var beatOffset = curBeat - 1;

		if (curBeat > 16)
		{
			if (beatOffset % 2 == 0)
				FlxG.camera.zoom += 0.015;
		}

		timeOfSign = Std.int(MathUtils.clamp(0, 7, timeOfSign));

		FlxG.log.add(curBeat);

		if (!skippedIntro)
		{
			switch (curBeat)
			{
				case 2:
					createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
				// credTextShit.visible = true;
				case 3:
					addMoreText('present');
				// credTextShit.text += '\npresent...';
				// credTextShit.addText();
				case 4:
					deleteCoolText();
				// credTextShit.visible = false;
				// credTextShit.text = 'In association \nwith';
				// credTextShit.screenCenter();
				case 5:
					createCoolText(['Based on', 'the game']);
				case 7:
					// addMoreText('newgrounds');
					silentLogo.visible = true;
				// credTextShit.text += '\nNewgrounds';
				case 8:
					deleteCoolText();
					silentLogo.visible = false;
				// credTextShit.visible = false;

				// credTextShit.text = 'Shoutouts Tom Fulp';
				// credTextShit.screenCenter();
				case 9:
					createCoolText([curWacky[0]]);
				// credTextShit.visible = true;
				case 11:
					addMoreText(curWacky[1]);
				// credTextShit.text += '\nlmao';
				case 12:
					deleteCoolText();
				// credTextShit.visible = false;
				// credTextShit.text = "Friday";
				// credTextShit.screenCenter();
				case 13:
					addMoreText('Friday');
				// credTextShit.visible = true;
				case 14:
					addMoreText('Night');
				// credTextShit.text += '\nNight';
				case 15:
					addMoreText('Funkin'); // credTextShit.text += '\nFunkin';
				case 16:
					credGroup.forEach(function(spr:Dynamic)
					{
						spr.visible = false;
					});
					skipIntro();
					blackScreen.kill();
			}
		}
	}

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			silentLogo.visible = false;

			FlxG.camera.flash(FlxColor.WHITE, 4);
			// remove(credGroup);
			if (curBeat < 16)
			{
				remove(credGroup);
				blackScreen.alpha = 0;
			}
			skippedIntro = true;
		}
	}
}
