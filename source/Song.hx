package;

import flixel.FlxG;
import Section.SwagSection;
import haxe.Json;
import haxe.Http;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Int;
	var needsVoices:Bool;
	var speed:Float;
	var camera:Bool;

	var player1:String;
	var player2:String;
	var gf:String;
	var validScore:Bool;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Int;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;
	public var camera:Bool = false;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var gf:String = 'gf';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = Assets.getText(Paths.json(folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}

		// FIX THE CASTING ON WINDOWS/NATIVE
		// Windows???
		// trace(songData);

		// trace('LOADED FROM JSON: ' + songData.notes);
		/* 
			for (i in 0...songData.notes.length)
			{
				trace('LOADED FROM JSON: ' + songData.notes[i].sectionNotes);
				// songData.notes[i].sectionNotes = songData.notes[i].sectionNotes
			}

				daNotes = songData.notes;
				daSong = songData.song;
				daBpm = songData.bpm; */

		return parseJSONshit(rawJson);
	}

	public static function loadFromHttp(http:String)
	{
		var rawJson = '';
		
		var data = new Http(http);

		data.onData = function(data:String)
		{
			rawJson = data;
			trace(data);
		}

		data.onError = function(error)
		{
			FlxG.log.error('ERROR! Could not load from site: ' + error);
			trace('ERROR! Could not load from site: ' + error);
			return parseJSONshit(Assets.getText(Paths.json('tutorial'.toLowerCase() + '/' + 'tutorial'.toLowerCase())).trim());
		}

		data.request();

		var looped:Int = 0;

		// trace(rawJson.indexOf('Spookeez'));
		
		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
			looped++;

			if (looped >= 1500)
			{
				looped = 0;
				break;
			}
		}

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
