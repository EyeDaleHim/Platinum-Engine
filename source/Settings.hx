package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.util.typeLimit.OneOfFour;

enum Quality
{
	LOW;
	MEDIUM;
	HIGH;
}

typedef SaveStrings = OneOfFour<String, Float, Int, Bool>;

class Settings
{
	public static var saveData:FlxSave;

	public static var downscroll:Bool;
	public static var accuracy:String;
	public static var ghostTap:Bool;
	public static var scoreType:String;
	public static var noteOffset:Float;

	public static var quality:String;
	public static var antialiasing:Bool;
	public static var vfxEffects:Bool;
	public static var animFreq:String;

	public static var musicVolume:Float;
	public static var soundVolume:Float;
	public static var vocalVolume:Float;

	public static var upBind:String;
	public static var downBind:String;
	public static var leftBind:String;
	public static var rightBind:String;
	// note that botplay is not a changeable
	public static var botplay:Bool;
	public static var useDefaults:Bool;

	public static function init()
	{
		/*
			saveData = new FlxSave();

			saveData.bind(); */

		// tip: always initialize before saving settings
		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;
		if (FlxG.save.data.accuracy == null)
			FlxG.save.data.accuracy = 'simple';
		if (FlxG.save.data.ghostTap == null)
			FlxG.save.data.ghostTap = false;
		if (FlxG.save.data.scoreType == null)
			FlxG.save.data.scoreType = 'old';
		if (FlxG.save.data.noteOffset == null)
			FlxG.save.data.noteOffset = 0;

		if (FlxG.save.data.quality == null)
			FlxG.save.data.quality == 'medium';
		if (FlxG.save.data.antialiasing == null)
			FlxG.save.data.antialiasing = true;
		if (FlxG.save.data.vfxEffects == null)
			FlxG.save.data.vfxEffects = true;
		if (FlxG.save.data.animFreq == null)
			FlxG.save.data.animFreq = 'maximum';

		if (FlxG.save.data.musicVolume == null)
			FlxG.save.data.musicVolume = 100;
		if (FlxG.save.data.soundVolume == null)
			FlxG.save.data.soundVolume = 100;
		if (FlxG.save.data.vocalVolume == null)
			FlxG.save.data.vocalVolume = 100;

		if (FlxG.save.data.upBind == null && FlxG.save.data.downBind == null && FlxG.save.data.leftBind == null && FlxG.save.data.rightBind == null
			&& FlxG.save.data.resetBind == null)
		{
			useDefaults = true;
			trace('lol its a success what a chad');
		}
		/*
			if (FlxG.save.data.upBind == null)
				FlxG.save.data.upBind = W;
			if (FlxG.save.data.downBind == null)
				FlxG.save.data.downBind = S;
			if (FlxG.save.data.leftBind == null)
				FlxG.save.data.leftBind = A;
			if (FlxG.save.data.rightBind == null)
				FlxG.save.data.rightBind = D;
			if (FlxG.save.data.resetBind == null)
				FlxG.save.data.resetBind = R;
		*/

		downscroll = FlxG.save.data.downscroll;
		accuracy = FlxG.save.data.accuracy;
		ghostTap = FlxG.save.data.ghostTap;
		scoreType = FlxG.save.data.scoreType;
		noteOffset = FlxG.save.data.noteOffset;
		Conductor.offset = noteOffset;

		quality = FlxG.save.data.quality;
		antialiasing = FlxG.save.data.antialiasing;
		vfxEffects = FlxG.save.data.vfxEffects;
		animFreq = FlxG.save.data.animFreq;

		musicVolume = FlxG.save.data.musicVolume;
		soundVolume = FlxG.save.data.soundVolume;
		vocalVolume = FlxG.save.data.vocalVolume;

		upBind = FlxG.save.data.upBind;
		downBind = FlxG.save.data.downBind;
		leftBind = FlxG.save.data.leftBind;
		rightBind = FlxG.save.data.rightBind;

		#if desktop
		trace('GAMEPLAY:');
		trace([downscroll, accuracy, ghostTap, scoreType, noteOffset]);
		trace('GRAPHICS:');
		trace([quality, antialiasing, vfxEffects, animFreq]);
		trace('SOUNDS:');
		trace([musicVolume, soundVolume, vocalVolume]);
		trace('KEYBINDS:');
		trace([leftBind, downBind, upBind, rightBind]);
		#end
	}

	public static function resetKeys():Void
	{
		FlxG.save.data.upBind = "W";
		FlxG.save.data.downBind = "S";
		FlxG.save.data.leftBind = "A";
		FlxG.save.data.rightBind = "D";
		FlxG.save.data.killBind = "R";
	}

	public static function save(data:Dynamic, toBeSaved:Dynamic):Void
	{
		if (data == null || toBeSaved == null)
		{
			FlxG.log.error(data + ' or ' + toBeSaved + ' are null!');
			return;
		}

		trace(data);
		data = toBeSaved;

		FlxG.save.flush();

		trace(data);
	}

	public static function oldSave(setting:Dynamic, target:String, ?keyBind:String = ''):Void
	{
		var coolBool:Bool = false;
		var coolString:String = '';
		var coolFloat:Float = 0;

		if ((setting is Bool))
			coolBool = setting;
		if ((setting is String))
			coolString = setting;
		if ((setting is Float))
			coolFloat = setting;
		switch (target)
		{
			case 'downscroll':
				FlxG.save.data.downscroll = coolBool;
				downscroll = FlxG.save.data.downscroll;
			case 'accuracy':
				FlxG.save.data.accuracy = coolString;
				accuracy = FlxG.save.data.accuracy;
			case 'ghostTap':
				FlxG.save.data.ghostTap = coolBool;
				ghostTap = FlxG.save.data.ghostTap;
			case 'scoreType':
				FlxG.save.data.scoreType = coolString;
				scoreType = FlxG.save.data.ghostTap;
			case 'noteOffset':
				FlxG.save.data.noteOffset = coolFloat;
				noteOffset = coolFloat;
				Conductor.offset = noteOffset;
			case 'quality':
				FlxG.save.data.quality = coolString;
				quality = FlxG.save.data.quality;
			case 'antialiasing':
				FlxG.save.data.antialiasing = coolBool;
				antialiasing = FlxG.save.data.antialiasing;
			case 'vfxEffects':
				FlxG.save.data.vfxEffects = coolBool;
				vfxEffects = FlxG.save.data.vfxEffects;
			case 'animFreq':
				FlxG.save.data.animFreq = coolString;
				animFreq = FlxG.save.data.animFreq;
			case 'musicVolume':
				FlxG.save.data.musicVolume = coolFloat;
				musicVolume = FlxG.save.data.musicVolume;
			case 'soundVolume':
				FlxG.save.data.soundVolume = coolFloat;
				soundVolume = FlxG.save.data.soundVolume;
			case 'vocalVolume':
				FlxG.save.data.vocalVolume = coolFloat;
				vocalVolume = FlxG.save.data.vocalVolume;
			case 'keyBinds':
				if (keyBind == 'up')
					FlxG.save.data.upBind = setting;
				else if (keyBind == 'down')
					FlxG.save.data.downBind = setting;
				else if (keyBind == 'left')
					FlxG.save.data.leftBind = setting;
				else if (keyBind == 'right')
					FlxG.save.data.rightBind = setting;
		}

		FlxG.save.flush();
		#if debug
		trace("Setting " + target + " has been saved with value of " + setting);
		#end
	}

	public static function reset(target:String, all:Bool = false)
	{
		if (!all)
		{
			switch (target)
			{
				case 'downscroll':
					FlxG.save.data.downscroll = false;
				case 'ghostTap':
					FlxG.save.data.ghostTap = false;
				case 'accuracy':
					FlxG.save.data.accuracy = 'none';
				case 'scoreType':
					FlxG.save.data.scoreType = 'old';
				case 'quality':
					FlxG.save.data.quality = 'medium';
				case 'antialiasing':
					FlxG.save.data.antialiasing = true;
				case 'volume':
					FlxG.save.data.musicVolume = 1;
					FlxG.save.data.soundVolume = 1;
					FlxG.save.data.vocalVolume = 1;
			}

			trace('reset ' + target);
		}
		else
		{
			// nullfying them doesnt work fuck you
			FlxG.save.data.downscroll = false;
			FlxG.save.data.ghostTap = false;
			FlxG.save.data.accuracy = 'none';
			FlxG.save.data.scoreType = 'old';
			FlxG.save.data.quality = 'medium';
			FlxG.save.data.antialiasing = true;
			FlxG.save.data.noteOffset = Conductor.offset = 0;
			FlxG.save.data.vfxEffects = true;
			FlxG.save.data.animFreq = 'maximum';
			FlxG.save.data.musicVolume = 100;
			FlxG.save.data.soundVolume = 100;
			FlxG.save.data.vocalVolume = 100;

			trace('reset all');
		}
	}
}
