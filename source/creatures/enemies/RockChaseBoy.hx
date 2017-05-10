package creatures.enemies;

import weapons.Bullet;

import flixel.FlxG;
import flixel.math.FlxVelocity;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

class RockChaseBoy extends Enemy 
{
	private static inline var _dashSpeed:Float = GlobalVariable.UNIT * 5;
	
	private var _walkTmr:Float;
	private var _dashTmr:Float;
	private var _dashTarget:FlxPoint;
	private var _dashSource:FlxPoint;

	public function new(X:Float = 0, Y:Float = 0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, 8, bullets);
		
		bardDamage = 5;
		
		makeGraphic(Math.round(GlobalVariable.UNIT * 1.5), Math.round(GlobalVariable.UNIT * 1.5), FlxColor.ORANGE);
		
		_walkTmr = FlxG.random.int(2, 4);
		_dashTmr = 0;
		_dashTarget = new FlxPoint();
		_dashSource = new FlxPoint();
	}
	
	override public function update(elapsed:Float):Void
	{
		// Dash to the position of player once a while.
		if (_specialState.updateStates(this))
		{
			barded = false;
		}
		else
		{
			if (_dashTmr > 0)
			{
				barded = true;
				attack();
				_dashTmr -= FlxG.elapsed;
			}
			else if (_walkTmr > 0) 
			{
				barded = false;
				walkAround();
				_walkTmr -= FlxG.elapsed;
			} 
			else
			{
				_dashTarget.x = playerPos.x;
				_dashTarget.y = playerPos.y;
				_dashSource.x = getMidpoint().x;
				_dashSource.y = getMidpoint().y;
				_dashTmr = FlxG.random.int(1, 3);
				_walkTmr = FlxG.random.int(2, 4);
			}
		}
		
		super.update(elapsed);
	}
	
	override public function attack():Void
	{
		// Play attack animation.

		// Add velocity to the direction of target.
		var mA:Float = Math.atan2(_dashTarget.y - _dashSource.y, _dashTarget.x - _dashSource.x) * 57.2958;
		velocity.set(_dashSpeed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), mA);
	}
}