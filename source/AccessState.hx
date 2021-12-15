package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import haxe.Http;

using StringTools;

class AccessState extends MusicBeatState
{
	var icon:HealthIconOld;
	var whiteIcon:HealthIconOld;
	var text:FlxText;
	var accessText:FlxText;
	var appearString:Bool = false;
	var stringThing:String = '';
	var cooltext:FlxText;
	var expectedString:String = '';

	var http = null;
	var temp = null;

	override function create():Void
	{
		icon = new HealthIconOld('bf', true);
		icon.screenCenter();
		// icon.y -= 120;
		icon.alpha = 0;

		whiteIcon = new HealthIconOld('bf', true);
		whiteIcon.screenCenter();
		whiteIcon.alpha = 0;
		whiteIcon.setColorTransform(1, 1, 1, 1, 255, 255, 255, 1);

		text = new FlxText(0, 0, 0, "ACCESS CODE", 36);
		text.setFormat(GameData.globalFont, 36, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		text.alpha = 0;
		text.screenCenter();

		cooltext = new FlxText(0, 0, 0, "WAITING", 36);
		cooltext.setFormat(GameData.globalFont, 36, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		cooltext.screenCenter();
		cooltext.y += 220;

		accessText = new FlxText(0, 0, 0, "", 42);
		accessText.setFormat(Paths.font("vcr"), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		accessText.alpha = 0;
		accessText.screenCenter();
		accessText.alignment = CENTER;

		FlxTween.tween(icon, {y: icon.y - 170}, 0.6, {ease: FlxEase.quadInOut, startDelay: 0.5});
		FlxTween.tween(icon, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});

		FlxTween.tween(text, {y: text.y - 120}, 0.6, {ease: FlxEase.quadInOut, startDelay: 0.8});
		FlxTween.tween(text, {alpha: 1}, 0.4, {ease: FlxEase.quadInOut, startDelay: 0.9});

		FlxTween.tween(accessText, {alpha: 1}, 0.4, {ease: FlxEase.quadInOut, startDelay: 1.1});

		add(whiteIcon);
		add(icon);
		add(text);
		add(cooltext);
		add(accessText);

		http = new Http("https://pastebin.com/raw/ywgfx3tc");

		http.onData = function(data:String)
		{
			expectedString = data.toLowerCase();
		}

		http.onError = function(error)
		{
			text.text = error;
			text.color = FlxColor.RED;
			new FlxTimer().start(3, function(tmr:FlxTimer)
			{
				#if cpp
				Sys.exit(0);
				#end
			});
		}

		http.request();

		new FlxTimer().start(0.7, function(tmr:FlxTimer)
		{
			appearString = !appearString;
		}, 0);
	}

	var preventKey:Array<Int> = [-1, 8, 9, 13, 18, 16, 17, 45, 46, 222, 220, 186, 191, 20, 219, 221, 27];
	var numbers:Array<String> = ['ONE', 'TWO', 'THREE', 'FOUR', 'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE', 'ZERO'];
	var numberShift:Array<String> = ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')'];
	var wasSucceed:Bool = false;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!appearString)
			accessText.screenCenter();

		#if debug
		if (FlxG.keys.justPressed.F7)
		{
			if (FlxG.keys.pressed.SHIFT)
				FlxG.switchState(new MainMenuState());
		}
		#end

		if (FlxG.sound.music.playing)
		{
			if (FlxG.sound.music != null)
				Conductor.songPosition = FlxG.sound.music.time;
		}

		var keyPress = FlxG.keys.firstJustPressed();

		if (!preventKey.contains(FlxG.keys.firstJustPressed()) && stringThing.length <= 20)
		{
			var noAccess:Bool = false;

			for (i in 0...12)
			{
				var checkup:String = '';
				for (j in 0...1)
				{
					switch (j)
					{
						case 0:
							checkup = 'F' + Std.string(i);
						case 1:
							checkup = 'PAGE';
					}
				}

				if (FlxKey.toStringMap.get(keyPress).startsWith(checkup))
				{
					noAccess = true;
					break;
				}
			}

			if (!noAccess)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), FlxG.save.data.soundVolume);
				if (numbers.contains(FlxKey.toStringMap.get(keyPress)))
				{
					for (i in 0...numbers.length)
					{
						if (numbers[i] == FlxKey.toStringMap.get(keyPress))
						{
							if (FlxG.keys.pressed.SHIFT)
							{
								stringThing += numberShift[i];
							}
							else
							{
								if (numbers[i] == 'ZERO')
								{
									stringThing += '0';
									break;
								}
								else
								{
									stringThing += Std.string(i + 1);
								}
							}
						}
					}
					accessText.screenCenter();
				}
				else
				{
					if (FlxKey.toStringMap.get(keyPress) == SPACE)
						stringThing += ' ';
					else if (FlxKey.toStringMap.get(keyPress) == MINUS)
					{
						if (FlxG.keys.pressed.SHIFT)
							stringThing += '_';
						else
							stringThing += '-';
					}
					else if (FlxKey.toStringMap.get(keyPress) == PLUS)
					{
						if (FlxG.keys.pressed.SHIFT)
							stringThing += '=';
						else
							stringThing += '+';
					}
					else if (FlxKey.toStringMap.get(keyPress) == PERIOD)
					{
						if (FlxG.keys.pressed.SHIFT)
							stringThing += '>';
						else
							stringThing += '.';
					}
					else if (FlxKey.toStringMap.get(keyPress) == COMMA)
					{
						if (FlxG.keys.pressed.SHIFT)
							stringThing += '<';
						else
							stringThing += ',';
					}
					else if (FlxKey.toStringMap.get(keyPress) == GRAVEACCENT)
					{
						if (FlxG.keys.pressed.SHIFT)
							stringThing += '~';
						else
							stringThing += '`';
					}
					else
						stringThing += FlxKey.toStringMap.get(keyPress);
					accessText.screenCenter();
				}
			}
		}

		accessText.text = stringThing;

		if (FlxG.keys.justPressed.BACKSPACE)
		{
			stringThing = stringThing.substring(0, stringThing.length - 1);
			accessText.screenCenter();
		}

		var stringie:String = '';

		whiteIcon.x = icon.x;
		whiteIcon.y = icon.y;
		whiteIcon.alpha = icon.alpha;
		whiteIcon.scale.x = icon.scale.x + 0.02;
		whiteIcon.scale.y = icon.scale.y + 0.02;

		if (appearString)
			accessText.text += '|';

		if ((stringThing.length >= 20 || FlxG.keys.justPressed.ENTER) && !wasSucceed)
		{
			if (stringThing.toLowerCase() == expectedString)
			{
				wasSucceed = true;
				FlxG.sound.play(Paths.sound('confirmMenu'), FlxG.save.data.soundVolume);
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					FlxG.switchState(new MainMenuState());
				});
			}
			else
			{
				FlxG.resetState();
			}
		}
	}

	override function beatHit():Void
	{
		super.beatHit();

		icon.scale.x = 1;
		icon.scale.y = 1;

		FlxTween.tween(icon.scale, {x: 1.15, y: 1.15}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}
}
