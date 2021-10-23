package;

import flixel.FlxG;
import flixel.FlxState;

enum MenuStyles
{
	LEFT;
	MIDDLE; // DEFAULT
	RIGHT;
}

class GameData
{
	// GAME
	// DISABLE IF YOU DON'T WANT GAMEJOLT FEATURES
	public static var isGameJolt:Bool = false;
	// If you don't wanna have CPU elapsed and "Dev Build" name in debug
	public static var debugStats:Bool = false;
	// Test Cutscenes even in Freeplay, only in debug mode. Set to false by default.
	public static var ignoreDebugCutscenes:Bool = true;
	// The global font for the game, default is VCR.
	public static var globalFont:String = Paths.font('funkin', 'otf');

	// TITLE SCREEN
	// If the Engine's logo is enabled.
	public static var platinumLogo:Bool = true;
	// What should be the name of your mod. Useful if you want different save datas.
	public static var modName = "SilentHill";
	// MAIN MENU
	// Menu Directional for the Menu.
	public static var menuStyle:MenuStyles = MenuStyles.MIDDLE;
	// Show the version?
	public static var showVersion:Bool = true;

	// CHARACTERS
	public static var charactersThatFloat:Array<String> = ['spirit']; // Self-explanatory, characcters that can float.

	public static var options:Array<Dynamic>;

	public static function initSettings()
	{
		options = [
			// NAME, DESCRIPTION, SAVE DATA, VALUES, DEFAULT VALUE,
			[
				['options', [''], null, null, null],
				['gameplay', 'Change the way you play your games', null, null, null],
				['graphics', 'Change the way your games look.', null, null, null],
				['sounds', "Change the way you hear the game's sounds", null, null, null],
				['reset settings', 'Set everything to default.', null, null, null],
			],
			[
				['gameplay options', [''], null, null, null],
				[
					'downscroll',
					// too lazy to fix
					['If notes should go from the bottom instead of the top.', 'If notes should go from the bottom instead of the top.'],
					FlxG.save.data.downscroll,
					[false, true],
					false,
					0,
					'downscroll'
				],
				[
					'ghost tapping',
					['If tapping without notes should give you a miss penalty.', 'If tapping without notes should give you a miss penalty.'],
					FlxG.save.data.ghostTap,
					[false, true],
					false,
					0,
					'ghostTap'
				],
				[
					'accuracy type',
					[
						'Simple calculates your accuracy by rating.',
						'Complex calculates your accuracy based on time of hit. (Uses Etterna Wife3)',
						'Do not show the accuracy'
					],
					FlxG.save.data.accuracy,
					['simple', 'complex', 'none'],
					'simple',
					0,
					'accuracy'
				],
				[
					'score type',
					[
						'New calculates your score depending on note time of hit',
						"Old calculates score depending on rating. No difference of note time of hit."
					],
					FlxG.save.data.scoreType,
					['new', 'old'],
					'new',
					0,
					'scoreType'
				],
				[
					'note offset',
					['How much miliseconds for your notes to either go early or late with the song.'],
					FlxG.save.data.offset,
					[0],
					0,
					'noteOffset'
				]
			],
			[
				['graphics options', [''], null, null, null],
				[
					'video quality',
					['Set the quality of the game, higher is better but more-performance heavy.', 'Set the quality of the game, higher is better but more-performance heavy.', 'Set the quality of the game, higher is better but more-performance heavy.'],
					FlxG.save.data.quality,
					['low', 'medium', 'high'],
					'high',
					0,
					'quality'
				],
				[
					'postprocessing effects',
					['If postprocessing effects should appear.', 'If postprocessing effects should appear.'],
					FlxG.save.data.vfxEffects,
					[true, false],
					true,
					0,
					'vfxEffects'
				],
				[
					'animation frequency',
					[
						'Only the first frames of the animation will be shown. (CHARACTERS ONLY)',
						'Only main characters will be animated.',
						'All sprites will be animated.'
					],
					FlxG.save.data.animFreq,
					['none', 'minimal', 'maximum'],
					'maximum',
					0,
					'animFreq'
				],
				[
					'antialiasing',
					['Makes all sprites look smoother.', 'Makes all sprites look smoother.'],
					FlxG.save.data.antialiasing,
					[true, false],
					true,
					0,
					'antialiasing'
				]
			],
			[
				['sounds options', '', null, null, null],
				['music volume', ['Set the music volume.'], FlxG.save.data.musicVolume, 100, 100, 0, 'musicVolume'],
				['sound volume', ['Set the sound volume.'], FlxG.save.data.soundVolume, 100, 100, 0, 'soundVolume'],
				[
					'vocals volume',
					['Set the vocals volume.'],
					FlxG.save.data.vocalsVolume,
					100,
					100,
					0,
					'vocalVolume'
				],
			]
		];
	}

	// FREEPLAY or STORY MODE
	public static function getSongs(isStoryMode:Bool = true):Array<Dynamic>
	{
		if (isStoryMode)
		{
			// returns a week, for story mode.
			var week:Array<Dynamic> = [];

			var weekData:Array<Array<String>> = [
				['Tutorial'],
				['Bopeebo', 'Fresh', 'Dadbattle'],
				['Spookeez', 'South', "Monster"],
				['Pico', 'Philly', "Blammed"],
				['Satin-Panties', "High", "Milf"],
				['Cocoa', 'Eggnog', 'Winter-Horrorland'],
				['Senpai', 'Roses', 'Thorns']
			];

			var weekCharacters:Array<Dynamic> = [
				['dad', 'bf', 'gf'],
				['dad', 'bf', 'gf'],
				['spooky', 'bf', 'gf'],
				['pico', 'bf', 'gf'],
				['mom', 'bf', 'gf'],
				['parents-christmas', 'bf', 'gf'],
				['senpai', 'bf', 'gf']
			];

			var weekNames = [
				"",
				"Daddy Dearest",
				"Spooky Month",
				"PICO",
				"MOMMY MUST MURDER",
				"RED SNOW",
				"hating simulator ft. moawling"
			];

			week = [weekData, weekCharacters, weekNames];

			return week;
		}
		else
		{
		}
		return [];
	}

	// bruh???
	public static function isData(type:String, expectedType:String):Bool
	{
		if (type == expectedType)
			return true;

		return false;
	}
}
