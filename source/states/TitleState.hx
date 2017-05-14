package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.addons.ui.FlxButtonPlus;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TitleState extends FlxState
{
	
	private var _background:TitleBackground;
	
	private var _tutorialBtn:FlxButtonPlus;
	private var _gameBtn:FlxButtonPlus;

	override public function create():Void
	{
		_background = new TitleBackground(0, 0);
		add(_background);
		
		_tutorialBtn = new FlxButtonPlus(0, 0, playTutorial, "Play Tutorial", GlobalVariable.UNIT * 12, GlobalVariable.UNIT * 2);
		_tutorialBtn.textNormal.size = Math.round(GlobalVariable.UNIT * 1.3);
		_tutorialBtn.textHighlight.size = Math.round(GlobalVariable.UNIT * 1.3);
		_tutorialBtn.screenCenter();
		_tutorialBtn.y = FlxG.height * 2 / 3;
		add(_tutorialBtn);
		
		_gameBtn = new FlxButtonPlus(0, 0, playGame, "Play Game", GlobalVariable.UNIT * 12, GlobalVariable.UNIT * 2);
		_gameBtn.textNormal.size = Math.round(GlobalVariable.UNIT * 1.3);
		_gameBtn.textHighlight.size = Math.round(GlobalVariable.UNIT * 1.3);
		_gameBtn.screenCenter();
		_gameBtn.y = _tutorialBtn.y + GlobalVariable.UNIT * 2.5;
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