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
	private var _startMessage:FlxText;
	private var _timer:Float;
	private var _center:FlxPoint;

	public function new(Level:Int, Center:FlxPoint) 
	{
		_level = Level;
		_timer = 0;
		_center = Center;
		
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		//this.bgColor = FlxColor.YELLOW;
		
		_parentState.persistentUpdate = false;
		_parentState.persistentDraw = false;
		
		_txtMessage = new FlxText(0, 0, 0, "Your have reached level : " + _level, Math.round(GlobalVariable.FONT_SIZE * 2));
		_txtMessage.x = _center.x - _txtMessage.width / 2;
		_txtMessage.y = _center.y - _txtMessage.height / 2;
		add(_txtMessage);
		
		_gameover = new FlxText(0, 0, 0, "Game Over", Math.round(GlobalVariable.FONT_SIZE * 2));
		_gameover.x = _center.x - _gameover.width / 2;
		_gameover.y = _center.y - _gameover.height / 2 - GlobalVariable.FONT_SIZE * 3;
		add(_gameover);
		
		_startMessage = new FlxText(0, 0, 0, "Press \"Space\" to Play Again! ", Math.round(GlobalVariable.FONT_SIZE * 1.5));
		_startMessage.x = _center.x - _startMessage.width / 2;
		_startMessage.y = _center.y - _startMessage.height / 2 + GlobalVariable.FONT_SIZE * 5;
		
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		_timer += FlxG.elapsed;
		if (_timer > 1 && !FlxSpriteUtil.isFlickering(_startMessage))
		{
			FlxSpriteUtil.flicker(_startMessage, 0, 1);
			add(_startMessage);
		}
		
		if (_timer > 1 && FlxG.keys.justReleased.SPACE)
		{
			if (GlobalVariable.REVIVE) {
				if (GlobalVariable.LOGGING) {
					Main.LOGGER.logLevelAction(LoggingActions.REVIVE, _level);
					Main.LOGGER.logLevelEnd();
					Main.LOGGER.logLevelStart(_level);
				}
				close();
				
			}
			else {
				if (GlobalVariable.LOGGING) {
					Main.LOGGER.logLevelEnd();
				FlxG.switchState(new TitleState());
			}
		}
	}
}