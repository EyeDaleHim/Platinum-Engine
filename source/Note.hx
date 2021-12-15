package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;
using flixel.util.FlxColor;

enum NoteType
{
	NORMAL;
	SEAL;
	HALO;
}

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var formerHeight:Float = 0;

	public var songOffset:Float = 0;

	public var mustPress:Bool = false;
	public var cannotBePressed:Bool = false;
	public var noteData:Int = 0;
	public var noteType:NoteType = NORMAL;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var isOnDaScreen:Bool = false;

	public var sustainLength:Float = 0;
	public var noteYOff:Int = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;

	public function new(strumTime:Float, noteData:Int, ?noteType:NoteType = NORMAL, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;
		this.noteType = noteType;
		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);

					if (isSustainNote)
					{
						loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

						animation.add('purpleholdend', [4]);
						animation.add('greenholdend', [6]);
						animation.add('redholdend', [7]);
						animation.add('blueholdend', [5]);

						animation.add('purplehold', [0]);
						animation.add('greenhold', [2]);
						animation.add('redhold', [3]);
						animation.add('bluehold', [1]);
					}

					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
				}

			default:
				{
					switch (noteType)
					{
						case NORMAL:
							{
								frames = Paths.getSparrowAtlas('NOTE_assets');

								animation.addByPrefix('greenScroll', 'green0');
								animation.addByPrefix('redScroll', 'red0');
								animation.addByPrefix('blueScroll', 'blue0');
								animation.addByPrefix('purpleScroll', 'purple0');

								animation.addByPrefix('purpleholdend', 'pruple end hold');
								animation.addByPrefix('greenholdend', 'green hold end');
								animation.addByPrefix('redholdend', 'red hold end');
								animation.addByPrefix('blueholdend', 'blue hold end');

								animation.addByPrefix('purplehold', 'purple hold piece');
								animation.addByPrefix('greenhold', 'green hold piece');
								animation.addByPrefix('redhold', 'red hold piece');
								animation.addByPrefix('bluehold', 'blue hold piece');

								setGraphicSize(Std.int(width * 0.7));
								updateHitbox();
								antialiasing = FlxG.save.data.antialiasing;
							}
						case SEAL:
							{
								frames = Paths.getSparrowAtlas('SEAL_assets');

								animation.addByPrefix('greenScroll', 'green0');
								animation.addByPrefix('redScroll', 'red0');
								animation.addByPrefix('blueScroll', 'blue0');
								animation.addByPrefix('purpleScroll', 'purple0');

								animation.addByPrefix('purpleholdend', 'pruple end hold');
								animation.addByPrefix('greenholdend', 'green hold end');
								animation.addByPrefix('redholdend', 'red hold end');
								animation.addByPrefix('blueholdend', 'blue hold end');

								animation.addByPrefix('purplehold', 'purple hold piece');
								animation.addByPrefix('greenhold', 'green hold piece');
								animation.addByPrefix('redhold', 'red hold piece');
								animation.addByPrefix('bluehold', 'blue hold piece');

								setGraphicSize(Std.int(width * 0.7));
								updateHitbox();
								antialiasing = FlxG.save.data.antialiasing;
							}
						case HALO:
							{
								frames = Paths.getSparrowAtlas('HALO_assets');

								animation.addByPrefix('greenScroll', 'green0');
								animation.addByPrefix('redScroll', 'red0');
								animation.addByPrefix('blueScroll', 'blue0');
								animation.addByPrefix('purpleScroll', 'purple0');

								animation.addByPrefix('purpleholdend', 'pruple end hold');
								animation.addByPrefix('greenholdend', 'green hold end');
								animation.addByPrefix('redholdend', 'red hold end');
								animation.addByPrefix('blueholdend', 'blue hold end');

								animation.addByPrefix('purplehold', 'purple hold piece');
								animation.addByPrefix('greenhold', 'green hold piece');
								animation.addByPrefix('redhold', 'red hold piece');
								animation.addByPrefix('bluehold', 'blue hold piece');

								setGraphicSize(Std.int(width * 0.7));
								updateHitbox();
								antialiasing = FlxG.save.data.antialiasing;
							}
					}
				}
		}

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		if (PlayState.SONG != null)
		{
			switch (PlayState.SONG.song.toLowerCase())
			{
				case 'dadbattle':
					songOffset = 0.24;
			}
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 1;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			if (prevNote.animation.curAnim != null)
			{
				if (prevNote.animation.curAnim.name.endsWith('end'))
				{
					if (!FlxG.save.data.downscroll)
						prevNote.offset.y -= 140;
					else
						prevNote.offset.y += 140;
				}
				else if (prevNote.animation.curAnim.name.endsWith('hold'))
				{
					if (!FlxG.save.data.downscroll)
						prevNote.offset.y += 10;
					else
						prevNote.offset.y -= 10;
				}
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				if (noteType == NORMAL)
				{
					switch (prevNote.noteData)
					{
						case 0:
							prevNote.animation.play('purplehold');
						case 1:
							prevNote.animation.play('bluehold');
						case 2:
							prevNote.animation.play('greenhold');
						case 3:
							prevNote.animation.play('redhold');
					}
				}

				// i had to copy from kade engine cuz im tired
				prevNote.updateHitbox();

				// prevNote.scale.y *= (stepHeight + 1.2 + songOffset) / prevNote.height;

				if (!FlxG.save.data.downscroll)
					prevNote.scale.y *= (Conductor.stepCrochet / 100 * 1.33) + 0.9;
				else
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5;
				prevNote.scale.y *= PlayState.SONG.speed;

				if (PlayState.curStage.startsWith('school'))
				{
					prevNote.scale.y *= 1.19;
				}

				prevNote.updateHitbox();

				/*// WHY GODDAMN IT!!!!
					if (FlxG.save.data.downscroll)
						prevNote.y -= prevNote.height * (1.5 * PlayState.SONG.speed * 1.5) + (Conductor.stepCrochet / 250) + 15;
					else
						prevNote.y += prevNote.height * (1.5 * PlayState.SONG.speed * 1.5) + (Conductor.stepCrochet / 250) + 15;
					// prevNote.setGraphicSize(); */
			}
		}
	}

	public function updateSustainScale():Void
	{
		var stepHeight = (((0.45 * Conductor.stepCrochet)) * FlxMath.roundDecimal(PlayState.SONG.speed, 2));

		prevNote.scale.y = formerHeight;

		prevNote.scale.y *= (stepHeight + 1.2) / prevNote.height;
		prevNote.updateHitbox();
		if (FlxG.save.data.downscroll)
			prevNote.noteYOff = Math.round(-prevNote.offset.y - 12);
		else
			prevNote.noteYOff = Math.round(-prevNote.offset.y + 12);

		// prevNote.setGraphicSize();

		noteYOff = Math.round(-offset.y);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// lol wtf
		if (animation.curAnim != null)
		{
			if (animation.curAnim.name.endsWith('end'))
				flipY = FlxG.save.data.downscroll;
		}

		prevNote.alpha = this.alpha;

		if (noteType == HALO)
			cannotBePressed = true;

		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * (isSustainNote ? cannotBePressed ? 0.3 : 0.5 : 1)))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			alpha = FlxMath.lerp(alpha, 0, (0.12 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)) / (60 * Main.framerate));
		}
	}
}
