package;

import flixel.FlxG;
import flixel.math.FlxMath;

class ScoreFunctions
{
    public static function calculateScore(ratings:String, factor:Float = 0):Int
        {
            var practiceMode:Bool = false;
            
            // your score will be subtracted by the hit window of the note
            var newScore:Float = 0;
            var roundedScore:Int = 0;
            
            switch (ratings)
            {
                // this was made higher because your rating score gets subtracted by the factor
                case 'sick': 
                    newScore = 450;
                case 'good':
                    newScore = 325;
                case 'bad':
                    newScore = 200;
                case 'shit':
                    newScore = 125;
                default:
                    // its a bad idea to add misses because its WAYYYY over the safe time zone.
                    newScore = 0;
            }
            if (factor < 0)
            {
                factor = -factor;
            }
            
            newScore = (newScore - factor);
    
            roundedScore = Std.int(newScore);
            trace(roundedScore + ' note ' + ratings);

            // always subtract by 25 if rating is miss
            if (ratings == 'miss')
                roundedScore = 25;

            if (practiceMode)
                roundedScore = 0;
    
            return roundedScore;
        }
        public static function calculateHeld(ratings:String, factor:Float):Int
        {
            // your score will be subtracted by the hit window of the note
            var newScore:Float = 0;
            var roundedScore:Int = 0;
                    
            switch (ratings)
            {
                // this was made higher because your rating score gets subtracted by the factor
                case 'sick': 
                    newScore = 450 * 0.75;
                case 'good':
                    newScore = 325 * 0.75;
                // idc if you get negative score cuz fuk you
                case 'bad':
                    newScore = 200 * 0.75;
                case 'shit':
                    newScore = 125 * 0.75;
                default:
                    newScore = 0;
            }

            if (factor < 0)
                {
                    factor = -factor;
                }
                
            newScore = (newScore - factor);

            roundedScore = Std.int(newScore);
            trace(roundedScore + ' held ' + ratings);
            
            return roundedScore;
        }
}