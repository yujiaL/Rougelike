package states;

import flixel.FlxG;
import flixel.FlxSubState;
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
	
	private var _resumePlay:Bool;

	public function new(Level:Int) 
	{
		_level = Level;
		_timer = 0;
		
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		_parentState.persistentUpdate = false;
		_parentState.persistentDraw = false;
		
		_txtMessage = new FlxText(0, 0, 0, "Your have reached level : " + _level, Math.round(GlobalVariable.FONT_SIZE * 1.3));
		_txtMessage.screenCenter();
		add(_txtMessage);
		
		_gameover = new FlxText(0, 0, 0, "Game Over!", Math.round(GlobalVariable.FONT_SIZE * 1.3));
		_gameover.screenCenter(FlxAxes.X);
		_gameover.y = FlxG.height * 2 / 5;
		add(_gameover);
		
		_startMessage = new FlxText(0, 0, 0, "Press Space to Play Again! ", Math.round(GlobalVariable.FONT_SIZE * 1));
		_startMessage.screenCenter(FlxAxes.X);
		_startMessage.y = FlxG.height * 4 / 5;
		
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
			if (GlobalVariable.REVIVE)
				close();
			else
				FlxG.switchState(new TitleState());
		}
	}
}