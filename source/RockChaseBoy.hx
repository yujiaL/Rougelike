package;

import flixel.FlxG;
import flixel.math.FlxVelocity;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

class RockChaseBoy extends Enemy 
{
	private static inline var _dashSpeed:Float = 1000;
	
	private var _walkTmr:Float;
	private var _dashTmr:Float;
	private var _dashTarget:FlxPoint;

	public function new(X:Float = 0, Y:Float = 0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, 15, bullets);
		
		makeGraphic(GlobalVariable.UNIT, GlobalVariable.UNIT, FlxColor.ORANGE);
		
		_walkTmr = FlxG.random.int(2, 4);
		_dashTmr = 0;
	}
	
	override public function update(elapsed:Float):Void
	{
		
		// If special state.
		if (_specialState.updateStates(this))
			return;
		
		// Shoots a bullet from 1 to 4 second.
		if (_specialState._dash)
		{
			_barded = false;
		}
		else
		{
			if (_dashTmr > 0)
			{
				_barded = true;
				attack();
				_dashTmr -= FlxG.elapsed;
			} 
			else if (_walkTmr > 0) 
			{
				_barded = false;
				walkAround();
				_walkTmr -= FlxG.elapsed;
			} 
			else
			{
				_dashTarget = playerPos;
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
		FlxVelocity.moveTowardsPoint(this, _dashTarget, Std.int(_dashSpeed));
	}
}