package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

enum Direction
{
	LEFT;
	CENTER;
	RIGHT;
}

enum StyleType
{
	PIXEL;
	NORMAL;
}

class DialogueBox extends FlxSpriteGroup
{
	var bgSprite:FlxSprite;
	var backgroundColor:Int;

	var curCharacter:String = '';

	var boxDialogue:FlxSprite;

	var dialogueText:FlxTypeText;
	var dropText:FlxText;

	var speaker:FlxSprite;

	public var finishCallback:Void->Void;

	var proceedSprite:FlxSprite;
	var dialogue:Array<String> = [];
	var directionTalking:Array<Direction> = [];
	var styleType:StyleType;

	public function new(dialogue:Array<String>, directionTalking:Array<Direction>, font:String, ?styleType:StyleType = NORMAL,
			?backgroundColor:Int = 0xFFFFFFFF)
	{
		super();

		this.dialogue = dialogue;
		this.directionTalking = directionTalking;
		this.backgroundColor = backgroundColor;

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				if (FlxG.save.data.soundVolume >= 80)
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				else
					FlxG.sound.music.fadeIn(1, 0, FlxG.save.data.soundVolume / 100);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				if (FlxG.save.data.soundVolume >= 80)
					FlxG.sound.music.fadeIn(1, 0, 0.8);
				else
					FlxG.sound.music.fadeIn(1, 0, FlxG.save.data.soundVolume / 100);
		}

		bgSprite = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), backgroundColor);
		bgSprite.scrollFactor.set();
		bgSprite.alpha = 0;
		add(bgSprite);

		if (PlayState.curStage.startsWith('school') || styleType == PIXEL)
		{
			var fadeCools:Array<Float> = [0.2, 0.7, 0.83];

			new FlxTimer().start(fadeCools[2], function(tmr:FlxTimer)
			{
				bgSprite.alpha += fadeCools[0] * fadeCools[1];
				if (bgSprite.alpha > 0.7)
					bgSprite.alpha = 0.7;
			}, 5);
		}
		else
		{
			new FlxTimer().start(0.8, function(tmr:FlxTimer)
			{
				FlxTween.tween(bgSprite, {alpha: 0.7}, 0.9, {ease: FlxEase.sineIn});
			});
		}

		boxDialogue = new FlxSprite(-20, 45);

		var hasDialog:Bool = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				boxDialogue.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				boxDialogue.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				boxDialogue.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'), FlxG.save.data.soundVolume / 100);

				boxDialogue.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				boxDialogue.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				boxDialogue.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				boxDialogue.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				boxDialogue.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				boxDialogue.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
		}

		if (!hasDialog)
			return;

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = font;
		dropText.color = 0xFFD89494;
		add(dropText);

		dialogueText = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		dialogueText.font = font;
		dialogueText.color = 0xFF3F2021;
		if (FlxG.save.data.soundVolume > 60)
			dialogueText.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		else
			dialogueText.sounds = [FlxG.sound.load(Paths.sound('pixelText'), FlxG.save.data.soundVolume / 100)];
		add(dialogueText);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var isEnding:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			speaker.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			speaker.color = FlxColor.BLACK;
			dialogueText.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = dialogueText.text;

		if (boxDialogue.animation.curAnim != null)
		{
			if (boxDialogue.animation.curAnim.name == 'normalOpen' && boxDialogue.animation.curAnim.finished)
			{
				boxDialogue.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueStarted == true)
		{
			if (FlxG.save.data.soundVolume > 80)
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
			else
				FlxG.sound.play(Paths.sound('clickText'), FlxG.save.data.soundVolume / 100);

			if (dialogue[1] == null && dialogue[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						boxDialogue.alpha -= 1 / 5;
						bgSprite.alpha -= 1 / 5 * 0.7;
						speaker.visible = false;
						dialogueText.alpha -= 1 / 5;
						proceedSprite.alpha -= 1 / 5;
						dropText.alpha = dialogueText.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishCallback();
						kill();
					});
				}
			}
			else
			{
				dialogue.remove(dialogue[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	function startDialogue():Void
	{
		cleanDialog();
		proceedSprite.visible = false;
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		dialogueText.resetText(dialogue[0]);
		dialogueText.start(0.04, true);

		// bruh
		dialogueText.completeCallback = makeVisible;

		switch (curCharacter)
		{
			case 'dad':
				speaker.visible = false;
				if (!speaker.visible)
				{
					flipX = false;
					if (PlayState.SONG.song.toLowerCase() != 'thorns')
					{
						speaker.visible = true;
						speaker.animation.play('enter');
					}
				}
			case 'bf':
				speaker.visible = false;
				if (!speaker.visible)
				{
					flipX = true;
					speaker.visible = true;
					speaker.animation.play('enter');
				}
		}
	}

	function makeVisible():Void
		{
			// why do we have to make this shit on a function
			proceedSprite.visible = true;
		}

	function cleanDialog():Void
		{
			var splitName:Array<String> = dialogue[0].split(":");
			curCharacter = splitName[1];
			dialogue[0] = dialogue[0].substr(splitName[1].length + 2).trim();
		}
}
