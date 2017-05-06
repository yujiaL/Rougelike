package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.weapon.FlxBullet;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;

class Enemy extends Creature
{

	public var playerPos(default, null):FlxPoint;
	
	private var _bullets:FlxTypedGroup<Bullet>;
	
	public function new(X:Float = 0, Y:Float = 0, Health:Int, bullets:FlxTypedGroup<Bullet>)
    {
        super(X, Y, Health);
		
		playerPos = FlxPoint.get();
		
		_bullets = bullets;
		
		drag.x = drag.y = 15000;
    }
	
	override public function update(elapsed:Float):Void
	{
		if (_health <= 0)
			kill();
		
		super.update(elapsed);
	}
	
	public function attack():Void
	{
		
	}
}