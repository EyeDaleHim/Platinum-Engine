package;

import flixel.FlxG;
import flixel.math.FlxMath;

class SongFunctions
{
    public static function calculateScore(ratings:String, factor:Float = 0):Int
        {
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
                    newScore = 75;
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
            trace(roundedScore);

            // always subtract by 25 if rating is miss
            if (ratings == 'miss')
                roundedScore = -25;
    
            return roundedScore;
        }
        public static function calculateHeld(ratings:String):Int
        {
            // your score will be subtracted by the hit window of the note
            var newScore:Float = 0;
            var roundedScore:Int = 0;
                    
            switch (ratings)
            {
                // this was made higher because your rating score gets subtracted by the factor
                case 'sick': 
                    newScore = 35;
                case 'good':
                    newScore = 20;
                case 'bad':
                    newScore = 5;
                case 'shit':
                    newScore = 0;
                default:
                    newScore = 0;
            }
            roundedScore = Std.int(newScore);
            trace(roundedScore);
            
            return roundedScore;
        }
}