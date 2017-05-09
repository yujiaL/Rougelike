package;

import flash.display.Bitmap;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

class BoxingGlove extends Weapon
{

	override public function new(?X:Float=0, ?Y:Float=0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, bullets);
		
		loadGraphic(AssetPaths.boxing_glove__png, true, 256, 256);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, true);
		
		facing = FlxObject.RIGHT;
		
		barPositions[0] = 75;
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
		
		var damage = position * position / 1000;
		
		_bullets.add(new Punch(x, y, XTarget, YTarget, Math.round(damage), getMidpoint().x, getMidpoint().y, facing, scale));
		if (position > barPositions[0] + weight) 
		{
			player._specialState._fall = true;
			player._specialState._fallTimer = 3;
		}
	}
}