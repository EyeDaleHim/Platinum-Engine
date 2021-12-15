package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;

using StringTools;

class SettingsMenu extends MusicBeatState
{
	var curOptions:Array<Dynamic> = GameData.options[0];

	var menuBG:FlxSprite;
	var grpItems:FlxTypedGroup<Alphabet>;

	var curSelected:Int = 1;
	var curCategory:Int = 0;

	var curSelectedValue:Int;
	var selectedValue:Dynamic;
	var dumbBitch:FlxText;
	var valueText:FlxText;

	override function create()
	{
		try
		{
			menuBG = new FlxSprite().loadGraphic(Paths.image('menuBGGreen-SH'));
			// menuBG.color = 0xFFea71fd;
			menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
			menuBG.updateHitbox();
			menuBG.screenCenter();
			menuBG.antialiasing = true;
			add(menuBG);

			grpItems = new FlxTypedGroup<Alphabet>();
			add(grpItems);

			var bottomBG:FlxSprite = new FlxSprite(0, FlxG.height * 0.9).makeGraphic(Std.int(FlxG.width), Std.int(FlxG.height * 0.04), FlxColor.BLACK);
			bottomBG.alpha = 0.6;
			bottomBG.antialiasing = true;
			bottomBG.y = FlxG.height - bottomBG.height;
			add(bottomBG);

			dumbBitch = new FlxText(4, bottomBG.y, FlxG.width, "", Std.int(bottomBG.height - 2));
			dumbBitch.setFormat(GameData.globalFont, Std.int(bottomBG.height - 2), FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE,
				FlxColor.BLACK);
			add(dumbBitch);

			valueText = new FlxText(FlxG.width * 0.8, dumbBitch.y - 36, 0, 32);
			valueText.setFormat(GameData.globalFont, 32, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

			for (i in 0...curOptions.length)
			{
				var songText:Alphabet = new Alphabet(0, (70 * i) + 30, curOptions[i][0], true, false);
				songText.isMenuItem = true;
				songText.targetY = i;
				songText.actPositionMenu = true;
				grpItems.add(songText);
			}

			add(valueText);

			changeSelection();
		}
		catch (e)
		{
			trace(e.message);
		}

		super.create();
	}

	var isOnNum:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.watch.addQuick('category', curCategory);

		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);
		if (controls.ACCEPT)
		{
			if (curCategory == 0 && curSelected != 4)
				changeCategory(curSelected);
			else if (curSelected == 4 && curCategory == 0)
				resetSettings();
		}
		if (controls.BACK)
		{
			if (curCategory == 0)
				FlxG.switchState(new MainMenuState());
			else
				changeCategory(0);
		}

		if (curCategory != 0 && (!controls.RIGHT || !controls.LEFT))
			selectedValue = curOptions[curSelected][3][curSelectedValue];

		dumbBitch.text = curOptions[curSelected][1][curSelectedValue];

		valueText.y = FlxMath.lerp(valueText.y, FlxG.height * 0.8, 0.16 * (60 / Main.framerate));

		if (controls.RIGHT_P && curCategory != 0)
			changeItem(false);
		else if (controls.LEFT_P && curCategory != 0 && curSelectedValue != 0) // this extra condition is the unblight of my existence
			changeItem(true);

		if (curSelected == 5 && curCategory == 1)
		{
			isOnNum = true;

			if (controls.RIGHT && !controls.LEFT)
				selectedValue += 1;
			if (controls.LEFT && !controls.RIGHT)
				selectedValue -= 1;
		}
		else
			isOnNum = false;

		if ((!controls.RIGHT && !controls.LEFT) && isOnNum)
		{
			Settings.save(curOptions[curSelected][2], selectedValue);
		}

		if (curCategory == 0)
			valueText.visible = false;
		else
			valueText.visible = true;

		var textString:String = '';

		if (curCategory != 0)
		{
			if (curOptions[curSelected][3][curSelectedValue - 1] != null)
				textString += '< ';
		}

		if ('$selectedValue'.endsWith('true'))
			textString += 'on';
		else if ('$selectedValue'.endsWith('false'))
			textString += 'off';
		else
			textString += selectedValue;

		if ('$selectedValue' == 'combo calculation')
			valueText.x = FlxG.width * 0.65;
		else
			valueText.x = FlxG.width * 0.8;

		if (curCategory != 0)
		{
			if (curOptions[curSelected][3][curSelectedValue + 1] != null)
				textString += ' >';
		}

		valueText.text = textString.toUpperCase();
	}

	function resetSettings():Void
	{
		Settings.reset(null, true);

		FlxTween.cancelTweensOf(menuBG);
		menuBG.color = FlxColor.RED;

		FlxTween.color(menuBG, 0.7, FlxColor.RED, 0xFFea71fd, {ease: FlxEase.expoOut});
	}

	function changeItem(back:Bool):Void
	{
		if (curCategory == 0)
			return;

		if (curSelectedValue >= curOptions[curSelected][3].length - 1)
			curSelectedValue = 0;
		else if (curSelectedValue < 0 || curSelectedValue == -1)
			curOptions[curSelected][3].length - 1;
		else
		{
			if (!back)
				curSelectedValue++;
			else
				curSelectedValue--;
		}

		if (curSelectedValue == -1)
			curOptions[curSelected][3].length - 1;

		// prevent soft-lock crashes
		var looped:Int = 0;

		while (curOptions[curSelected][3][curSelectedValue] == null)
		{
			looped++;

			curOptions[curSelected][2] = curOptions[curSelected][3][curSelectedValue];

			if (curOptions[curSelected][3][curSelectedValue] != null || looped >= 20)
				break;
		}

		curOptions[curSelected][2] = curOptions[curSelected][3][curSelectedValue];
		// Type.getClass(curOptions[curSelected][3][curSelectedValue])

		Settings.oldSave(curOptions[curSelected][3][curSelectedValue], curOptions[curSelected][6]);
	}

	function changeCategory(category:Int = 0):Void
	{
		curOptions = GameData.options[category];
		curCategory = category;

		grpItems.clear();

		for (i in 0...curOptions.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, curOptions[i][0], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			songText.actPositionMenu = true;
			grpItems.add(songText);
		}

		curSelected = 1;

		changeSelection();
	}

	function changeSelection(change:Int = 0):Void
	{
		if (curSelected != 0)
		{
			if (FlxG.save.data.soundVolume > 0.4)
				FlxG.sound.play(Paths.sound('scrollMenu_SH'), 0.4);
			else
				FlxG.sound.play(Paths.sound('scrollMenu_SH'), FlxG.save.data.soundVolume);
		}

		curSelected += change;

		valueText.y -= 36;

		if (curSelected == 0)
			curSelected = curOptions.length;
		if (curSelected >= curOptions.length)
			curSelected = 1;

		if (curCategory != 0)
		{
			for (i in 0...curOptions[curSelected][3].length)
			{
				if (curOptions[curSelected][3][i] == curOptions[curSelected][2])
					curSelectedValue = i;
			}
		}

		var bullShit:Int = 0;

		for (item in grpItems.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (item.text != 'gameplay settings')
			{
				item.alpha = 0.6;
				item.selected = false;
			}

			if (item.targetY == 0)
			{
				item.selected = true;
				item.alpha = 1;
			}
		}
	}
}
