package;

import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

class HealthIcon extends FlxSprite
{
    public var animOffsets:Map<String, Array<Dynamic>>;
    
    public var sprTracker:FlxSprite;
	public var id:Int;

	public var defualtIconScale:Float = 1;
	public var iconScale:Float = 1;
	public var iconSize:Float;

    public var char:String = 'bf';
    public var listOfChars:Array<String>;
    public var myExists:Bool;

    var oldIcon:HealthIconOld;

    public function new(char:String = 'bf', isPlayer:Bool = false, bpm:Int = 100)
    {
        super();

        this.char = char;

        var tex:FlxAtlasFrames;
		antialiasing = true;
        scrollFactor.set();

        animOffsets = new Map<String, Array<Dynamic>>();
        listOfChars = ['bf', 'bf-car', 'bf-christmas', 'bf-shadow', 'gf', 'gf-car', 'gf-christmas', 'gf-shadow', 'hank', 'hank-antipathy'];

            switch (char)
            {
                case 'bf' | 'bf-car' | 'bf-christmas' | 'bf-shadow':
                    if (char == 'bf-car' || char == 'bf-christmas' || char == 'bf-shadow')
                    {
                        // defaults to bf, so we dont have to copy lol
                        char = 'bf';
                    }
                    
                    tex = FlxAtlasFrames.fromSparrow('assets/images/animIcon/' + char + '/icon.png', 'assets/images/animIcon/' + char + '/icon.xml');
                    frames = tex;

                    animation.addByPrefix('idle', 'Bf_icon_idle', 24, false);
                    animation.addByPrefix('loss', 'Bf_icon_loss', 24, false);
                    // why is "I" uppercase
                    animation.addByPrefix('won', 'Bf_Icon_won', 24, false);

                    changeMood(0);
                case 'gf' | 'gf-car' | 'gf-christmas' | 'gf-shadow':
                    if (char == 'gf-car' || char == 'gf-christmas' || char == 'gf-shadow')
                            char = 'gf';
                        
                        tex = FlxAtlasFrames.fromSparrow('assets/images/animIcon/' + char + '/icon.png', 'assets/images/animIcon/' + char + '/icon.xml');
                        frames = tex;
    
                        animation.addByPrefix('idle', 'Gf_idle', 24, false);
                        // switch anims because im dumb
                        animation.addByPrefix('won', 'Gf_loss', 24, false);
                        animation.addByPrefix('loss', 'Gf_win', 24, false);
    
                        changeMood(0);
                case 'hank' | 'hank-antipathy':
                    if (char == 'hank-antipathy')
                        char = 'hank';

                    tex = FlxAtlasFrames.fromSparrow('assets/images/animIcon/' + char + '/icon.png', 'assets/images/animIcon/' + char + '/icon.xml');
                    frames = tex;

                    animation.addByPrefix('idle', 'Hank_idle', 24, false);
                    animation.addByPrefix('loss', 'Hank_loss', 24, false);
                    animation.addByPrefix('won', 'Hank_win', 24, false);

                    changeMood(0);
                default:
                    oldIcon = new HealthIconOld(char, isPlayer);
                }
            flipX = isPlayer;
        }

        public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
            {
                animation.play(AnimName, Force, Reversed, Frame);
            }
        
        public function changeMood(mood:Int):Void
        {
            // 0 = idle, 1 = loss, 2 = win
            switch (mood)  
            {
                case 0:
                    playAnim('idle');
                case 1:
                    playAnim('loss');
                case 2:
                    playAnim('won');
            }
        }
        public static function exist(char:String = ""):Bool
        {
            var daExists:Bool;
            var listOfChars:Array<String> = ['bf', 'bf-car', 'bf-christmas', 'bf-shadow', 'hank', 'hank-antipathy'];
            
            if (listOfChars.contains(char))
                daExists = true;
            else
                daExists = false;

            return daExists;
        }
}