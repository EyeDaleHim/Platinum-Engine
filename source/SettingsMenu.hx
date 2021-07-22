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

class SettingsMenu extends MusicBeatState
{
    var category:String = 'none';

    var curOptions:Array<String> = ['options', 'gameplay', 'graphics', 'sounds'];

    var curSelected:Int = 0;
    var grpItems:FlxTypedGroup<Alphabet>;
    var coolString:String = "";
    var dumbBitch:FlxText;
    var blackScreen:FlxSprite;
    
    override function create()
    {   
        // why doesnt it work tho
        blackScreen = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        blackScreen.scrollFactor.set();
        
        Settings.init();

        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

        grpItems = new FlxTypedGroup<Alphabet>();
		add(grpItems);

        var bottomBG:FlxSprite = new FlxSprite(0, FlxG.height * 0.9).makeGraphic(Std.int(FlxG.width), Std.int(FlxG.height * 0.04), FlxColor.BLACK);
        bottomBG.alpha = 0.6;
        bottomBG.antialiasing = true;
        bottomBG.y = FlxG.height - bottomBG.height;
        add(bottomBG);

        dumbBitch = new FlxText(4, bottomBG.y, FlxG.width, "", Std.int(bottomBG.height - 2));
        dumbBitch.setFormat("assets/fonts/vcr.ttf", Std.int(bottomBG.height - 2), FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(dumbBitch);

        for (i in 0...curOptions.length)
            {
                var songText:Alphabet = new Alphabet(0, (70 * i) + 30, curOptions[i], true, false);
                songText.isMenuItem = true;
                songText.targetY = i;
                grpItems.add(songText);
            }
        add(blackScreen);

        super.create();
    }

    function changeCategory(category:String)
        {
            this.category = category;

            switch (category)
            {
                case 'gameplay':
                    curOptions = ['ghost tapping', 'new inputs', 'accuracy mode'];
                default:
                    curOptions = ['options', 'gameplay', 'graphics', 'sounds'];
            }
        }

    function changeSelection(change:Int = 0)
        {
            var coolCategory:String = 'none';

            coolCategory = this.category;

            trace(coolCategory);
            
            if (curSelected != 0)
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
    
            curSelected += change;
    
            if (curSelected < 1)
                curSelected = curOptions.length - 1;
            if (curSelected >= curOptions.length)
                curSelected = 1;
    
            var bullShit:Int = 0;
    
            for (item in grpItems.members)
            {
                item.targetY = bullShit - curSelected;
                bullShit++;

                switch (curSelected)
                {
                    case 1:
                        coolString = "Change the way you play your games.";
                    case 2:
                        coolString = "Change the way your games look.";
                    case 3:
                        coolString = "Change the way of how you hear the game's sounds.";
                }
    
                if (item.text != 'options')
                {
                    item.alpha = 0.6;
                    item.selected = false;
                }
    
                if (item.targetY == 0)
                {
                    item.selected = true;
                    item.alpha = 1;
                }
            }
        }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        dumbBitch.text = coolString;

        blackScreen.alpha -= 0.8472 * (elapsed / blackScreen.alpha);
        
        var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
        var back = controls.BACK;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP || curSelected == 0)
		{
			changeSelection(1);
		}
        if (back)
            FlxG.switchState(new MainMenuState());
        if (accepted)
        {
            switch (curSelected)
            {
                case 1:
                    FlxG.switchState(new SettingsGameplay());
                case 2:
                    changeCategory('graphics');
                case 3:
                    changeCategory('sounds');
            }
        }
    }
}