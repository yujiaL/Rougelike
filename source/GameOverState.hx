package;

import flixel.FlxState;
import flixel.text.FlxText;

/**
 * ...
 * @author ...
 */
class GameOverState extends FlxState 
{
	
	private var _level:Int;
	private var _txtMessage:FlxText;

	public function new(Level:Int) 
	{
		_level = Level;
		
		_txtMessage = new FlxText(0, 0, 0, "Your reached level : " + _level, 128);
		_txtMessage.screenCenter();
		add(_txtMessage);
		
		super();
	}
}