package;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.graphics.FlxGraphic;
import flixel.util.typeLimit.OneOfTwo;
import lime.utils.AssetCache as LimeCache;
import openfl.utils.AssetCache as OpenFLCache;
import openfl.display.BitmapData;

using StringTools;

enum AssetType
{
	AUDIO;
	IMAGE;
}

typedef Caching = OneOfTwo<FlxSound, FlxGraphic>;

class AssetCaching
{
	// didn't feel like putting them all in one stuff
	public static var imageCache:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();
	public static var audioCache:Map<String, FlxSound> = new Map<String, FlxSound>();

	public static function add(path:String, type:AssetType):Void
	{
		switch (type)
		{
			case IMAGE:
				var data:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromFile(path));
				data.persist = true;

				imageCache.set(path, data);
			case AUDIO:
				var data:FlxSound = new FlxSound().loadEmbedded(path);

				FlxG.sound.cache(Paths.inst(path));

				audioCache.set(path, data);
		}
	}

	public static function get(path:String, type:AssetType):Caching
	{
		switch (type)
		{
			case IMAGE:
				return imageCache.get(path);
			case AUDIO:
				return audioCache.get(path);
		}
		return null;
	}

	public static function exists(path:String, type:AssetType):Bool
	{
		switch (type)
		{
			case IMAGE:
				return imageCache.exists(path);
			case AUDIO:
				return audioCache.exists(path);
		}
        return false;
	}
}
