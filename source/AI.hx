package;

import flixel.FlxG;
import flixel.math.FlxMath;

class Finger
{
	public var noteData:Int;
	public var tiredness:Float;

	public function new(noteData:Int)
	{
		this.noteData = noteData;
	}
}

class AI
{
	public static var directionList:Array<Finger> = [];
	public static var leftHand1:Finger = new Finger(0); // left middle finger
	public static var leftHand2:Finger = new Finger(1); // left index finger
	public static var rightHand1:Finger = new Finger(2); // right index finger
	public static var rightHand2:Finger = new Finger(3); // right middle finger

	// plz dont access this lol
	public static var closestNotes:Array<Note> = []; // limited to just two notes, specifically for current note and last note
	public static var totalHit:Int = 1;

	public static var tirednessScale:Float;

	public static var fakeNoteCreated:Bool = false;

	// this is basically dependent on math and random numbers lol! i might improve later
	// rangeFromFull is the possible accuracy that it hopes to get, not always accurate though!
	public static function calculateHit(note:Note, rangeFromFull:Float = 0.93, tirednessScale:Float, performance:Float):Float
	{
		// V1.0 AI

		directionList = [leftHand1, leftHand2, rightHand1, rightHand2];

		var calculatedNum:Float = 0;

		closestNotes.push(note);

		if (closestNotes.length != 1 && !fakeNoteCreated)
		{
			// create a fake note
			fakeNoteCreated = true;
			closestNotes.push(new Note(closestNotes[0].strumTime + Conductor.stepCrochet, closestNotes[0].noteData, closestNotes[0].prevNote,
				closestNotes[0].isSustainNote));
		}

		if (closestNotes.length >= 3)
		{
			closestNotes.remove(closestNotes[0]);
		}

		// tiredness
		if (closestNotes[0].strumTime <= Conductor.songPosition + Conductor.safeZoneOffset)
		{
			if (closestNotes[1] != null
				&& (closestNotes[1].strumTime <= closestNotes[0].strumTime
					+ (150 * (rangeFromFull + ((PlayState.SONG.bpm / 100) * FlxMath.roundDecimal(PlayState.SONG.speed, 2)))) * 0.7))
			{
				directionList[closestNotes[0].noteData].tiredness += ((150 * (rangeFromFull
					+ (PlayState.nps * 0.6)
					+ ((PlayState.SONG.bpm / 100) * FlxMath.roundDecimal(PlayState.SONG.speed, 2)))) * 0.7) * tirednessScale;

				for (i in 0...directionList.length)
				{
					if (closestNotes[0].noteData != i)
					{
						directionList[i].tiredness += (((150 * (rangeFromFull
							+ (PlayState.nps * 0.6)
							+ ((PlayState.SONG.bpm / 100) * FlxMath.roundDecimal(PlayState.SONG.speed, 2)))) * 0.7) * tirednessScale) / 10;
					}
				}
			}
		}

		var noteThingie:Float;

		if (closestNotes[1] == null)
			noteThingie = Conductor.songPosition; // lowkey i wanna die?
		else
			noteThingie = closestNotes[1].strumTime;

		trace(directionList[closestNotes[0].noteData].tiredness);

		totalHit++;

		return ((((((noteThingie - Conductor.songPosition) * 0.7)
			+ ((PlayState.SONG.bpm / 100) * 0.75)
			+ ((FlxMath.roundDecimal(PlayState.SONG.speed, 2) / 20) * 0.7)
			+ FlxMath.roundDecimal(directionList[closestNotes[0].noteData].tiredness, 5)) * rangeFromFull) * 0.7)
			+ FlxG.random.float(-0.02, 0.02) + ((closestNotes[0].strumTime / (Conductor.stepCrochet * totalHit)) / Conductor.safeZoneOffset)) * performance;
	}

	public static var updateFrames:Int = 0; // how much update has looped

	public static function update(elapsed:Float, tirednessScale:Float)
	{
		if (updateFrames % 12 == 0) // 12 is 120 / 10 lol
		{
			for (i in 0...directionList.length)
			{
				if (directionList[i].tiredness > 0)
				{
					directionList[i].tiredness -= Math.abs(FlxMath.roundDecimal((directionList[i].tiredness / 100) / 4, 4)) * tirednessScale;
				}
			}
		}
		else
		{
			updateFrames++;
		}
	}
}
