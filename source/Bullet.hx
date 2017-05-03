package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	private var _damage:Float;
	private var _duration:Float;

	// Create a bullet shoots from (X, Y) to (XTarget, YTarget).
	public function new(X:Float, Y:Float, XTarget:Float, YTarget:Float, damage:Float, speed:Float = 100, duration:Float = 99999) 
	{
		super(X, Y);
		
		makeGraphic(4, 4, FlxColor.YELLOW);
		
		// Add velocity to the direction of target.
		var mA:Float = Math.atan2(YTarget - Y, XTarget - X) * 57.2958;
		velocity.set(speed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), mA);
		
		_damage = damage;
		
		_duration = duration;
	}
	
	override public function update(elapsed:Float):Void
	{
		if (_duration <= 0)
		{
			this.kill();
		}
		else
			_duration -= FlxG.elapsed;
		
		super.update(elapsed);
	}
	
	// Call this function to add speical effects for the attack owner.
	public function updateOwner()
	{
		
	}
	
	// Call this function to add speical effects for the attack target.
	public function updateTarget()
	{
		
	}
}