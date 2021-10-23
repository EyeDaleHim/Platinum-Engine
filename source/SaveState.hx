package;

import flixel.FlxG;

class SaveState extends MusicBeatState
{
    var state = new SettingsMenu();
    
    public function new()
    {
        super();
       
        FlxG.log.error('SaveState.hx: NOTHIN OVER HERE LOL!!');
        FlxG.switchState(state);
    }
}