package;

import flixel.FlxG;
import flixel.addons.api.FlxGameJolt;
import haxe.crypto.Md5;
import haxe.crypto.Sha1;

class GameJolt
{
	public static var hashType:Int = FlxGameJolt.HASH_MD5;

	public static var keyID:Int = 0;
	public static var privateKey:String = ""; // DO NOT STORE THIS KEY AS A STRING IN YOUR MOD!!!!!!!

	/**
	 * Various common strings required by the API's HTTP values.
	 */
	private static inline var URL_API:String = "http://gamejolt.com/api/game/v1/";

	private static inline var RETURN_TYPE:String = "?format=keypair";
	private static inline var URL_GAME_ID:String = "&game_id=";
	private static inline var URL_USER_NAME:String = "&username=";
	private static inline var URL_USER_TOKEN:String = "&user_token=";

    
}
