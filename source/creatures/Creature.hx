package creatures;

import flixel.FlxSprite;

class Creature extends FlxSprite
{
	public var _health:Int;
	public var _specialState:SpecialStatesManager;

	public function new(?X:Float=0, ?Y:Float=0, health:Int) 
	{
		super(X, Y);
		_health = health;
		_specialState = new SpecialStatesManager();
	}
}