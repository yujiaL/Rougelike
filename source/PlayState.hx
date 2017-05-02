package;

import flixel.FlxState;
import source.Player;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _weapon:Weapon;
	
	
	override public function create():Void
	{
		// set up player
		_player = new Player(20, 20);
		add(_player);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
