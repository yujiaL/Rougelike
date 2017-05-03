package;

import flixel.FlxSprite;
import flixel.addons.weapon.FlxBullet;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;

class Enemy extends FlxSprite
{

	public var _speed:Float = 50;
	public var playerPos(default, null):FlxPoint;
	
	private var _bullets:FlxTypedGroup<Bullet>;
	
	public function new(X:Float = 0, Y:Float = 0, bullets:FlxTypedGroup<Bullet>)
    {
        super(X, Y);
		
		makeGraphic(16, 16, FlxColor.YELLOW);
		
		playerPos = FlxPoint.get();
		
		_bullets = bullets;
    }
	
	override public function update(elapsed:Float):Void
	{
		attack();
		super.update(elapsed);
	}
	
	public function attack():Void
	{
		_bullets.add(new Bullet(1.0));
	}
}