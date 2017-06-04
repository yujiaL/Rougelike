package;

import states.PlayState;
import states.TitleState;
import flixel.system.FlxAssets;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.Tutorial;

class Main extends Sprite
{
	public static var LOGGER:CapstoneLogger;
	
	public function new()
	{
		super();
		
		// Change font.
		FlxAssets.FONT_DEFAULT = AssetPaths.Dventure__ttf;
		
		// Randomly assign game version.
		if (FlxG.random.bool(50))
			GlobalVariable.REVIVE = true;
		else
			GlobalVariable.REVIVE = false;
		
		if (FlxG.random.bool(50))
			GlobalVariable.LIMIT = true;
		else
			GlobalVariable.LIMIT = false;
		
		// Loggings.
		if (GlobalVariable.LOGGING)
		{
			var gameId:Int = 1700;
			var gameKey:String = "86ba54e08dfe7dc76e36075f8c819700";
			var gameName:String = "hairyball";
			
			var categoryId:Int;
			
			if (GlobalVariable.REVIVE)
				if (GlobalVariable.LIMIT)
					categoryId = 7;
				else
					categoryId = 8;
			else
				if (GlobalVariable.LIMIT)
					categoryId = 9;
				else
					categoryId = 10;
			
			Main.LOGGER = new CapstoneLogger(gameId, gameName, gameKey, categoryId, 1, false);
			
			// Retrieve the user (saved in local storage for later)
			var userId:String = Main.LOGGER.getSavedUserId();
			if (userId == null)
			{
				userId = Main.LOGGER.generateUuid();
				Main.LOGGER.setSavedUserId(userId);
			}
			Main.LOGGER.startNewSession(userId, this.onSessionReady);
		}
		else
		{
			addChild(new FlxGame(1024, 768, Tutorial));
		}
	}
	
	private function onSessionReady(sessionRecieved:Bool):Void
	{
		addChild(new FlxGame(1024, 768, Tutorial));
	}
}