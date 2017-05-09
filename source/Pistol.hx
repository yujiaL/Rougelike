package;

import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

class Pistol extends Weapon
{

	override public function new(?X:Float=0, ?Y:Float=0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, bullets);
		
		loadGraphic(AssetPaths.pistol__png, true, 256, 256);
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, true);
		
		facing = FlxObject.RIGHT;
		
		barPositions[0] = 85;
	}
	
	override public function attack(player:Player, position:Float, weight:Int, scale:Float):Void
	{	
		var XTarget = getMidpoint().x;
		var YTarget = getMidpoint().y;
		
		switch (facing)
		{
			case FlxObject.LEFT:
				XTarget--;
			case FlxObject.RIGHT:
				XTarget++;
			case FlxObject.UP:
				YTarget--;
			case FlxObject.DOWN:
				YTarget++;
		}
		
		var damage = position * position / 1250;
		
		_bullets.add(new Bullet(getMidpoint().x, getMidpoint().y, XTarget, YTarget, Math.round(damage), 2500, scale * 0.5));
		
		if (position > barPositions[0] + weight) 
		{
			player._specialState._fall = true;
			player._specialState._fallTimer = 2;
		}
	}
}