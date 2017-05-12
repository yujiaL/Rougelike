package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxSpriteUtil;

class TitleState extends FlxState
{
	
	private var _background:TitleBackground;
	private var _message:FlxText;
	private var _tutorialText:FlxText;
	
	private var _tutorialBtn:FlxButton;
	private var _gameBtn:FlxButton;

	override public function create():Void
	{
		_background = new TitleBackground(0, 0);
		add(_background);
		
		/*
		_tutorialText = new FlxText(0, 0, 0, "Press T for tutorial! ", GlobalVariable.UNIT);
		_tutorialText.x = FlxG.width / 2 - _tutorialText.width / 2;
		_tutorialText.y = FlxG.height * 4 / 5;
		FlxSpriteUtil.flicker(_tutorialText, 0, 0.5);
		add(_tutorialText);
		
		_message = new FlxText(0, 0, 0, "Press Space to Start! ", GlobalVariable.UNIT);
		_message.x = FlxG.width / 2 - _message.width / 2;
		_message.y = FlxG.height * 4 / 5 + GlobalVariable.UNIT * 1.5;
		FlxSpriteUtil.flicker(_message, 0, 0.5);
		add(_message);*/
		
		_tutorialBtn = new FlxButton(0, 0, "Tutorial", playTutorial);
		_tutorialBtn.screenCenter();
		_tutorialBtn.y = FlxG.height * 4 / 5;
		add(_tutorialBtn);
		
		_gameBtn = new FlxButton(0, 0, "Start Game", playGame);
		_gameBtn.screenCenter();
		_gameBtn.y = _tutorialBtn.y + GlobalVariable.UNIT * 1.5;
		add(_gameBtn);
		
		super.create();
	}
	
	private function playTutorial():Void
	{
		if (GlobalVariable.LOGGING)
			Main.LOGGER.logActionWithNoLevel(LoggingActions.START_TUTORIAL);
		FlxG.switchState(new Tutorial());
	}
	
	private function playGame():Void
	{
		if (GlobalVariable.LOGGING)
			Main.LOGGER.logActionWithNoLevel(LoggingActions.START_GAME);
		FlxG.switchState(new PlayState());
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justReleased.T)
		{
			playTutorial();
		}
		if (FlxG.keys.justReleased.SPACE)
		{
			playGame();
		}
	}
}