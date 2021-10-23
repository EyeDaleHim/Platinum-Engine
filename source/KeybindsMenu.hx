package;

import flixel.FlxG;

class KeybindsMenu extends MusicBeatState
{
    public function new()
    {
        super();
        FlxG.log.error('KeybindsMenu.hx: NOTHIN OVER HERE LOL!!');
        FlxG.switchState(new SettingsMenu());
    }
}