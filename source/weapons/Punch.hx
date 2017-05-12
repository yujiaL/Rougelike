package weapons;

import creatures.Creature;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Punch extends Bullet
{
	private var _punchSourceX:Float;
	private var _punchSourceY:Float;
	
	public function new(X:Float, Y:Float, XTarget:Float, YTarget:Float, Damage:Int, SourceX:Float, SourceY:Float, Facing:Int, Scale:Float)
	{
		super(X, Y, XTarget, YTarget, Damage, 0.001, 0.1);
		
		_punchSourceX = SourceX;
		_punchSourceY = SourceY;
		
		switch(Facing)
		{
			case FlxObject.LEFT:
				loadGraphic(AssetPaths.Punch__PNG, false, Math.round(GlobalVariable.UNIT * Scale), Math.round(GlobalVariable.UNIT));
				//angle = 180;
				setPosition(X - Math.round(GlobalVariable.UNIT * (Scale - 1)), Y);
			case FlxObject.RIGHT :
				loadGraphic(AssetPaths.Punch__PNG, false, Math.round(GlobalVariable.UNIT * Scale), Math.round(GlobalVariable.UNIT));
				//angle = 0;
				setPosition(X, Y);
			case FlxObject.UP:
				loadGraphic(AssetPaths.PunchUp__PNG, false, Math.round(GlobalVariable.UNIT), Math.round(GlobalVariable.UNIT * Scale));
				//angle = 270;
				setPosition(X, Y - Math.round(GlobalVariable.UNIT * (Scale - 1)));
			case FlxObject.DOWN:
				loadGraphic(AssetPaths.PunchUp__PNG, false, Math.round(GlobalVariable.UNIT), Math.round(GlobalVariable.UNIT * Scale));
				//angle = 90;
				setPosition(X, Y);
		}
	}
	
	// Call this function to add speical effects for the attack target.
	override public function updateTarget(C:Creature)
	{
		// Add velocity to the direction of target.
		var mA:Float = Math.atan2(C.y - _punchSourceY, C.x - _punchSourceX) * 57.2958;
		C.velocity.set(GlobalVariable.UNIT * 20, 0);
		C.velocity.rotate(FlxPoint.weak(0, 0), mA);
		C._specialState._pushed = true;
		C._specialState._pushedTimer = 1;
	}
}