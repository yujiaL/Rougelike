package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	
	public static var LOGGER:CapstoneLogger;
	
	public function new()
	{
		super();
		var gameId:Int = 1700;
		var gameKey:String = "86ba54e08dfe7dc76e36075f8c819700";
		var gameName:String = "hairyball";
		var categoryId:Int = 1;

		if (GlobalVariable.LOGGING)
		{
			Main.LOGGER = new CapstoneLogger(gameId, gameName, gameKey, categoryId, 1, true);
			
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
			addChild(new FlxGame(8000, 4500, TitleState));
		}
	}
	
	private function onSessionReady(sessionRecieved:Bool):Void
	{
		addChild(new FlxGame(8000, 4500, TitleState));
	}
}