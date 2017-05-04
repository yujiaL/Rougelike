package;
import flash.display.InteractiveObject;
import flash.display.Shader;

class Creature extends FlxSprite
{
	private var _health:Int;
	private var _specialState:SpecialStatesManager;

	public function new(?X:Float=0, ?Y:Float=0, health:Int) 
	{
		super(X, Y);
		_health = health;
		_specialState = new SpecialStatesManager();
	}
	
}