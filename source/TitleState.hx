package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxSpriteUtil;

class TitleState extends FlxState
{
	
	private var _background:TitleBackground;
	private var _message:FlxText;
	private var _tutorialText:FlxText;

	override public function create():Void
	{
		_background = new TitleBackground(0, 0);
		add(_background);
		
		_tutorialText = new FlxText(0, 0, 0, "Press T for tutorial! ", 200);
		_tutorialText.x = FlxG.width / 2 - _tutorialText.width / 2;
		_tutorialText.y = FlxG.height * 4 / 5;
		FlxSpriteUtil.flicker(_tutorialText, 0, 0.5);
		add(_tutorialText);
		
		_message = new FlxText(0, 0, 0, "Press Space to Start! ", 200);
		_message.x = FlxG.width / 2 - _message.width / 2;
		_message.y = FlxG.height * 4 / 5 + 300;
		FlxSpriteUtil.flicker(_message, 0, 0.5);
		add(_message);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justReleased.T)
		{
			if (GlobalVariable.LOGGING)
				Main.LOGGER.logActionWithNoLevel(LoggingActions.START_TUTORIAL);
			FlxG.switchState(new Tutorial());
		}
		if (FlxG.keys.justReleased.SPACE)
		{
			if (GlobalVariable.LOGGING)
				Main.LOGGER.logActionWithNoLevel(LoggingActions.START_GAME);
			clickPlay();
		}
	}
	
	private function clickPlay(): Void
	{
		FlxG.switchState(new PlayState());
	}
}