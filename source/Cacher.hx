package;

import flixel.FlxG;
import flixel.system.FlxSound;
import lime.utils.AssetCache as LimeCache;
import openfl.utils.AssetCache as OpenFLCache;

using StringTools;

class Cacher
{
    public static function cacheSongs(songs:Array<String>)
    {
        for (x in songs)
        {
            FlxG.sound.cache('songs:assets/songs/' + x.toLowerCase() + '/Inst' + TitleState.soundExt);
            FlxG.sound.cache('songs:assets/songs/' + x.toLowerCase() + '/Voices' + TitleState.soundExt);
            trace('cached ' + 'assets/songs/' + x.toLowerCase() + ' Inst' + ' and ' + 'Voices' + TitleState.soundExt);
        }
    }
}