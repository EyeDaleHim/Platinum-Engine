class AccuracyHelper
{
	public static function wif3(maxms:Float, ts:Float)
	{
		// not renaming
		var max_points = 1.0;
		var miss_weight = -5.5;
		var ridic = 5;
		var max_boo_weight = 180;
		var ts_pow = 0.75;
		var zero = 65 * (Math.pow(1, ts_pow));
		var power = 2.5;
		var dev = 22.7 * (Math.pow(1, ts_pow));

		if (maxms <= ridic)
			return max_points;
		else if (maxms <= zero)
			return max_points * MathUtils.erf((zero - maxms) / dev);
		else if (maxms <= max_boo_weight)
			return (maxms - zero) * miss_weight / (max_boo_weight - zero);
		else
			return miss_weight;

		return 0;
	}

	/*
    public static function stepmania(ms:Float, ts:Float, judge:String)
    {
        var multiplier1:Float = 0;
		var multiplier2:Float = 0;
		var
		
		switch (judge)
		{
			

		}
    }*/
    
}
