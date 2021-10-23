package;

enum LerpTypes
{
	LINEAR;
	EXTRAPOLATION;
}

class MathUtils
{
	// do  whatever you  want with this useless crap lol
    public static var a1 = 0.254829592;
	public static var a2 = -0.284496736;
	public static var a3 = 1.421413741;
	public static var a4 = -1.453152027;
	public static var a5 = 1.061405429;
	public static var p = 0.3275911;

	public static function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	public static function lerp(a:Float, b:Float, ratio:Float, type:LerpTypes):Float
	{
		switch (type)
		{
			case LerpTypes.LINEAR:
				// Normal Lerping
				return a + ratio * (b - a);
			case LerpTypes.EXTRAPOLATION:
				// IDFK  THE FORMULA OK, just broken for now
				return ((a * 1) + (b - (b * 1)) / (b * 2) - ((b * 1) * (a * 2)) - (a * 1)) * ratio;
		}

		return a;
	}

	public static function lcd(a:Float, b:Float):Int
	{
		var absA = Math.abs(a);
		var absB = Math.abs(b);
		var highNum = Math.max(absA, absB);
		var lowNum = Math.min(absA, absB);
		var lcm = lowNum;
		while (lcm % lowNum != 0)
		{
			lcm += highNum;
		}
		return Std.int(lcm);
	}

	public static function isPrime(num:Float):Bool
	{
		var i:Int = 2;
		var daBool:Bool = false;

		while (i <= num / 2)
		{
			if (num % i == 0)
			{
				daBool = true;
				break;
			}

			i++;
		}

		if (!daBool)
			return true;
		else
			return false;
	}

	public static function nearlyEquals(a:Float, b:Float, diff:Float):Bool
	{
		if ((Math.abs(a) - Math.abs(b)) <= diff)
			return true;

		return false;
	}

	public static function clamp(mini:Float, maxi:Float, value:Float):Float {
		return Math.min(Math.max(mini,value), maxi);
	}

	public static function erf(x:Float):Float
	{
		// Save the sign of x
		var sign = 1;
		if (x < 0)
			sign = -1;
		x = Math.abs(x);

		// A&S formula 7.1.26
		var t = 1.0 / (1.0 + p * x);
		var y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * Math.exp(-x * x);

		return sign * y;
	}
}
