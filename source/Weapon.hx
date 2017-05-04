package;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class Weapon extends FlxSprite
{
	private var _bar:Float;
	private var _bullets:FlxTypedGroup<Bullet>;
	
	public function new(?X:Float=0, ?Y:Float=0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y);
		
		_bullets = bullets;
	}
	
	public function attack(player:Player, position:Float):Void
	{
		
	}
}