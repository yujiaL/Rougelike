package;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class Weapon extends FlxSprite
{
	private var _bar:Float;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
	}
	
	public function attack(player:Player, position:Float):Void
	{
		
	}
}