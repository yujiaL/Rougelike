package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxSpriteUtil;

class GameOverState extends FlxState 
{
	
	private var _level:Int;
	private var _txtMessage:FlxText;
	private var _startMessage:FlxText;

	public function new(Level:Int) 
	{
		_level = Level;
		
		super();
	}
	
	override public function create():Void 
	{
		_txtMessage = new FlxText(0, 0, 0, "Game Over!\nYour reached level : " + _level, 256);
		_txtMessage.screenCenter();
		add(_txtMessage);
		
		_startMessage = new FlxText(0, 0, 0, "Press Space to Play Again! ", 200);
		_startMessage.screenCenter(FlxAxes.X);
		_startMessage.y = FlxG.height * 4 / 5;
		FlxSpriteUtil.flicker(_startMessage, 0, 0.5);
		add(_startMessage);
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justReleased.SPACE)
		{
			FlxG.switchState(new PlayState());
		}
	}
}