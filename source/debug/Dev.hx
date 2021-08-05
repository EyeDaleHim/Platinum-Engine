package debug;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if flash
import openfl.Lib;
#end
class Dev extends TextField
{

	public function new(x:Float = 20, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

        // fock you
        maxChars = 9999;

		defaultTextFormat = new TextFormat("_sans", 12, color);
		text = "Dev Build";
	}
}