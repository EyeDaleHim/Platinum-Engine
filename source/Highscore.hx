package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	#end

	public static var songAccuracy:Map<String, Float> = new Map<String, Float>();


	public static function saveAccuracy(song:String, accuracy:Float = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songAccuracy.exists(daSong))
		{
			if (songAccuracy.get(daSong) < accuracy)
				setAccuracy(daSong, accuracy);
		}
		else
			setAccuracy(daSong, accuracy);
	}
	
	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong('week' + week, diff);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	public static function saveWeekAccuracy(week:Int = 1, accuracy:Float = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong('week' + week, diff);

		if (songAccuracy.exists(daWeek))
		{
			if (songAccuracy.get(daWeek) < accuracy)
				setAccuracy(daWeek, accuracy);
		}
		else
			setAccuracy(daWeek, accuracy);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setAccuracy(song:String, accuracy:Float):Void
	{
		songAccuracy.set(song, accuracy);
		FlxG.save.data.songAccuracy = songAccuracy;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);

		return songScores.get(formatSong(song, diff));
	}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		if (!songScores.exists(formatSong('week' + week, diff)))
			setScore(formatSong('week' + week, diff), 0);

		return songScores.get(formatSong('week' + week, diff));
	}

	public static function getAccuracy(song:String, diff:Int):Float
	{
		if (!songAccuracy.exists(formatSong(song, diff)))
			setAccuracy(formatSong(song, diff), 0);

		return songAccuracy.get(formatSong(song, diff));
	}

	public static function getWeekAccuracy(week:Int, diff:Int):Float
	{
		if (!songAccuracy.exists(formatSong('week' + week, diff)))
			setAccuracy(formatSong('week' + week, diff), 0);

		return songAccuracy.get(formatSong('week' + week, diff));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
			songScores = FlxG.save.data.songScores;
	}
}