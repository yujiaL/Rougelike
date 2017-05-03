package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.weapon.FlxBullet;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;

class Enemy extends FlxSprite
{

	private var _idleTmr:Float;
	public var _speed:Float = 50;
	public var playerPos(default, null):FlxPoint;
	
	private var _bullets:FlxTypedGroup<Bullet>;
	
	public function new(X:Float = 0, Y:Float = 0, bullets:FlxTypedGroup<Bullet>)
    {
        super(X, Y);
		
		makeGraphic(16, 16, FlxColor.YELLOW);
		
		playerPos = FlxPoint.get();
		
		_idleTmr = 0;
		
		_bullets = bullets;
    }
	
	override public function update(elapsed:Float):Void
	{
		// Shoots a bullet from 1 to 4 second.
		if (_idleTmr <= 0)
		{
			attack();
			_idleTmr = FlxG.random.int(1, 4);
			
		}
		else
			_idleTmr -= FlxG.elapsed;
		
		super.update(elapsed);
	}
	
	public function attack():Void
	{
		_bullets.add(new Bullet(x, y, playerPos.x, playerPos.y, 1, 50, 1));
	}
}