package;

#if desktop
import Discord.DiscordClient;
#end
import GameData.MenuStyles;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.TransitionData;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import lime.utils.Assets;

using StringTools;

// might do this shit later: import flixel.addons.display.FlxBackdrop;
// import io.newgrounds.NG;
class MainMenuState extends MusicBeatState
{
	public static var lastSelected:Int = 0;

	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];

	var magenta:FlxSprite;

	public static var camFollow:FlxObject;

	override function create()
	{
		Settings.init();

		initData();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(GameData.globalMusic);
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG-SH'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.15;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBGMagneta-SH'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.15;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			switch (GameData.menuStyle)
			{
				case MenuStyles.LEFT:
					menuItem.x -= 290;
				case MenuStyles.MIDDLE:
					menuItem.screenCenter(X);
				case MenuStyles.RIGHT:
					menuItem.x = 640;
			}
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0.02, 0.02);
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		if (GameData.showVersion)
		{
			var coolString:String = Assets.getText("version/version.txt");

			var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, coolString, 12);
			versionShit.scrollFactor.set();
			versionShit.setFormat(GameData.globalFont, 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			#if tester
			versionShit.text += '-TESTER';
			#end
			add(versionShit);
		}

		// NG.core.calls.event.logEvent('swag').send();

		curSelected = lastSelected;

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		// yourAnim.animation.play('nameOfAnimation');

		if (FlxG.save.data.musicVolume == 100)
		{
			if (FlxG.sound.music.volume < 0.8)
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		else
		{
			if (FlxG.sound.music.volume < FlxG.save.data.musicVolume / 100)
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu_SH'), FlxG.save.data.soundVolume);
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu_SH'), FlxG.save.data.soundVolume);
				changeItem(1);
			}

			/*
				#if debug
				if (controls.RIGHT_P)
				{
					var code:Int = 0;
					
					trace('exited game with code of ' + code);
					Sys.exit(code);
				}
				#end */
			/*if (controls.BACK)
				{
					FlxG.switchState(new TitleState());
			}*/

			if (controls.ACCEPT)
			{
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;

				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu_SH'), FlxG.save.data.soundVolume);

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						var grpShadow:FlxTypedGroup<FlxSprite>;
						grpShadow = new FlxTypedGroup<FlxSprite>();
						insert(members.indexOf(darkenBG) - 1, grpShadow);

						if (curSelected != spr.ID)
						{
							var shadowSprite:FlxSprite = spr.clone();
							shadowSprite.alpha = 0.4;
							shadowSprite.x = spr.x;
							shadowSprite.y = spr.y;
							shadowSprite.scrollFactor.set(spr.scrollFactor.x, spr.scrollFactor.y);
							FlxTween.tween(shadowSprite, {alpha: 0}, 0.8, {ease: FlxEase.quadOut});
							grpShadow.add(shadowSprite);
							
							FlxTween.tween(spr, {alpha: 0, x: spr.x - 100}, 0.8, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});

							
						}

						spr.velocity.x = -10;

						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							FlxG.camera.follow(FreeplayState.camFollow, LOCKON, 0.06 * (60 / Main.framerate));

							var blueBG = new FlxSprite(-30, -30).loadGraphic(Paths.image('menuBGBlue-SH'));
							blueBG.scrollFactor.set(0, 0.05);
							blueBG.setGraphicSize(Std.int(blueBG.width * 1.2));
							blueBG.alpha = 0;
							insert(members.indexOf(darkenBG) - 1, blueBG);

							FlxTween.tween(blueBG, {alpha: 1}, 0.6, {ease: FlxEase.quintOut});

							var daChoice:String = optionShit[curSelected];

							lastSelected = curSelected;

							new FlxTimer().start(0.8, function(tmr:FlxTimer)
							{
								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());
										trace("Freeplay Menu Selected");
									case 'options':
										FlxG.switchState(new SettingsMenu());
								}
							});
						});
					});
				}
			}
		}

		super.update(elapsed);
		if (GameData.menuStyle == MIDDLE)
		{
			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.screenCenter(X);
			});
		}
	}

	function changeItem(change:Int = 0)
	{
		curSelected += change;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				// camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				camFollow.setPosition(FlxG.width * 0.5, spr.getGraphicMidpoint().y);
			}

			if (GameData.menuStyle == MenuStyles.RIGHT)
			{
				if (spr.ID == 0 && spr.animation.curAnim.name == 'selected')
					spr.x = 640 * 0.76;
				else if (spr.ID == 0 && spr.animation.curAnim.name != 'selected')
					spr.x = 640;
			}

			spr.updateHitbox();
		});
	}
}
