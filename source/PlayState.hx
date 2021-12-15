package;

import haxe.macro.Expr.Var; #if sys import sys.io.File;
import sys.FileSystem; #end#if desktop import Discord.DiscordClient; #end import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.effects.particles.FlxEmitter;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea; // import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState; // import flixel.graphics.atlas.FlxAtlas;
// import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect; // import flixel.math.FlxRandom;
import flixel.system.FlxSound; // import flixel.system.FlxSoundGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar; // import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import openfl.events.KeyboardEvent;
import openfl.display.BitmapData;
import Note.NoteType;
import Controls; // import lime.utils.Assets;

// import openfl.display.BlendMode;
// import openfl.display.StageQuality;
// import openfl.filters.ShaderFilter;
using StringTools;

class SongResults
{
	public var song:String = '';
	public var score:Int = 0;
	public var combos:Array<Int> = [];
	public var accuracyHistory:Array<Float> = [];
	public var health:Float = 0;
	public var players:Array<String> = [];

	public function new(song:String, score:Int, combos:Array<Int>, accuracy:Array<Float>, health:Float, players:Array<String>)
	{
		this.song = song;
		this.score = score;
		this.combos = combos;
		this.accuracyHistory = accuracy;
		this.health = health;
		this.players = players;
	}
}

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var isPaused:Bool = false;
	public static var lastSelected:Int = 0;

	public var daSongisPlaying:Bool;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	private var enemy:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var debugSprite:FlxTypedGroup<FlxSprite>;
	private var unspawnNotes:Array<Note> = [];
	// unspawnNotes but without the enemies
	// not much anyways its just for the accuracy
	private var playerAccuracy:Int = 0;

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var enemyStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;
	private var endingSong:Bool = false;

	private var iconP1:HealthIconOld;
	private var iconP2:HealthIconOld;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var camPause:FlxCamera;

	private var keysText:FlxText;

	// the sprites were grouped was because to make it easier to control the grouped stuff
	public static var bgSprites:FlxTypedGroup<FlxSprite>;
	public static var characterSprites:FlxTypedGroup<Character>;

	var camOffset:Array<Float> = [0, 0];

	public var healthMulti:Int = 1;

	var camSpeed:Float = 1;
	var noPressTime:Float = 5;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var forceBeat:Array<Int> = [];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;
	var spookySmokeBG:FlxSprite;
	var spookySmokeFG:FlxSprite;
	var spookOverlay:FlxSprite;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var overlayRoof:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var smoke:FlxSprite;

	var talking:Bool = true;
	var songScore:Int = 0;
	var fixedSongScore:String = '';
	var scoreTxt:FlxText;
	var timerText:FlxText;

	var accuracy:Float = 0.00;
	var lastNoteDiff:Float = 0;
	var totalRanksHit:Float = 0;
	var totalNotesHit:Float = 0;

	var iconDoneMove:Bool = false;

	var botplayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var nps:Int;
	public static var notesHitArray:Array<Date> = [];

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	var timerLeft:Float = 0;
	var curLight:Int = 0;

	// use this to fix timer
	var fakeInst:FlxSound;
	var songHasStarted:Bool = false;

	var animOrder:Map<String, Int> = new Map();

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#else
	// lmao
	var songLength:Float = 0;
	#end

	public var comboList:Array<Int> = [0, 0, 0, 0];
	public var accuracyHistory:Array<Float> = [];

	public var misses:Int = 0;

	public var downscroll:Bool;
	public var ghostTap:Bool;
	public var accuracyType:String;
	public var debugCutscene:Bool;
	public var scoreType:String;

	public var antialiasing:Bool;
	public var quality:String;
	public var vfxEffects:Bool;
	public var animFreq:String;

	override public function create()
	{
		// initalize settings
		downscroll = FlxG.save.data.downscroll;
		ghostTap = FlxG.save.data.ghostTap;
		accuracyType = FlxG.save.data.accuracy;
		quality = FlxG.save.data.quality;
		antialiasing = FlxG.save.data.antialiasing;
		scoreType = FlxG.save.data.scoreType;
		vfxEffects = FlxG.save.data.vfxEffects;
		animFreq = FlxG.save.data.animFreq;

		#if debug
		if (!GameData.ignoreDebugCutscenes)
			debugCutscene = true;
		#else
		debugCutscene = false;
		#end

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		fakeInst = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camPause = new FlxCamera();
		camPause.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camPause);

		FlxCamera.defaultCameras = [camGame];
		camGame.pixelPerfectRender = false;
		camHUD.pixelPerfectRender = false;

		startTimer = new FlxTimer();

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		var leSong:String = SONG.song.toLowerCase(); // Bopeebo = bopeebo, Fresh = fresh, Dadbattle = dadbattle.

		switch (SONG.song.toLowerCase())
		{
			case 'senpai' | 'roses' | 'thorns':
				dialogue = CoolUtil.string.coolTextFile(Paths.txt('$leSong/$leSong' + 'Dialogue'));
		}

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end

		bgSprites = new FlxTypedGroup<FlxSprite>();
		add(bgSprites);

		switch (SONG.song.toLowerCase())
		{
			case 'spookeez' | 'monster' | 'south' | 'judgement':
				{
					curStage = 'spooky';
					halloweenLevel = true;

					var hallowTex = Paths.getSparrowAtlas('halloween_bg');

					halloweenBG = new FlxSprite(-200, -100);
					halloweenBG.frames = hallowTex;
					halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
					halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
					halloweenBG.animation.play('idle');
					halloweenBG.antialiasing = antialiasing;
					bgSprites.add(halloweenBG);

					if (quality == 'high')
					{
						spookySmokeBG = new FlxSprite(-400, -100).loadGraphic(Paths.image('smokeBG'));
						spookySmokeBG.antialiasing = antialiasing;
						FlxTween.tween(spookySmokeBG, {x: -500}, (Conductor.crochet / 1000) * 12, {ease: FlxEase.smoothStepInOut, type: PINGPONG});
						bgSprites.add(spookySmokeBG);

						spookySmokeFG = new FlxSprite(-300, -100).loadGraphic(Paths.image('smokeFG'));
						spookySmokeFG.antialiasing = antialiasing;
						spookySmokeFG.setGraphicSize(Std.int(spookySmokeFG.width * 1.6));

						spookOverlay = new FlxSprite(-1000, -1000).makeGraphic(FlxG.width * 10, FlxG.height * 10, 0xFF164987);
						spookOverlay.antialiasing = antialiasing;
						spookOverlay.alpha = 0.15;
					}

					isHalloween = true;
				}
			case 'pico' | 'blammed' | 'philly':
				{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
					bg.scrollFactor.set(0.1, 0.1);
					bg.antialiasing = antialiasing;
					bgSprites.add(bg);

					if (quality != 'medium' && quality != 'low')
					{
						var cityBG:FlxSprite = new FlxSprite(-25, 150).loadGraphic(Paths.image('philly/city_bg'));
						cityBG.scrollFactor.set(0.25, 0.25);
						cityBG.setGraphicSize(Std.int(cityBG.width * 0.9));
						cityBG.updateHitbox();
						cityBG.antialiasing = antialiasing;
						bgSprites.add(cityBG);
					}

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					city.antialiasing = antialiasing;
					bgSprites.add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					add(phillyCityLights);

					if (quality == 'high')
					{
						var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/winwhite'));
						light.scrollFactor.set(0.3, 0.3);
						light.visible = false;
						light.setGraphicSize(Std.int(light.width * 0.85));
						light.updateHitbox();
						light.antialiasing = antialiasing;
						phillyCityLights.add(light);
					}
					for (i in 0...5)
					{
						var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
						light.scrollFactor.set(0.3, 0.3);
						light.visible = false;
						light.setGraphicSize(Std.int(light.width * 0.85));
						light.updateHitbox();
						light.antialiasing = antialiasing;
						phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
					streetBehind.antialiasing = antialiasing;
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
					phillyTrain.antialiasing = antialiasing;
					add(phillyTrain);

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
					trainSound.volume = FlxG.save.data.soundVolume / 100;
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
					street.antialiasing = antialiasing;
					add(street);

					if (quality == 'high')
					{
						var poster:FlxSprite = new FlxSprite(1210, 440).loadGraphic(Paths.image('philly/pico_poster'));
						poster.antialiasing = FlxG.save.data.antialiasing;
						add(poster);
					}
				}
			case 'milf' | 'satin-panties' | 'high':
				{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
					skyBG.scrollFactor.set(0.1, 0.1);
					bgSprites.add(skyBG);

					if (quality == 'high' || vfxEffects)
					{
						var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
						overlayShit.alpha = 0.5;
						bgSprites.add(overlayShit);
					}

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					FlxTween.tween(bgLimo, {x: -225}, Conductor.crochet / 1000 * 16, {ease: FlxEase.sineInOut, type: PINGPONG});
					bgSprites.add(bgLimo);

					if (quality != 'low')
					{
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);

						for (i in 0...5)
						{
							var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
							FlxTween.tween(dancer, {x: ((370 * i) + 130) - 25}, Conductor.crochet / 1000 * 16, {ease: FlxEase.sineInOut, type: PINGPONG});
							dancer.scrollFactor.set(0.4, 0.4);
							grpLimoDancers.add(dancer);
						}
					}

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = antialiasing;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
					// add(limo);

					if (quality == 'high')
					{
						var glowy:FlxSprite = new FlxSprite(0, 40).loadGraphic(Paths.image('limo/glowy'));
						glowy.cameras = [camHUD];
						glowy.antialiasing = antialiasing;
						glowy.alpha = 0.2;
						glowy.scrollFactor.set();
						FlxTween.tween(glowy, {alpha: 0.8}, Conductor.crochet / 1000 * 4, {ease: FlxEase.quadInOut, type: PINGPONG});
						bgSprites.add(glowy);
					}
				}
			case 'cocoa' | 'eggnog':
				{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
					bg.antialiasing = antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					bgSprites.add(bg);

					if (quality != 'low')
					{
						upperBoppers = new FlxSprite(-240, -90);
						upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
						upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
						upperBoppers.antialiasing = antialiasing;
						upperBoppers.scrollFactor.set(0.33, 0.33);
						upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
						upperBoppers.updateHitbox();
						bgSprites.add(upperBoppers);
					}

					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
					bgEscalator.antialiasing = antialiasing;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					bgSprites.add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
					tree.antialiasing = antialiasing;
					tree.scrollFactor.set(0.40, 0.40);
					bgSprites.add(tree);

					if (quality != 'low')
					{
						bottomBoppers = new FlxSprite(-300, 140);
						bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
						bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
						bottomBoppers.antialiasing = antialiasing;
						bottomBoppers.scrollFactor.set(0.9, 0.9);
						bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
						bottomBoppers.updateHitbox();
						bgSprites.add(bottomBoppers);
					}

					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
					fgSnow.active = false;
					fgSnow.antialiasing = antialiasing;
					bgSprites.add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = antialiasing;

					if (quality == 'high')
					{
						overlayRoof = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgSkyGradient'));
						overlayRoof.antialiasing = antialiasing;
						overlayRoof.setGraphicSize(Std.int(overlayRoof.width), Std.int(overlayRoof.height * 1.4));
						overlayRoof.updateHitbox();
						overlayRoof.scrollFactor.set(0.05, 0.05);
					}
				}
			case 'winter-horrorland':
				{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
					bg.antialiasing = antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					bgSprites.add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
					evilTree.antialiasing = antialiasing;
					evilTree.scrollFactor.set(0.2, 0.2);
					bgSprites.add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
					evilSnow.antialiasing = antialiasing;
					bgSprites.add(evilSnow);
				}
			case 'senpai' | 'roses':
				{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
					bgSky.scrollFactor.set(0.1, 0.1);
					bgSprites.add(bgSky);

					var repositionShit = -200;

					if (quality == 'high')
					{
						var bgMountain:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebMountain'));
						bgMountain.scrollFactor.set(0.5, 0.80);
						bgSprites.add(bgMountain);
					}

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					bgSprites.add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					bgSprites.add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					bgSprites.add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					bgSprites.add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);

					if (quality != 'low')
					{
						treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
						treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
						treeLeaves.animation.play('leaves');
						treeLeaves.scrollFactor.set(0.85, 0.85);
						bgSprites.add(treeLeaves);
					}

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (SONG.song.toLowerCase() == 'roses')
					{
						bgGirls.getScared();
					}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					bgSprites.add(bgGirls);
				}
			case 'thorns':
				{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					if (quality != 'low')
						bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					bgSprites.add(bg);
				}
			case 'restless-dreams' | 'stages-of-grief':
				{
					curStage = 'james';
					defaultCamZoom = 0.75;

					/*var bg:FlxSprite = new FlxSprite(-10, -10).loadGraphic(Paths.image('pyramid_bg'));
						bg.antialiasing = antialiasing;
						bg.scrollFactor.set(0.8, 0.8);
						bg.active = false;
						bgSprites.add(bg); */

					smoke = new FlxSprite(-170, -170).loadGraphic(Paths.image('smoke_james'));
					smoke.antialiasing = antialiasing;
					smoke.active = false;
					smoke.scrollFactor.set(0.175, 0.175);
					smoke.scale.set(1.2, 1.2);
					bgSprites.add(smoke);

					var tree:FlxSprite = new FlxSprite(-160, -160).loadGraphic(Paths.image('building_trees'));
					tree.antialiasing = antialiasing;
					tree.scrollFactor.set(0.8, 0.8);
					tree.active = false;
					tree.scale.set(1.1, 1.1);
					bgSprites.add(tree);

					var building:FlxSprite = new FlxSprite(-160, -160).loadGraphic(Paths.image('building_james'));
					building.antialiasing = antialiasing;
					building.scrollFactor.set(0.9, 0.9);
					building.active = false;
					building.scale.set(1.1, 1.1);
					bgSprites.add(building);
				}
			default:
				{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = antialiasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					bgSprites.add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					bgSprites.add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = antialiasing;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					bgSprites.add(stageCurtains);
				}
		}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		switch (SONG.song)
		{
			case 'restless-dreams' | 'stages-of-grief' | 'judgement':
				gf.visible = gf.active = false;
		}

		enemy = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(enemy.getGraphicMidpoint().x, enemy.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				enemy.setPosition(gf.x, gf.y);
				gf.visible = false;

			case "spooky":
				enemy.y += 200;
			case "monster":
				enemy.y += 100;
			case 'monster-christmas':
				enemy.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				enemy.y += 300;
			case 'parents-christmas':
				enemy.x -= 500;
			case 'senpai':
				enemy.x += 150;
				enemy.y += 360;
				camPos.set(enemy.getGraphicMidpoint().x + 310, enemy.getGraphicMidpoint().y);
			case 'senpai-angry':
				enemy.x += 150;
				enemy.y += 360;
				camPos.set(enemy.getGraphicMidpoint().x + 310, enemy.getGraphicMidpoint().y);
			case 'spirit':
				enemy.x -= 150;
				enemy.y += 100;
				camPos.set(enemy.getGraphicMidpoint().x + 300, enemy.getGraphicMidpoint().y);
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				enemy.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(enemy, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'james':
				boyfriend.x += 60;
				enemy.x += 60;
				gf.x += 60;
		}

		characterSprites = new FlxTypedGroup<Character>();
		add(characterSprites);

		characterSprites.add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		characterSprites.add(enemy);
		// do this cuz he's behind it
		if (curStage != 'limo')
			characterSprites.add(boyfriend);
		else
			add(boyfriend);

		if (curStage == 'spooky' && quality == 'high')
		{
			bgSprites.add(spookySmokeFG);
			add(spookOverlay);
			// idk
			// boyfriend.setColorTransform(1, 1, 1, 1, 0, Std.int(74 / 4), 88, 0);
		}

		animOrder.set('singLEFT', 0);
		animOrder.set('singDOWN', 1);
		animOrder.set('singUP', 2);
		animOrder.set('singRIGHT', 3);

		// layering shit for santa duwb
		if (curStage == 'mall')
		{
			bgSprites.add(santa);
			bgSprites.add(overlayRoof);
		}

		var doof:DialogueBoxOld = new DialogueBoxOld(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		if (downscroll)
			strumLine = new FlxSprite(0, 550).makeGraphic(FlxG.width, 10);
		else
			strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);

		strumLine.scrollFactor.set();
		if (downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		enemyStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camGame.followLerp = 60 / 180;

		camFollow.setPosition(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y - 15);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, (0.04 * (30 / Main.framerate)) / camSpeed);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, downscroll ? FlxG.height * 0.1 : FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(CharacterColor.color(enemy.curCharacter), CharacterColor.color(boyfriend.curCharacter));
		if (quality == 'high')
			healthBar.numDivisions = 3000;
		add(healthBar);

		scoreTxt = new FlxText(healthBarBG.x - 105, healthBarBG.y + healthBarBG.height + 10, 800, "", 22);
		scoreTxt.setFormat(GameData.globalFont, 22, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.font = curStage.startsWith('school') ? Paths.font('vcr') : GameData.globalFont;
		scoreTxt.scrollFactor.set();
		scoreTxt.alpha = 0;

		timerText = new FlxText(healthBarBG.x - 105, downscroll ? FlxG.height * 0.9 : FlxG.height * 0.1, 800, "", 30);
		timerText.y = strumLine.y + 45;
		timerText.screenCenter(X);
		timerText.x -= 20;
		timerText.setFormat(GameData.globalFont, 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timerText.font = curStage.startsWith('school') ? Paths.font('vcr') : GameData.globalFont;
		timerText.scrollFactor.set();

		botplayTxt = new FlxText(0, downscroll ? scoreTxt.y + 45 : scoreTxt.y - 45, 0, "BOTPLAY", 30);
		botplayTxt.setFormat(GameData.globalFont, 22, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.screenCenter(X);
		botplayTxt.font = curStage.startsWith('school') ? Paths.font('vcr') : GameData.globalFont;
		botplayTxt.alpha = 0;

		iconP1 = new HealthIconOld(SONG.player1, true);
		iconP1.x = healthBar.x + healthBar.width;
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIconOld(SONG.player2, false);
		iconP2.x = healthBar.x - 132;
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		add(scoreTxt);
		add(timerText);
		add(botplayTxt);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		timerText.cameras = [camHUD];
		doof.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode || debugCutscene)
		{
			switch (curSong.toLowerCase())
			{
				case 'monster':
					camHUD.alpha = 0;

					var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
					black.scrollFactor.set();
					add(black);

					FlxG.camera.zoom = 2.6;
					FlxG.camera.focusOn(camFollow.getPosition());
					camFollow.x += 800;
					camFollow.y -= 350;

					new FlxTimer().start(0.7, function(tmr:FlxTimer)
					{
						FlxTween.tween(black, {alpha: 0}, 0.3, {ease: FlxEase.quintOut});
					});

					new FlxTimer().start(1.4, function(tmr:FlxTimer)
					{
						FlxTween.tween(camFollow, {x: gf.getGraphicMidpoint().x, y: gf.getGraphicMidpoint().y - 15}, 3.4, {ease: FlxEase.quintInOut});
						FlxTween.tween(camHUD, {alpha: 1}, 2.5, {ease: FlxEase.quintInOut});
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 3, {
							ease: FlxEase.quintInOut,
							onComplete: function(twn:FlxTween)
							{
								startCountdown();
							}
						});
					});

				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.alpha = 0;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'), FlxG.save.data.soundVolume / 100);
						camFollow.y = -2050;
						camFollow.x = gf.getGraphicMidpoint().x - 69; // ¯\_(ツ)_/¯
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							FlxTween.tween(camHUD, {alpha: 1}, 2.5, {ease: FlxEase.quintInOut});
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					if (isStoryMode || debugCutscene)
						FlxG.sound.play(Paths.sound('ANGRY'), FlxG.save.data.soundVolume / 100);
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, inputHandle);
		// FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, inputRelease);

		super.create();
	}

	public var closestNotes:Array<Note> = [];

	var arrowKeys:Array<Int> = [37, 38, 39, 40];

	// similar to KE 1.7
	// dont kill me :(
	public function inputHandle(evt:KeyboardEvent):Void
	{
		if (FlxG.save.data.botplay || paused)
			return;

		var direction:Int = -1;

		var keyLeft:Array<Int> = PlayerSettings.player1.controls.getInputsFor(Control.LEFT, Keys);
		var keyDown:Array<Int> = PlayerSettings.player1.controls.getInputsFor(Control.DOWN, Keys);
		var keyUp:Array<Int> = PlayerSettings.player1.controls.getInputsFor(Control.UP, Keys);
		var keyRight:Array<Int> = PlayerSettings.player1.controls.getInputsFor(Control.RIGHT, Keys);

		var keyP:Array<Array<Int>> = [[], []];

		var keyList:Array<Array<Int>> = [keyLeft, keyUp, keyRight, keyDown];

		for (keyArray in keyList)
		{
			keyArray = CoolUtil.takeOutDuplicate(keyArray);

			for (key in keyArray)
			{
				switch (key)
				{
					case 37:
						keyP[0][0] = key; // left
					case 38:
						keyP[0][1] = key; // up
					case 39:
						keyP[0][2] = key; // right
					case 40:
						keyP[0][3] = key; // down
				}

				if (!arrowKeys.contains(key))
				{
					// do this???
					keyP[1][0] = keyList[0][1];
					keyP[1][1] = keyList[1][1];
					keyP[1][2] = keyList[2][1];
					keyP[1][3] = keyList[3][1];
				}
			}
		}

		var wasArrow:Bool = false;

		for (i in 0...keyP[1].length)
		{
			if (keyP[1][i] == evt.keyCode)
				direction = i;
			else
				wasArrow = true;
		}

		if (direction == -1 && !wasArrow)
		{
			trace('ERROR: Unknown code: $direction');
			return;
		}

		closestNotes = [];
		var directionList = [];

		if (notes != null && notes.members != null)
		{
			if (notes.members.length > 1)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.wasGoodHit && !daNote.cannotBePressed)
						closestNotes.push(daNote);
				});
			}
		}

		closestNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

		for (i in closestNotes)
			if (i.noteData == direction)
				directionList.push(i);

		if (directionList.length != 0)
		{
			var daNote = null;
			var isSustainNote:Bool = false;

			for (i in closestNotes)
			{
				if (i.isSustainNote)
					isSustainNote = true;
				else
					daNote = i;
			}

			if (isSustainNote)
				return;

			if (closestNotes.length > 1)
			{
				for (i in 0...directionList.length)
				{
					if (i == 0)
						continue;

					var note = closestNotes[i];

					if (!note.isSustainNote && (note.strumTime - daNote.strumTime) < 10)
					{
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
				}
			}
			else if (!ghostTap)
			{
				noteMiss(direction, null);
			}
		}
	}

	function schoolIntro(?dialogueBox:DialogueBoxOld):Void
	{
		timerText.alpha = 0;
		iconP1.alpha = 0;
		iconP2.alpha = 0;
		healthBarBG.alpha = 0;
		healthBar.alpha = 0;
		scoreTxt.alpha = 0;

		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var blackT:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackT.scrollFactor.set();
		if (curSong.toLowerCase() != 'roses')
			add(blackT);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if ((SONG.song.toLowerCase() == 'thorns'))
			add(blackT);

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.15, function(fadeTimer:FlxTimer)
		{
			blackT.alpha -= 0.1;
			fadeTimer.reset(0.15);
		});

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			var coolFades:Array<Float> = [0.15, 0.3];
			black.alpha -= coolFades[0];

			if (black.alpha > 0)
			{
				tmr.reset(coolFades[1]);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), FlxG.save.data.soundVolume / 100, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									remove(blackT);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		if (!songHasStarted)
		{
			if (SONG.song.toLowerCase() == 'thorns')
				FlxTween.tween(camHUD, {angle: -6}, 0.15, {ease: FlxEase.sineInOut});

			FlxTween.tween(iconP1, {
				x: healthBar.x + (healthBar.width * 0.5) - (26 - 4)
			}, (Conductor.crochet / 1000) * 4.5, {ease: FlxEase.quadInOut});
			FlxTween.tween(iconP2, {
				x: healthBar.x + (healthBar.width * 0.5) - (iconP2.width - 26)
			}, (Conductor.crochet / 1000) * 4.5, {
				ease: FlxEase.quadInOut,
				onComplete: function(twn:FlxTween)
				{
					iconDoneMove = true;
				}
			});

			if (curStage.startsWith('school') && (isStoryMode || debugCutscene))
			{
				new FlxTimer().start(0.15, function(fadeTimer:FlxTimer)
				{
					timerText.alpha += 0.1;
					iconP1.alpha += 0.1;
					iconP2.alpha += 0.1;
					healthBarBG.alpha += 0.1;
					healthBar.alpha += 0.1;
					scoreTxt.alpha += 0.1;
					if (timerText.alpha < 1)
						fadeTimer.reset(0.15);
				});
			}

			inCutscene = false;

			generateStaticArrows(0);
			generateStaticArrows(1);

			talking = false;
			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
		}

		/*
			trace((unspawnNotes[0].strumTime / 1000) - ((Conductor.stepCrochet * 3) / 1000), unspawnNotes[0].strumTime / 1000);

			new FlxTimer().start((unspawnNotes[0].strumTime / 1000) - ((Conductor.stepCrochet * 3) / 1000), function(tmr:FlxTimer)
			{ */

		countDownSprites();
		// });
	}

	function countDownSprites():Void
	{
		var swagCounter:Int = 0;

		startTimer.start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (!songHasStarted)
			{
				enemy.dance();
				gf.dance();
				boyfriend.playAnim('idle');
				if (curStage == 'mall' && animFreq == 'maximum')
					santa.animation.play('idle', true);
			}

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
				}
			}

			if (curStage.startsWith('school'))
				altSuffix = '-pixel';

			switch (swagCounter)
			{
				case 0:
					if (FlxG.save.data.soundVolume > 60)
						FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
					else
						FlxG.sound.play(Paths.sound('intro3' + altSuffix), FlxG.save.data.soundVolume / 100);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();
					if (!curStage.startsWith('school'))
						ready.antialiasing = antialiasing;

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					if (FlxG.save.data.soundVolume > 60)
						FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
					else
						FlxG.sound.play(Paths.sound('intro2' + altSuffix), FlxG.save.data.soundVolume / 100);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();
					if (!curStage.startsWith('school'))
						set.antialiasing = antialiasing;

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					if (FlxG.save.data.soundVolume > 60)
						FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
					else
						FlxG.sound.play(Paths.sound('intro1' + altSuffix), FlxG.save.data.soundVolume / 100);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();
					if (!curStage.startsWith('school'))
						go.antialiasing = antialiasing;

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					if (FlxG.save.data.soundVolume > 60)
						FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
					else
						FlxG.sound.play(Paths.sound('introGo' + altSuffix), FlxG.save.data.soundVolume / 100);
				case 4:
					// ???
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
			daSongisPlaying = true;
		}
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		if (SONG.song.toLowerCase() == 'thorns')
		{
			new FlxTimer().start(0.15, function(tmr:FlxTimer)
			{
				FlxTween.tween(camHUD, {angle: 6}, Conductor.crochet / 1000 * 8, {ease: FlxEase.sineInOut, type: PINGPONG});
			});
		}

		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var curNoteType:String = '';

	function updateAccuracy():Float
	{
		var truncateAccuracy = 0.00;

		if (!ghostTap)
			accuracy = totalRanksHit / (playerAccuracy) * 100;
		else
			accuracy = totalRanksHit / (misses + playerAccuracy) * 100;

		if (accuracy > 100)
			accuracy = 100;

		if (accuracy < 0)
			accuracy = 0;

		truncateAccuracy = MathUtils.truncateFloat(accuracy, 2);

		if (truncateAccuracy < 0)
			truncateAccuracy = 0;
		if (truncateAccuracy > 100)
			truncateAccuracy = 100;

		return truncateAccuracy;
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		debugSprite = new FlxTypedGroup<FlxSprite>();
		add(debugSprite);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var color:Array<Int> = [FlxColor.PURPLE, FlxColor.BLUE, FlxColor.LIME, FlxColor.RED];
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + Conductor.offset;
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var daNoteType = songNotes[3];

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, daNoteType, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				/*if (daBeats == 0)
						trace([swagNote.width, swagNote.height]);

					var noteDebugSprite:FlxSprite = new FlxSprite(swagNote.x, swagNote.y).makeGraphic(108, 110, color[swagNote.noteData]);
					noteDebugSprite.scrollFactor.set(0, 0);
					debugSprite.add(noteDebugSprite); */

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				#if (tester && !debug)
				for (i in 0...64)
				{
					var randomness:NoteType = SEAL;

					if (FlxG.random.bool(30))
						randomness = HALO;

					if (i % 4 == 0)
						trace(i);

					var haloNoteRandom:Note = new Note(FlxG.random.float(0, FlxG.sound.music.length * 1000), FlxG.random.int(0, 3, [swagNote.noteData]),
						randomness, oldNote);
					haloNoteRandom.sustainLength = songNotes[2];
					haloNoteRandom.scrollFactor.set(0, 0);
					haloNoteRandom.mustPress = gottaHitNote;
					unspawnNotes.push(haloNoteRandom);
					if (gottaHitNote)
					{
						if (randomness == SEAL)
							playerAccuracy++;
						haloNoteRandom.x += FlxG.width / 2;
					}
				}
				#end

				// a
				if (gottaHitNote)
					playerAccuracy++;

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, daNoteType, oldNote,
						true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
						sustainNote.x += 60;
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
					swagNote.x += 60;
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;

		trace('SONG INFORMATION:');
		var tempString:String = '';

		var tempSpawn:Array<Dynamic> = [
			SONG.song,
			SONG.bpm,
			SONG.needsVoices,
			SONG.player1,
			SONG.player2,
			SONG.gf,
			SONG.speed,
			SONG.camera,
			SONG.validScore
		];

		var stuffThingie:Array<String> = [
			'NAME: ',
			'BPM: ',
			'HAS VOCALS: ',
			'PLAYER 1: ',
			'PLAYER 2: ',
			'GIRLFRIEND: ',
			'SONG SPEED: ',
			'DYNAMIC CAMERA: ',
			'IS VALID SCORE: '
		];

		for (i in 0...tempSpawn.length)
		{
			tempString += '\n				' + stuffThingie[i] + tempSpawn[i];
			tempString += ', ';
		}

		tempString += '\n				V1.03-BETA V1';

		trace(tempString);
		/*
			_song = {
				song: 'Test',
				notes: [],
				bpm: 150,
				needsVoices: true,
				player1: 'bf',
				player2: 'dad',
				gf: 'gf',
				speed: 1,
				camera: false,
				validScore: false
		};*/
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			strumLine.x += 10;

			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = antialiasing;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			// idk any other ways to do it so i just do this
			var noSongFadeArrows:Array<String> = [
				'fresh',
				'dadbattle',
				'south',
				'monster',
				'philly',
				'blammed',
				'high',
				'milf',
				'eggnog'
			];

			if (!noSongFadeArrows.contains(SONG.song.toLowerCase()) && isStoryMode || debugCutscene)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;

				switch (curStage)
				{
					case 'school' | 'schoolEvil':
						new FlxTimer().start(0.35 * i, function(tmr:FlxTimer)
						{
							new FlxTimer().start(0.15, function(tmr:FlxTimer)
							{
								if (babyArrow.y < strumLine.y)
									babyArrow.y += 2.5;
								if (babyArrow.alpha < 1)
									babyArrow.alpha += 0.25;
								if (babyArrow.y < strumLine.y || babyArrow.alpha < 1)
									tmr.reset(0.15);
							});
						});
					default:
						FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				}
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					enemyStrums.add(babyArrow);
					babyArrow.animation.finishCallback = function(name:String)
					{
						if (name == "confirm")
						{
							babyArrow.animation.play('static', true);
							babyArrow.centerOffsets();
						}
					}

				case 1:
					playerStrums.add(babyArrow);
					if (FlxG.save.data.botplay)
					{
						babyArrow.animation.finishCallback = function(name:String)
						{
							if (name == "confirm")
							{
								babyArrow.animation.play('static', true);
								babyArrow.centerOffsets();
							}
						}
					}
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			if (player == 1)
				babyArrow.x += 50;

			enemyStrums.forEach(function(spr:FlxSprite)
			{
				spr.centerOffsets();
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;

			FlxG.camera.active = false;
			camHUD.active = false;

			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, inputHandle);
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;

			FlxG.camera.active = true;
			camHUD.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end

			FlxG.camera.active = true;

			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, inputHandle);
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}
		#end

		// use an isPaused bool but not somewhere else :)
		if (startedCountdown && canPause && !isPaused)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		super.onFocusLost();
	}

	/*
		public static function changeSettings()
		{
			downscroll = FlxG.save.data.downscroll;
			// you're unfair, no ghosttapping and accuracy
			// ghostTap = FlxG.save.data.ghostTap;
			//accuracyType = FlxG.save.data.accuracy;
			quality = FlxG.save.data.quality;
			antialiasing = FlxG.save.data.antialiasing;
			bgSprites.forEach(function(spr:FlxSprite)
			{
				spr.antialiasing = antialiasing;
			});
	}*/
	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var stopFocusing:Bool = false;

	var lerpingScore:Float;

	var triggeredCamera:Bool = false;

	var beatList:Array<Dynamic> = [];

	var atBeatNum:Int = 0;
	var holdKey:Array<Float> = [0, 0, 0, 0];

	override public function update(elapsed:Float)
	{
		if (!SONG.camera)
		{
			camOffset = [];
		}

		lerpingScore = FlxMath.lerp(lerpingScore, songScore, 0.35 * (60 / Main.framerate));

		if (Math.abs(lerpingScore - songScore) <= 10)
			lerpingScore = songScore;

		// if (FlxG.keys.justPressed.F3 && FlxG.keys.justPressed.SHIFT)

		#if debug
		if (FlxG.keys.justPressed.F3 && FlxG.keys.justPressed.SHIFT)
		{
			for (sprite in debugSprite)
			{
				sprite.visible = !sprite.visible;
			}
		}
		#end
		#if !debug
		perfectMode = false;
		#end
		if (!inCutscene && daSongisPlaying)
			songHasStarted = FlxG.sound.music.playing;
		if (downscroll != FlxG.save.data.downscroll
			|| ghostTap != FlxG.save.data.ghostTap
			|| accuracyType != FlxG.save.data.accuracy
			|| scoreType != FlxG.save.data.scoreType)
		{
			changeSettings();
		}
		if (FlxG.keys.justPressed.F5)
		{
			FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		}
		if (FlxG.keys.justPressed.F6)
		{
			FlxG.save.data.ghostTap = !FlxG.save.data.ghostTap;
		}
		if (FlxG.keys.justPressed.F7)
		{
			if (FlxG.save.data.accuracy == 'simple')
				FlxG.save.data.accuracy = 'complex';
			else if (FlxG.save.data.accuracy == 'complex')
				FlxG.save.data.accuracy = 'none';
			else
				FlxG.save.data.accuracy = 'simple';
		}
		if (FlxG.keys.justPressed.F8)
		{
			if (FlxG.save.data.scoreType == 'new')
				FlxG.save.data.scoreType == 'old';
			else
				FlxG.save.data.scoreType == 'new';
		}
		if (FlxG.save.data.botplay)
			SONG.validScore = false;
		// changeSettings();
		if (!endingSong)
		{
			FlxG.sound.music.volume = FlxG.save.data.musicVolume / 100;
			if (SONG.needsVoices)
				vocals.volume = FlxG.save.data.vocalVolume / 100;
		}
		if (noPressTime > 0)
			noPressTime -= elapsed / 1000;
		// dividing it by 1000 is seconds.
		if (!songHasStarted)
			timerLeft = fakeInst.length / 1000;
		else if (endingSong)
			timerLeft = 0;
		else
			timerLeft = (songLength - Conductor.songPosition) / 1000;
		timerText.text = FlxStringUtil.formatTime(timerLeft, false);
		fixedSongScore = FlxStringUtil.formatMoney(lerpingScore, false, true);
		// fix the hair stop bug
		if (curStage == 'limo')
		{
			if (enemy.animation.curAnim.finished && !enemy.animation.curAnim.name.startsWith("sing"))
				enemy.dance();
			if (/*!boyfriend.animation.curAnim.name == 'idle' &&*/ boyfriend.animation.curAnim.finished
				&& !boyfriend.animation.curAnim.name.startsWith("sing"))
				boyfriend.playAnim('idle', true);
		}
		if (FlxG.save.data.botplay)
			botplayTxt.alpha = 0.25;
		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}
		/*
			if (FlxG.keys.justPressed.Q)
			{
				beatList.push(FlxMath.roundDecimal(Conductor.songPosition, 3));
				trace(beatList);
		}*/
		if (!curStage.startsWith('school'))
		{
			strumLineNotes.forEach(function(spr:FlxSprite)
			{
				spr.antialiasing = FlxG.save.data.antialiasing;
			});
		}
		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;
					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				phillyCityLights.members[curLight].alpha -= ((Conductor.crochet / 1000) * (FlxG.elapsed / (60 * Main.framerate))) * 1.2;
		}
		super.update(elapsed);
		AI.update(elapsed, 1);
		if (accuracyType != 'none')
			scoreTxt.text = "Score: " + fixedSongScore + " | " + misses + " Misses" + " | " + "Accuracy: " + updateAccuracy() + "% "
				+ '| Health Drain Multi: $healthMulti';
		else
			scoreTxt.text = "Score: " + fixedSongScore + " | " + misses + " Misses" + ' | Health Drain Multi: $healthMulti';
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;
			isPaused = true;
			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}
		#if (debug || tester)
		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, inputHandle);
			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}
		#end
		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);
		/*
			iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, 150,
				MathUtils.clamp(1 - (elapsed * 60), 0.25 / ((SONG.bpm * 0.65) / 60), 1 - (elapsed * 30)))));
			iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150,
				MathUtils.clamp(1 - (elapsed * 60), 0.25 / ((SONG.bpm * 0.65) / 60), 1 - (elapsed * 30)))));

			iconP1.updateHitbox();
			iconP2.updateHitbox();

			iconP1.centerOffsets();
			iconP2.centerOffsets(); */

		var iconOffset:Int = 26;

		if (iconDoneMove)
		{
			iconP1.x = FlxMath.lerp(iconP1.x,
				healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - (iconOffset - 4)),
				0.25 / ((SONG.bpm * 0.65) / 60));
			iconP2.x = FlxMath.lerp(iconP2.x,
				healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - (iconP2.width - iconOffset)),
				0.25 / ((SONG.bpm * 0.65) / 60));
		}
		if (health > 2)
			health = 2;
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;
		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;
		/* if (FlxG.keys.justPressed.NINE)
			FlxG.FlxG.switchState(new Charting()); */
		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, inputHandle);
			FlxG.switchState(new AnimationDebug(SONG.player2));
		}
		#end
		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;
				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}
			// Conductor.lastSongPos = FlxG.sound.music.time;
		}
		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}
			if (!stopFocusing)
			{
				if (camFollow.x != enemy.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					camFollow.setPosition(enemy.getMidpoint().x + 150, enemy.getMidpoint().y - 100);
					// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);
					var followX:Float = enemy.getMidpoint().x + 150;
					var followY:Float = enemy.getMidpoint().y - 100;

					switch (enemy.curCharacter)
					{
						case 'spooky':
							followY = boyfriend.getMidpoint().y - 140;
						case 'pico':
							followY = boyfriend.getMidpoint().y - 160;
						case 'mom':
							followY = enemy.getMidpoint().y;
						case 'senpai':
							followY = enemy.getMidpoint().y - 430;
							followX = enemy.getMidpoint().x - 90;
						case 'senpai-angry':
							followY = enemy.getMidpoint().y - 430;
							followX = enemy.getMidpoint().x - 90;
						case 'spirit':
							followX = enemy.getGraphicMidpoint().x + 300;
							followY = enemy.getGraphicMidpoint().y + 100;
						case 'james':
							followX = enemy.getMidpoint().x + 200;
							followY = enemy.getMidpoint().y - 110;
					}
					camFollow.x = followX + camOffset[0];
					camFollow.y = followY + camOffset[1];
					if (SONG.song.toLowerCase() == 'tutorial')
					{
						tweenCamIn();
					}
				}
				if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
				{
					camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

					var followX:Float = boyfriend.getMidpoint().x - 100;
					var followY:Float = boyfriend.getMidpoint().y - 100;
					switch (curStage)
					{
						case 'spooky':
							followY = boyfriend.getMidpoint().y - 140;
						case 'philly':
							followY = boyfriend.getMidpoint().y - 160;
						case 'limo':
							followX = boyfriend.getMidpoint().x - 300;
						case 'mall':
							followY = boyfriend.getMidpoint().y - 200;
						case 'school':
							followX = boyfriend.getMidpoint().x - 200;
							followY = boyfriend.getMidpoint().y - 200;
						case 'schoolEvil':
							followX = boyfriend.getMidpoint().x - 200;
							followY = boyfriend.getMidpoint().y - 200;
						case 'james':
							followX = boyfriend.getMidpoint().x - 100;
							followY = enemy.getMidpoint().y - 100;
					}
					camFollow.x = followX + camOffset[0];
					camFollow.y = followY + camOffset[1];
					if (SONG.song.toLowerCase() == 'tutorial')
					{
						FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
					}
				}
			}
			else
			{
				camFollow.x = gf.getGraphicMidpoint().x - 45;
				camFollow.y = gf.getGraphicMidpoint().y - 100;
				camFollow.x += camOffset[0];
				camFollow.y += camOffset[1];
			}
		}
		forceBeat = BeatSync.getSongPos(SONG.song.toLowerCase());
		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}
		if (forceBeat.length >= 1)
		{
			if (Conductor.songPosition >= forceBeat[atBeatNum] && atBeatNum != forceBeat.length)
			{
				FlxG.camera.zoom += (0.015 * (FlxG.save.data.musicVolume / 100)) / 2;
				camHUD.zoom += (0.03 * (FlxG.save.data.musicVolume / 100)) / 2;
				switch (curSong.toLowerCase())
				{
					case 'pico' | 'philly' | 'blammed':
						updateLights();
				}
				atBeatNum++;
			}
		}
		/*
			if (curSong.toLowerCase() == 'blammed')
			{
				if (forceBeat.contains(curStep))
				{
					if (!triggeredCamera)
					{
						FlxG.camera.zoom += 0.015 * (FlxG.save.data.musicVolume / 100);
						camHUD.zoom += 0.03 * (FlxG.save.data.musicVolume / 100);

						updateLights();
					}
					triggeredCamera = true;
				}
				else
				{
					triggeredCamera = false;
				}
		}*/

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit
		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			health = 0;
			trace("RESET = True");
		}
		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}
		if (health <= 0)
		{
			#if (tester || debug)
			if (FlxG.keys.pressed.SHIFT)
			{
			#else
			if (true)
			{
			#end
				boyfriend.stunned = true;
				persistentUpdate = false;
				persistentDraw = false;
				paused = true;
				vocals.stop();
				FlxG.sound.music.stop();
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, inputHandle);
				if (FlxG.random.bool(0.1))
					FlxG.switchState(new GitarooPause());
				else
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				// FlxG.FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
				#end
			}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);
				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}
		if (generatedMusic)
		{
			var daThing = notesHitArray.length - 1;
			while (daThing >= 0)
			{
				var speedNote:Date = notesHitArray[daThing];

				if (speedNote != null && speedNote.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(speedNote);
				else
					daThing = 0;
				daThing--;
			}
			nps = notesHitArray.length;
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height && !downscroll || daNote.y < -FlxG.height && downscroll)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}
				if (daNote.isSustainNote)
				{
					if (daNote.prevNote.tooLate)
						daNote.prevNote.alpha = 0.3;
					else
						daNote.prevNote.alpha = 1;
				}
				else
				{
					if (daNote.tooLate)
						daNote.alpha = 0.3;
					else
						daNote.alpha = 1;
				}
				if (daNote.isSustainNote)
				{
					if (daNote.mustPress)
						daNote.x = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x) + 37;
					else
						daNote.x = (enemyStrums.members[Math.floor(Math.abs(daNote.noteData))].x) + 37;
				}
				else
				{
					if (daNote.mustPress)
					{
						daNote.x = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x);
					}
					else
					{
						daNote.x = (enemyStrums.members[Math.floor(Math.abs(daNote.noteData))].x);
					}
				}
				// sorry kade dev :(
				if (downscroll)
				{
					if (daNote.mustPress)
						daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
							+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2))
							- daNote.noteYOff;
					else
						daNote.y = (enemyStrums.members[Math.floor(Math.abs(daNote.noteData))].y
							+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2))
							- daNote.noteYOff;
					if (daNote.isSustainNote)
					{
						// Remember = minus makes notes go up, plus makes them go down
						if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
							daNote.y += daNote.prevNote.height;
						else
							daNote.y += daNote.height / 2;
						if (daNote.isSustainNote
							&& (!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit)
							&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
						{
							var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.height = ((strumLine.y + Note.swagWidth / 2) - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;
							daNote.clipRect = swagRect;
						}
					}
				}
				else
				{
					if (daNote.mustPress)
						daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
							- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2))
							+ daNote.noteYOff;
					else
						daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
							- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2))
							+ daNote.noteYOff;
					if (daNote.isSustainNote)
					{
						daNote.y -= daNote.height / 2;
						if ((daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit)
							&& daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2)
							&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
						{
							// Clip to strumline
							var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
							swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;
							daNote.clipRect = swagRect;
						}
					}
				}
				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;
					var altAnim:String = "";
					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}
					camOffset[0] = 0;
					camOffset[1] = 0;
					switch (Math.abs(daNote.noteData))
					{
						case 0:
							enemy.playAnim('singLEFT' + altAnim, true);
							camOffset[0] = -15;
						case 1:
							enemy.playAnim('singDOWN' + altAnim, true);
							camOffset[1] = 15;
						case 2:
							enemy.playAnim('singUP' + altAnim, true);
							camOffset[1] = -15;
						case 3:
							enemy.playAnim('singRIGHT' + altAnim, true);
							camOffset[0] = 15;
					}
					enemyStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(daNote.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
						if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
						{
							spr.centerOffsets();
							spr.offset.x -= 13;
							spr.offset.y -= 13;
						}
						else
							spr.centerOffsets();
					});
					enemy.holdTimer = 0;
					if (SONG.needsVoices)
						vocals.volume = FlxG.save.data.vocalVolume / 100;
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
				if ((daNote.y < -daNote.height && !downscroll) || (daNote.y > FlxG.height + daNote.height && downscroll))
				{
					if (daNote.tooLate || !daNote.wasGoodHit)
					{
						vocals.volume = 0;
						if (!FlxG.save.data.botplay)
						{
							if (!daNote.cannotBePressed)
							{
								health -= (0.0475 / 2) * healthMulti;
								if (!daNote.isSustainNote)
									noteMiss(daNote.noteData, daNote);
							}
						}
						else
						{
							if (!daNote.cannotBePressed)
								goodNoteHit(daNote);
						}
					}
					daNote.active = false;
					daNote.visible = false;
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});

			/*if (curStep > 2)
			{
				for (i in 0...debugSprite.length)
				{
					debugSprite.members[i].y = notes.members[notes.members.indexOf(notes.members[i])].y;
				}
		}*/
			enemyStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});

			if (!inCutscene)
				keyShit();
			var dontDoNotes:Bool = false;
			var closestNote:Note = notes.members[0];

			for (note in notes.members)
			{
				if (!note.alive)
					continue;
				else
					closestNote = note;
			}
			if (notes.members[0] != null)
			{
				if (controls.LEFT && playerStrums.members[0].animation.curAnim.name == 'confirm' && !closestNote.canBeHit)
					holdKey[0] += elapsed * (60 / Main.framerate);
				else
					holdKey[0] = 0;
				if (controls.DOWN && playerStrums.members[1].animation.curAnim.name == 'confirm' && !closestNote.canBeHit)
					holdKey[1] += elapsed * (60 / Main.framerate);
				else
					holdKey[1] = 0;
				if (controls.UP && playerStrums.members[2].animation.curAnim.name == 'confirm' && !closestNote.canBeHit)
					holdKey[2] += elapsed * (60 / Main.framerate);
				else
					holdKey[2] = 0;
				if (controls.RIGHT && playerStrums.members[3].animation.curAnim.name == 'confirm' && !closestNote.canBeHit)
					holdKey[3] += elapsed * (60 / Main.framerate);
				else
					holdKey[3] = 0;
			}
			for (i in 0...playerStrums.length)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					// mah boi you've been holding that for 0.45 second
					if (playerStrums.members[i].animation.curAnim.name == 'confirm'
						&& daNote.strumTime > Conductor.songPosition + Conductor.stepCrochet + (Conductor.safeZoneOffset * 4)
						&& daNote.strumTime < Conductor.songPosition + Conductor.stepCrochet + (Conductor.safeZoneOffset * 16)
						&& daNote.mustPress
						&& !daNote.canBeHit)
					{
						if (holdKey[i] > 0.45)
						{
							playerStrums.members[i].animation.play('pressed');
							playerStrums.members[i].animation.curAnim.curFrame = playerStrums.members[i].animation.curAnim.frames.length;
							holdKey[i] = 0;
							var key:Array<Bool> = [
								controls.LEFT
								&& playerStrums.members[i].animation.curAnim.name == 'confirm',
								controls.DOWN
								&& playerStrums.members[i].animation.curAnim.name == 'confirm',
								controls.UP
								&& playerStrums.members[i].animation.curAnim.name == 'confirm',
								controls.RIGHT
								&& playerStrums.members[i].animation.curAnim.name == 'confirm'];
							var dontPlayIdle:Bool = false;
							for (j in 0...playerStrums.length)
							{
								if (i != j)
								{
									if (key[j])
									{
										dontPlayIdle = true;
										break;
									}
								}
							}
							if (boyfriend.animation.curAnim.name.startsWith('sing') && !dontPlayIdle)
								boyfriend.playAnim('idle');
						}
					}
					else if (playerStrums.members[i].animation.curAnim.name == 'confirm' && holdKey[i] > 4 && !daNote.canBeHit)
					{
						if (holdKey[i] > 0.45)
						{
							playerStrums.members[i].animation.play('pressed');
							playerStrums.members[i].animation.curAnim.curFrame = playerStrums.members[i].animation.curAnim.frames.length;
							holdKey[i] = 0;
							if (boyfriend.animation.curAnim.name.startsWith('sing'))
								boyfriend.playAnim('idle');
						}
					}
				});
			}
			#if debug
			if (FlxG.keys.justPressed.ONE)
				endSong();
			#end
		}
	}

	function endSong():Void
	{
		endingSong = true;

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		if (SONG.validScore)
		{
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
		}

		if (isStoryMode || debugCutscene)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(GameData.globalMusic);

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				// do it because debug?
				if (isStoryMode)
					FlxG.switchState(new StoryMenuState());
				else
					FlxG.switchState(new FreeplayState());

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				switch (SONG.song.toLowerCase())
				{
					case 'eggnog' | 'south':
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(Std.int((FlxG.width * 3) * FlxG.camera.zoom),
							Std.int((FlxG.height * 3) * FlxG.camera.zoom), FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						if (SONG.song.toLowerCase() == 'south')
							FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2), FlxG.save.data.soundVolume / 100);
						else
							FlxG.sound.play(Paths.sound('Lights_Shut_off'), FlxG.save.data.soundVolume / 100);

						new FlxTimer().start(3, function(tmr:FlxTimer)
						{
							nextSong(difficulty);
						});
					case 'roses':
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(Std.int((FlxG.width * 3) / FlxG.camera.zoom),
							Std.int((FlxG.height * 3) / FlxG.camera.zoom), FlxColor.BLACK);
						blackShit.scrollFactor.set();
						blackShit.alpha = 0;
						blackShit.cameras = [camGame, camHUD];
						add(blackShit);

						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							var daLoop:Int = 0;
							new FlxTimer().start(0.15, function(tmr:FlxTimer)
							{
								daLoop++;
								blackShit.alpha += 1 / 5;
								if (daLoop == 6)
								{
									new FlxTimer().start(2.5, function(tmr:FlxTimer)
									{
										nextSong(difficulty);
									});
								}
							}, 9);
						});
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				if (SONG.song.toLowerCase() != 'roses')
				{
					var dontSkip:Array<String> = ['roses', 'eggnog', 'south'];

					if (!dontSkip.contains(SONG.song.toLowerCase()))
					{
						trace('skip shit');
						nextSong(difficulty);
					}
				}
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxG.sound.playMusic(GameData.globalMusic);
			FlxG.switchState(new FreeplayState());
		}
	}

	function nextSong(difficShit:String)
	{
		var prevSong = SONG;
		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficShit, PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();

		switch (prevSong.song.toLowerCase())
		{
			case 'restless-dreams':
				FlxG.switchState(new PlayState());
			default:
				FlxG.switchState(new PlayState());
		}
	}

	private function popUpScore(strumtime:Float, isSustainNote:Bool = false):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = FlxG.save.data.vocalVolume / 100;

		if (FlxG.save.data.botplay)
			noteDiff = 0;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > 135)
		{
			daRating = 'shit';
			comboList[3]++;
		}
		else if (noteDiff > 90)
		{
			daRating = 'bad';
			comboList[2]++;
		}
		else if (noteDiff > 45)
		{
			daRating = 'good';
			comboList[1]++;
		}

		if (daRating == "sick")
			comboList[0]++;

		if (!isSustainNote)
			score = ScoreFunctions.calculateNote(daRating, noteDiff);

		var differ:Float = 0;

		if (FlxG.save.data.botplay)
		{
			differ = AI.calculateHit(notes.members[0], 0.2, 2, 0.1);
			trace(differ);
		}

		if (accuracyType == 'wife3')
		{
			if (FlxG.save.data.botplay)
				totalRanksHit += AccuracyHelper.wif3(differ, Conductor.safeZoneOffset / 166);
			else
				totalRanksHit += AccuracyHelper.wif3(noteDiff, Conductor.safeZoneOffset / 166);
		}
		else if (accuracyType == 'combo rating')
		{
			if (daRating == 'sick')
				totalRanksHit += 1;
			else if (daRating == 'good')
				totalRanksHit += 0.75;
			else if (daRating == 'bad')
				totalRanksHit += 0.50;
			else if (daRating == 'shit')
				totalRanksHit += 0.25;
		}
		else if (accuracyType == 'combo calculation')
		{
			if (noteDiff < 15)
				totalRanksHit += 1;
			else
				totalRanksHit += 1 - (noteDiff / Conductor.safeZoneOffset);
		}
		else
		{
			if (daRating == 'sick')
				totalRanksHit += 1;
			else if (daRating == 'good')
				totalRanksHit += 0.75;
			else if (daRating == 'bad')
				totalRanksHit += 0.50;
			else if (daRating == 'shit')
				totalRanksHit += 0.25;
		}

		totalNotesHit += 1;

		accuracyHistory.push(totalRanksHit / totalNotesHit);

		songScore += score;

		/* if (combo > 60)
			daRating = 'sick';
		else if (combo > 12)
			daRating = 'good'
		else if (combo > 4)
			daRating = 'bad';
	 */

		/*var addedScoreText:FlxText = new FlxText(0, 0, 0, "(+0)", 24);
		addedScoreText.setFormat(GameData.globalFont, 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		addedScoreText.text = '(+$score)';
		if (score < 0)
			addedScoreText.text = '($score)';
		addedScoreText.screenCenter();
		addedScoreText.x = scoreTxt.x + 25;
		addedScoreText.y = scoreTxt.y + scoreTxt.height + 4;
		addedScoreText.cameras = [camHUD];
		addedScoreText.font = curStage.startsWith('school') ? Paths.font('vcr') : GameData.globalFont;
		add(addedScoreText);

		FlxTween.tween(addedScoreText, {alpha: 0}, Conductor.stepCrochet * 0.002, {
			onComplete: function(twn:FlxTween)
			{
				addedScoreText.destroy();
			}
		});*/

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = antialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = antialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		var stringCombo:String = Std.string(combo);

		for (i in 0...stringCombo.length)
		{
			seperatedScore.push(Std.int(Std.parseFloat(stringCombo.charAt(i))));
		}

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = (coolText.x + (43 * daLoop) - 90) - 20 * seperatedScore.length;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = antialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (totalNotesHit != 0)
				add(numScore);

			FlxTween.tween(numScore, {angle: FlxG.random.float(-14, 14)}, 1);
			
			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
		trace(combo);
		trace(seperatedScore);
	 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	var timerKey:FlxTimer = new FlxTimer();

	private function keyShit():Void // I've invested in emma stocks
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		var releaseArray:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];
		var dirArray:Array<Float> = [-15, 15, -15, 15];
		var allArrays:Array<Array<Bool>> = [holdArray, pressArray];

		notes.forEachAlive(function(daNote:Note)
		{
			for (array in allArrays)
			{
				if (array.contains(true) && daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;
				}
			}
		});

		// Prevent player input if botplay is on
		if (FlxG.save.data.botplay)
		{
			holdArray = [false, false, false, false];
			pressArray = [false, false, false, false];
			releaseArray = [false, false, false, false];
		}
		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData] && !daNote.tooLate)
				{
					for (i in 0...holdArray.length)
					{
						camOffset[0] = 0;
						camOffset[1] = 0;

						if (holdArray[i] == true)
						{
							// check dir
							switch (i)
							{
								case 0 | 3:
									camOffset[0] = dirArray[i];
								case 1 | 2:
									camOffset[1] = dirArray[i];
							}
						}
					}

					goodNoteHit(daNote);
				}
				else if (daNote.isSustainNote && daNote.tooLate)
					daNote.kill();
			});
		}

		// PRESSES, check for note hits
		if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var forbiddenDistance:Int = 10;

			var possibleNotes:Array<Note> = []; // notes that can be hit
			var directionList:Array<Int> = []; // directions that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.wasGoodHit && !daNote.cannotBePressed)
				{
					if (directionList.contains(daNote.noteData))
					{
						for (coolNote in possibleNotes)
						{
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < forbiddenDistance)
							{ // if it's the same note twice at < 10ms distance, just delete it
								// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
								dumbNotes.push(daNote);
								break;
							}
							else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
							{ // if daNote is earlier than existing note (coolNote), replace
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});

			for (note in dumbNotes)
			{
				trace('killin note at '
					+ Std.string(note.strumTime - Conductor.songPosition)
					+ ' ms ('
					+ FlxStringUtil.formatTime(Conductor.songPosition / 1000, true)
					+ ')');
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			var dontCheck = false;

			for (i in 0...pressArray.length)
			{
				if (pressArray[i] && !directionList.contains(i))
					dontCheck = true;
			}

			if (perfectMode)
			{
				for (leNote in possibleNotes)
				{
					if (pressArray[leNote.noteData] && !dontCheck)
					{
						goodNoteHit(leNote);
					}
				}
			}
			else if (possibleNotes.length > 0 && !dontCheck)
			{
				if (!ghostTap)
				{
					for (shit in 0...pressArray.length)
					{ // if a direction is hit that shouldn't be
						if (pressArray[shit] && !directionList.contains(shit))
							noteMiss(shit, null);
					}
				}

				for (coolNote in possibleNotes)
				{
					for (i in 0...pressArray.length)
					{
						camOffset[0] = 0;
						camOffset[1] = 0;

						if (pressArray[i] == true)
						{
							// check dir
							switch (i)
							{
								case 0 | 3:
									camOffset[0] = dirArray[i];
								case 1 | 2:
									camOffset[1] = dirArray[i];
							}
						}
					}

					if (pressArray[coolNote.noteData])
					{
						if (mashViolations != 0)
							mashViolations--;
						scoreTxt.color = FlxColor.WHITE;
						goodNoteHit(coolNote);
					}
				}
			}
			else if (!ghostTap)
			{
				for (shit in 0...pressArray.length)
					if (pressArray[shit])
						noteMiss(shit, null);
			}

			var numPresses:Int = 0;
			for (shit in 0...pressArray.length)
			{
				if (possibleNotes.length > 0 && ghostTap)
				{
					if (pressArray[shit])
						numPresses++;
				}
			}

			if (numPresses == 4)
			{
				mashViolations++;
				numPresses = 0;
			}

			if (dontCheck && possibleNotes.length > 0 && ghostTap && !FlxG.save.data.botplay)
			{
				if (mashViolations > 6)
				{
					trace('mash violations ' + mashViolations);
					scoreTxt.color = FlxColor.RED;
					noteMiss(0, null);
				}
			}
		}

		notes.forEachAlive(function(daNote:Note)
		{
			if (downscroll && daNote.y > strumLine.y || !downscroll && daNote.y < strumLine.y)
			{
				// Force good note hit regardless if it's too late to hit it or not as a fail safe
				if ((FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress || FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress))
				{
					/*if (!daNote.isSustainNote)
					trace(AI.calculateHit(notes.members[0], 0.2, 1, 0.1)); */
					if (!daNote.cannotBePressed)
						goodNoteHit(daNote);
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(daNote.noteData) == spr.ID && !daNote.cannotBePressed)
						{
							spr.animation.play('confirm', true);
						}
						if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
						{
							spr.centerOffsets();
							spr.offset.x -= 13;
							spr.offset.y -= 13;
						}
						else
							spr.centerOffsets();
					});
					boyfriend.holdTimer = daNote.sustainLength;
				}
			}
		});

		// if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !holdArray.contains(true))
		// ALWAYS PRIORITIZE THE FIRST ANIMATION
		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !holdArray[animSprOrder(boyfriend)])
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.playAnim('idle');
		}
		if (!FlxG.save.data.botplay)
		{
			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
					spr.animation.play('pressed');
				if (!holdArray[spr.ID])
					spr.animation.play('static');
				if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				else
					spr.centerOffsets();
			});
		}
	}

	function animSprOrder(spr:FlxSprite):Int
	{
		if (spr.animation.curAnim != null && animOrder.exists(spr.animation.curAnim.name))
			return animOrder.get(spr.animation.curAnim.name);

		return 0;
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned && Conductor.songPosition > 0)
		{
			if (!hudTween && scoreTxt.alpha != 1)
			{
				scoreTxt.y -= 20;
				FlxTween.tween(scoreTxt, {y: scoreTxt.y + 20, alpha: 1}, 1, {ease: FlxEase.quadOut});
				hudTween = true;
			}

			health -= (0.04 / 2) * healthMulti;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}

			combo = 0;
			misses += 1;

			songScore -= 25;

			if (FlxG.save.data.soundVolume > 20)
				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			else
				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.save.data.soundVolume / 100);
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}
		}
	}

	/* no
	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		if (leftP)
			noteMiss(0);
		if (downP)
			noteMiss(1);
		if (upP)
			noteMiss(2);
		if (rightP)
			noteMiss(3);
	}
 */
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
	{
		// this is copy pasted but idc
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

		// note.rating = Ratings.CalculateRating(noteDiff);

		if (controlArray[note.noteData])
		{
			goodNoteHit(note);

			/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
			{
				mashViolations++;
				goodNoteHit(note, (mashing > getKeyPresses(note)));
			}
			else if (mashViolations > 2)
			{
				// this is bad but fuck you
				playerStrums.members[0].animation.play('static');
				playerStrums.members[1].animation.play('static');
				playerStrums.members[2].animation.play('static');
				playerStrums.members[3].animation.play('static');
				health -= 0.4;
				trace('mash ' + mashing);
				if (mashing != 0)
					mashing = 0;
			}
			else
				goodNoteHit(note, false); */
		}
	}

	var hudTween:Bool;

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			// cant believe i have to copy paste this shit
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);
			var wasHalo:Bool = false;

			if (!hudTween && scoreTxt.alpha != 1)
			{
				scoreTxt.y -= 20;
				FlxTween.tween(scoreTxt, {y: scoreTxt.y + 20, alpha: 1}, 1, {ease: FlxEase.quadOut});
				hudTween = true;
			}

			if (note.noteType == HALO)
			{
				if (healthMulti <= 10)
					healthMulti++;
				noteMiss(note.noteData, note);
				wasHalo = true;
			}
			else if (note.noteType == SEAL)
			{
				if (healthMulti >= 0)
					healthMulti--;
			}

			healthMulti = Std.int(MathUtils.clamp(1, 10, healthMulti));

			if (!wasHalo)
			{
				if (FlxG.save.data.botplay)
					noteDiff = 0;

				lastNoteDiff = noteDiff;

				var daRating:String = "sick";

				if (!FlxG.save.data.botplay)
				{
					if (noteDiff > Conductor.safeZoneOffset * 0.9)
						daRating = 'shit';
					else if (noteDiff > Conductor.safeZoneOffset * 0.75)
						daRating = 'bad';
					else if (noteDiff > Conductor.safeZoneOffset * 0.2)
						daRating = 'good';
				}

				if (!note.isSustainNote)
				{
					notesHitArray.unshift(Date.now());
					curNoteType = 'note';
					popUpScore(note.strumTime, note.isSustainNote);
					combo += 1;
				}
				else
				{
					curNoteType = 'held';
					songScore += ScoreFunctions.calculateHeld(daRating, noteDiff);
				}

				if (note.noteData >= 0)
					health += 0.023;
				else
					health += 0.004;

				switch (note.noteData)
				{
					case 0:
						boyfriend.playAnim('singLEFT', true);
					case 1:
						boyfriend.playAnim('singDOWN', true);
					case 2:
						boyfriend.playAnim('singUP', true);
					case 3:
						boyfriend.playAnim('singRIGHT', true);
				}
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			if (!wasHalo)
			{
				note.wasGoodHit = true;
				vocals.volume = FlxG.save.data.vocalVolume / 100;
			}

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	var alreadyChanged:Bool = false;
	var disqualifyTxt:FlxText;

	public function changeSettings()
	{
		scoreType = FlxG.save.data.scoreType;
		downscroll = FlxG.save.data.downscroll;
		accuracyType = FlxG.save.data.accuracy;
		ghostTap = FlxG.save.data.ghostTap;
		scoreType = FlxG.save.data.scoreType;
		Conductor.offset = FlxG.save.data.noteOffset;

		SONG.validScore = false;

		if (downscroll)
			strumLine.y = 550;
		else
			strumLine.y = 50;

		if (downscroll)
		{
			strumLine.y = FlxG.height - 165;
			healthBarBG.y = FlxG.height * 0.1;
		}
		else
		{
			healthBarBG.y = FlxG.height * 0.9;
		}
		healthBar.y = healthBarBG.y + 4;
		scoreTxt.y = healthBarBG.y + healthBarBG.height + 10;
		iconP1.y = healthBar.y - (iconP2.height / 2);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		timerText.y = strumLine.y + 45;
		strumLineNotes.forEach(function(spr:FlxSprite)
		{
			spr.y = strumLine.y;
		});

		if (!alreadyChanged)
		{
			alreadyChanged = true;
			disqualifyTxt = new FlxText(FlxG.width, downscroll ? timerText.y + 70 : timerText.y - 70, 0, "Your score is disqualified.", 24);
			disqualifyTxt.setFormat(GameData.globalFont, 22, FlxColor.RED, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			disqualifyTxt.alpha = 0;
			disqualifyTxt.font = curStage.startsWith('school') ? Paths.font('vcr') : GameData.globalFont;
			disqualifyTxt.screenCenter(X);
			disqualifyTxt.cameras = [camHUD];
			add(disqualifyTxt);
			FlxTween.tween(disqualifyTxt, {alpha: 1}, 0.6, {
				onComplete: function(twn:FlxTween)
				{
					new FlxTimer().start(4, function(tmr:FlxTimer)
					{
						disqualifyTxt.alpha = 0;
					});
				}
			});
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		if (FlxG.save.data.soundVolume > 70)
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);
		else
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), FlxG.save.data.soundVolume / 100);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;
	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2), FlxG.save.data.soundVolume / 100);
		if (animFreq == 'maximum')
			halloweenBG.animation.play('lightning');
		else
			FlxG.camera.flash();

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		iconP1.animation.play('scared-bf');
		// idk why my other methods dont work
		new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			iconP1.animation.play(SONG.player1);
		});
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (enemy.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// enemy.dance();
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	var milfActive:Bool = false;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (curStage != 'limo')
			{
				if (SONG.notes[Math.floor(curStep / 16)].mustHitSection
					|| !enemy.animation.curAnim.name.startsWith("sing")
					&& enemy.curCharacter != 'gf')
					enemy.dance();
			}
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf'
			&& curBeat >= 168
			&& curBeat < 200
			&& camZooming
			&& FlxG.camera.zoom < 1.3
			&& forceBeat.length < 1)
		{
			milfActive = true;
			FlxG.camera.zoom += 0.015 * (FlxG.save.data.musicVolume / 100);
			camHUD.zoom += 0.03 * (FlxG.save.data.musicVolume / 100);
		}
		else
			milfActive = false;

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0 && !milfActive)
		{
			if (forceBeat.length < 1)
			{
				FlxG.camera.zoom += 0.015 * (FlxG.save.data.musicVolume / 100);
				camHUD.zoom += 0.03 * (FlxG.save.data.musicVolume / 100);
			}
		}

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					gfSpeed = 2;
					for (spr in bgSprites.members)
					{
						FlxTween.tween(spr.colorTransform, {blueOffset: 130, redOffset: 30}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
					}

					FlxTween.tween(FlxG.camera, {zoom: 1.1}, (Conductor.stepCrochet * 16 / 1000), {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						{
							defaultCamZoom = 1.1;
						}
					});

					FlxTween.tween(boyfriend.colorTransform, {blueOffset: 70, redOffset: 30}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
					FlxTween.tween(enemy.colorTransform, {blueOffset: 70, redOffset: 30}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
					FlxTween.tween(gf.colorTransform, {blueOffset: 70, redOffset: 30}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});

				case 48:
					gfSpeed = 1;
					for (spr in bgSprites.members)
					{
						FlxTween.tween(spr.colorTransform, {blueOffset: 0, redOffset: 0}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
					}

					FlxTween.tween(FlxG.camera, {zoom: 0.9}, (Conductor.stepCrochet * 16 / 1000), {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						{
							defaultCamZoom = 0.9;
						}
					});

					FlxTween.tween(boyfriend.colorTransform, {blueOffset: 0, redOffset: 0}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
					FlxTween.tween(enemy.colorTransform, {blueOffset: 0, redOffset: 0}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
					FlxTween.tween(gf.colorTransform, {blueOffset: 0, redOffset: 0}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
				case 80:
					gfSpeed = 2;
					for (spr in bgSprites.members)
					{
						FlxTween.tween(spr.colorTransform, {blueOffset: 70, redOffset: 30}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
					}

					FlxTween.tween(FlxG.camera, {zoom: 1.1}, (Conductor.stepCrochet * 16 / 1000), {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						{
							defaultCamZoom = 1.1;
						}
					});

					FlxTween.tween(boyfriend.colorTransform, {blueOffset: 70, redOffset: 30}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
					FlxTween.tween(enemy.colorTransform, {blueOffset: 70, redOffset: 30}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
					FlxTween.tween(gf.colorTransform, {blueOffset: 70, redOffset: 30}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
				case 112:
					gfSpeed = 1;
					for (spr in bgSprites.members)
					{
						FlxTween.tween(spr.colorTransform, {blueOffset: 0, redOffset: 0}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
					}

					FlxTween.tween(FlxG.camera, {zoom: 0.9}, (Conductor.stepCrochet * 16 / 1000), {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween)
						{
							defaultCamZoom = 0.9;
						}
					});

					FlxTween.tween(boyfriend.colorTransform, {blueOffset: 0, redOffset: 0}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
					FlxTween.tween(enemy.colorTransform, {blueOffset: 0, redOffset: 0}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
					FlxTween.tween(gf.colorTransform, {blueOffset: 0, redOffset: 0}, (Conductor.stepCrochet * 16 / 1000), {ease: FlxEase.quadInOut});
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.FlxG.switchState(new TitleState());
			}
		}

		if (curBeat % gfSpeed == 0 && curBeat % 4 != 0)
		{
			/*
			iconP1.setGraphicSize(Std.int(iconP1.width + (30 * (FlxG.save.data.musicVolume / 100))));
			iconP2.setGraphicSize(Std.int(iconP2.width + (30 * (FlxG.save.data.musicVolume / 100)))); */

			iconP1.scale.x = 1;
			iconP1.scale.y = 1;
			iconP2.scale.x = 1;
			iconP2.scale.y = 1;

			FlxTween.tween(iconP1.scale, {x: 1.15, y: 1.15}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
			FlxTween.tween(iconP2.scale, {x: 1.15, y: 1.15}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});

			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}
		else
		{
			iconP1.scale.x = 1;
			iconP1.scale.y = 1;
			iconP2.scale.x = 1;
			iconP2.scale.y = 1;

			if (camZooming)
			{
				if (FlxG.random.weightedPick([healthBar.percent, 100 - healthBar.percent]) == 0)
				{
					FlxTween.tween(iconP1.scale, {x: 1.5, y: 1.5}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
					FlxTween.tween(iconP2.scale, {x: 1.15, y: 1.15}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
				}
				else
				{
					FlxTween.tween(iconP2.scale, {x: 1.5, y: 1.5}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
					FlxTween.tween(iconP1.scale, {x: 1.15, y: 1.15}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
				}
			}
			else
			{
				FlxTween.tween(iconP1.scale, {x: 1.15, y: 1.15}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
				FlxTween.tween(iconP2.scale, {x: 1.15, y: 1.15}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
			}

			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}

		if (curBeat % gfSpeed == 0)
			gf.dance();

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
			boyfriend.playAnim('idle');

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
			boyfriend.playAnim('hey', true);

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && enemy.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			enemy.playAnim('cheer', true);
		}

		if (curBeat == 47 || curBeat == 111)
		{
			if (curSong == 'Bopeebo')
			{
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					boyfriend.playAnim('hey', true);
				});
			}
		}

		if (curBeat == 183 || curBeat == 200)
		{
			if (SONG.song.toLowerCase() == 'eggnog')
				stopFocusing = !stopFocusing;
		}

		switch (curStage)
		{
			case 'spooky':

			case 'school':
				if (animFreq == 'maximum')
					bgGirls.dance();

			case 'mall':
				if (animFreq == 'maximum')
				{
					if (quality != 'low')
					{
						upperBoppers.animation.play('bop', true);
						bottomBoppers.animation.play('bop', true);
					}
					santa.animation.play('idle', true);
				}

			case 'limo':
				if (quality != 'low' && animFreq == 'maximum' && animFreq != 'none' && animFreq != 'minimal')
				{
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});
				}

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;
				if (curBeat == 4)
					phillyCityLights.members[0].visible = true;

				if ((curBeat % 4 == 0) && forceBeat.length < 1)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1, [curLight]);

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	function updateCam(speed:Float)
	{
		FlxG.camera.follow(camFollow, LOCKON, (0.04 * (30 / Main.framerate)) / speed);
	}

	function updateLights()
	{
		if (quality == 'high')
		{
			phillyCityLights.members[0].alpha = 1;
			phillyCityLights.members[0].setColorTransform(1, 1, 1, 1, FlxG.random.int(-175, 0), FlxG.random.int(-175, 0), FlxG.random.int(-175, 0), 0);
		}
		else
		{
			phillyCityLights.forEach(function(light:FlxSprite)
			{
				light.visible = false;
			});

			curLight = FlxG.random.int(0, phillyCityLights.length - 1, [curLight]);

			phillyCityLights.members[curLight].visible = true;
			phillyCityLights.members[curLight].alpha = 1;
		}
	}
}
