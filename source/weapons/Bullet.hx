package weapons;

import creatures.Creature;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Bullet extends FlxSprite
{
	public var _damage:Int;
	
	private var _duration:Float;
	
	public var hit:Bool;

	// Create a bullet shoots from (X, Y) to the direction of (XTarget, YTarget).
	public function new(X:Float, Y:Float, XTarget:Float, YTarget:Float, damage:Int, speed:Float = GlobalVariable.UNIT * 5, duration:Float = 99999) 
	{
		super(X, Y);
		
		makeGraphic(Math.round(GlobalVariable.UNIT * 0.5), Math.round(GlobalVariable.UNIT * 0.5), FlxColor.YELLOW);
		
		// Add velocity to the direction of target.
		var mA:Float = Math.atan2(YTarget - Y, XTarget - X) * 57.2958;
		velocity.set(speed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), mA);
		
		_damage = damage;
		
		_duration = duration;
		
		hit = false;
		
		setPosition(x - width / 2, y - height / 2);
	}
	
	override public function update(elapsed:Float):Void
	{
		if (_duration <= 0)
			this.kill();
		else
			_duration -= FlxG.elapsed;
		
		super.update(elapsed);
	}
	
	// Call this function to add speical effects for the attack target.
	public function updateTarget(C:Creature)
	{
		
	}
}