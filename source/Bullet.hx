package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	private var _damage:Float;

	public function new(X:Float, Y:Float, XTarget:Float, YTarget:Float, speed:Float, damage:Float) 
	{
		super(X, Y);
		
		makeGraphic(4, 4, FlxColor.RED);
		
		// Add velocity to the direction of target.
		var mA:Float = 0;
		velocity.set(speed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), mA);
		
		_damage = damage;
	}
}