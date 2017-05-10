package creatures.enemies;

import weapons.Bullet;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;

class Enemy extends Creature
{
	private static inline var _walkSpeed:Float = GlobalVariable.UNIT * 3;

	public var playerPos(default, null):FlxPoint;
	public var barded:Bool;
	public var bardDamage:Int;
	
	private var _bullets:FlxTypedGroup<Bullet>;
	private var _moveDir:Float;
	private var _moveTmr:Float;
	
	
	public function new(X:Float = 0, Y:Float = 0, Health:Int, bullets:FlxTypedGroup<Bullet>)
    {
        super(X, Y, Health);
		
		drag.x = drag.y = GlobalVariable.UNIT * 50;
		
		playerPos = FlxPoint.get();
		
		_bullets = bullets;
		
		barded = false;
		bardDamage = 0;
		
		_moveTmr = 0;
		_moveDir = -1;
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
	
	public function walkAround():Void
	{
		if (_moveTmr <= 0)
		{
			_moveDir = FlxG.random.int(0, 8) * 45;
			_moveTmr = FlxG.random.int(1, 4);
		}
		else
		{
			velocity.set(_walkSpeed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), _moveDir);
			_moveTmr -= FlxG.elapsed;
		}
	}
}