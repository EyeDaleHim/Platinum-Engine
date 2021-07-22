package;

import flixel.util.FlxColor;

using StringTools;

class CharacterColor
{
	public static function color(char:String)
	{
		var color:FlxColor;

		/* Use these if you are using multiple characters that begins
		* with the same name.
		**/
		if (char.startsWith('bf'))
			color = 0xFF5AB6E4;
		else if (char.startsWith('gf'))
			color = 0xFFD30062;
		else if (char.startsWith('monster'))
			color = 0xFFF3FF6E;
		else if (char.startsWith('mom'))
			color = 0xFFD63178;
        else if (char.startsWith('parents'))
            color = 0xFF9A2697;
        else if (char.startsWith('senpai'))
            color = 0xFFFF8432;
		else
		{
			// Otherwise, use these.
			switch (char)
			{
				case 'dad':
					color = 0xFF8E2FB7;
				case 'spooky':
					color = 0xFF385439;
                case 'pico':
                    color = 0xFF8CFF00;
                case 'spirit':
                    color = FlxColor.RED;
                case 'tankman':
                    color = 0xFFCC922E;				
                default:
					color = 0xFFFF0000;
			}
		}

		return color;
	}
}