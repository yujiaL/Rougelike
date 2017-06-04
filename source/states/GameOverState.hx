package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxSpriteUtil;

class GameOverState extends FlxSubState 
{
	private var _level:Int;
	private var _gameover:FlxText;
	private var _txtMessage:FlxText;
	private var _textLevel:FlxText;
	private var _startMessage:FlxText;
	private var _timer:Float;
	private var _center:FlxPoint;
	private var _win:Bool;

	public function new(Level:Int, Center:FlxPoint, Win:Bool) 
	{
		_level = Level;
		_timer = 0;
		_center = Center;
		_win = Win;
		
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		_parentState.persistentUpdate = false;
		_parentState.persistentDraw = false;
		
		_gameover = new FlxText(0, 0, 0, "Game Over", Math.round(GlobalVariable.FONT_SIZE * 2));
		if (_win)
			_gameover.text = "Congratulation!";
		_gameover.x = _center.x - _gameover.width / 2;
		_gameover.y = _center.y - _gameover.height / 2 - GlobalVariable.FONT_SIZE * 6;
		
		_txtMessage = new FlxText(0, 0, 0, "You have reached level :", Math.round(GlobalVariable.FONT_SIZE * 2));
		if (_win)
			_txtMessage.text = "You have reached :";
		_txtMessage.x = _center.x - _txtMessage.width / 2;
		_txtMessage.y = _center.y - _txtMessage.height / 2 - GlobalVariable.FONT_SIZE * 3;
		
		_textLevel = new FlxText(0, 0, 0, "" + _level , Math.round(GlobalVariable.FONT_SIZE * 3));
		if (_win)
			_textLevel.text = "All Levels!";
		else if (GlobalVariable.LIMIT)
			_textLevel.text = _level + " / 20";
		_textLevel.x = _center.x - _textLevel.width / 2;
		_textLevel.y = _center.y - _textLevel.height / 2;
		
		_startMessage = new FlxText(0, 0, 0, "Press \"Space\" to Play Again!", Math.round(GlobalVariable.FONT_SIZE * 1.5));
		if (GlobalVariable.REVIVE)
			_startMessage.text = "Press \"Space\" to Revive!";
		_startMessage.x = _center.x - _startMessage.width / 2;
		_startMessage.y = _center.y - _startMessage.height / 2 + GlobalVariable.FONT_SIZE * 5;
		FlxSpriteUtil.flicker(_startMessage, 0, 1);
		
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		_timer += FlxG.elapsed;
		
		if (_timer > 0.5)
			add(_gameover);
		if (_timer > 1)
			add(_txtMessage);
		if (_timer > 1.5)
			add(_textLevel);
		if (_timer > 2)
			add(_startMessage);
		
		if (_timer > 2 && FlxG.keys.justReleased.SPACE)
		{
			if (_win) {
				if (GlobalVariable.LOGGING)
					Main.LOGGER.logLevelEnd();
				FlxG.switchState(new TitleState());
			} else if (GlobalVariable.REVIVE) {
				if (GlobalVariable.LOGGING) {
					Main.LOGGER.logLevelAction(LoggingActions.REVIVE, _level);
					Main.LOGGER.logLevelEnd();
					Main.LOGGER.logLevelStart(_level);
				}
				close();
			}
			else {
				if (GlobalVariable.LOGGING)
					Main.LOGGER.logLevelEnd();
				FlxG.switchState(new TitleState());
			}
		}
	}
}