package;

import flixel.FlxG;

class AI
{
    public static function hitNote(note:Note, fails:Int, chance:Float):Bool
    {
        var isHit:Bool = FlxG.random.bool(chance + (fails / 10));

        if (note.isSustainNote)
            isHit = true;
        // always set to true if its a sustain note
        
        return isHit;
    }
}