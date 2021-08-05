package;

import flixel.FlxG;

class Settings
{
    public static var downscroll:Bool;
    public static var accuracy:String;
    public static var ghostTap:Bool;
    public static var scoreType:String;
    public static var upBind:String;
    public static var downBind:String;
    public static var leftBind:String;
    public static var rightBind:String;
    // note that botplay is not a changeable
    public static var botplay:Bool;
    public static var useDefaults:Bool;
    
    // i kinda forgot what inline does but it just works
    inline public static function init()
    {
        // tip: always initialize before saving settings
        if (FlxG.save.data.downscroll == null)
            FlxG.save.data.downscroll = false;
        if (FlxG.save.data.accuracy == null)
            FlxG.save.data.accuracy = 'simple';
        if (FlxG.save.data.ghostTap == null)
            FlxG.save.data.ghostTap = false;
        if (FlxG.save.data.scoreType == null)
            FlxG.save.data.scoreType = 'old';
        if (FlxG.save.data.upBind == null && FlxG.save.data.downBind == null && FlxG.save.data.leftBind == null && FlxG.save.data.rightBind == null && FlxG.save.data.resetBind == null)
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
        upBind = FlxG.save.data.upBind;
        downBind = FlxG.save.data.downBind;
        leftBind = FlxG.save.data.leftBind;
        rightBind = FlxG.save.data.rightBind;

        trace(downscroll); 
        trace(accuracy);
        trace(ghostTap);
        trace(upBind); 
        trace(downBind);
        trace(leftBind);
        trace(rightBind);
    }

    public static function resetKeys():Void
    {
        FlxG.save.data.upBind = "W";
        FlxG.save.data.downBind = "S";
        FlxG.save.data.leftBind = "A";
        FlxG.save.data.rightBind = "D";
        FlxG.save.data.killBind = "R";
    }
    
    public static function save(setting:Dynamic, target:String, ?keyBind:String = ''):Void
    {
        // make sure setting is the right type as target or we face issues :(

        var coolBool:Bool = false;
        var coolString:String = '';

        if ((setting is Bool))
        {
            coolBool = setting;
        }
        if ((setting is String))
        {
            coolString = setting;
        }
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
        trace("Setting " + target + " has been saved with value of " + setting);
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

            trace('reset all');
        }
    }
}