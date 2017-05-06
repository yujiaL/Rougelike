package;

import flixel.math.FlxPoint;

class Punch extends Bullet
{
	public function new(X:Float, Y:Float, XTarget:Float, YTarget:Float, Damage:Int)
	{
		super(X, Y, XTarget, YTarget, Damage, 0, 0.00000001);
	}
	
	// Call this function to add speical effects for the attack target.
	override public function updateTarget(C:Creature)
	{
		// Add velocity to the direction of target.
		var mA:Float = Math.atan2(C.y - y, C.x - x) * 57.2958;
		C.velocity.set(100, 0);
		C.velocity.rotate(FlxPoint.weak(0, 0), mA);
	}
}