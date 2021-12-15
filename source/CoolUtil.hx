package;

import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function difficultyString():String
	{		
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function matchWordPercentage(string:String, matchingString:String):Float
	{
		var value:Float = 0;
		
		if (string == matchingString)
			value = 100;

		for (i in 0...string.length)
		{
			if (string.charAt(i) == matchingString.charAt(i))
				value++;
		}
		
		return (value / matchingString.length) * 100;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function isNullOrEmpty(string:String):Bool
	{
		if (string == null || string == '' || string == "")
			return true;

		return false;
	}

	public static function takeOutDuplicate<T>(array:Array<T>) {
        var l = [];
        for (v in array) {
         	if (l.indexOf(v) == -1) { // array has not v
            	l.push(v);
            }
         }
        return l;
    }
}
