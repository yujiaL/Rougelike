package;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Punch extends Bullet
{
	public function new(X:Float, Y:Float, XTarget:Float, YTarget:Float, Damage:Int)
	{
		super(X, Y, XTarget, YTarget, Damage, 0.001, 1);
		
		makeGraphic(cast(GlobalVariable.UNIT * 1.5, Int), cast(GlobalVariable.UNIT / 2, Int), FlxColor.BLUE);

		setPosition(x - width / 2, y - height / 2);
	}
	
	// Call this function to add speical effects for the attack target.
	override public function updateTarget(C:Creature)
	{
		// Add velocity to the direction of target.
		var mA:Float = Math.atan2(C.y - y, C.x - x) * 57.2958;
		C.velocity.set(5000, 0);
		C.velocity.rotate(FlxPoint.weak(0, 0), mA);
	}
}