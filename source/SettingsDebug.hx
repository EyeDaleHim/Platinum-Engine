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

class SettingsDebug extends MusicBeatState
{
    var curOptions:Array<String> = ['create steps', ''];
    var grpItems:FlxTypedGroup<Alphabet>;

    override function create()
    {
        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

        grpItems = new FlxTypedGroup<Alphabet>();
		add(grpItems);

        var noteTxt:FlxText = new FlxText(FlxG.width, 0, 0, "Debug settings will not be saved,
        only your options will be saved in the console log.", 24);
        noteTxt.x -= noteTxt.height - 4;
        noteTxt.setFormat("assets/fonts/vcr.ttf", 24, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(noteTxt);

        for (i in 0...curOptions.length)
            {
                var songText:Alphabet = new Alphabet(0, (70 * i) + 30, curOptions[i], true, false);
                songText.isMenuItem = true;
                songText.targetY = i;
                grpItems.add(songText);
            }
    }
    override function update(elapsed:Float)
    {
        var upP = controls.UP_P;
        var downP = controls.DOWN_P;
        var accepted = controls.ACCEPT;
        var back = controls.BACK;

        if (back)
            FlxG.switchState(new SettingsMenu());
    }
}