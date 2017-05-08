package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

class BoxingGlove extends Weapon
{

	override public function new(?X:Float=0, ?Y:Float=0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, bullets);
		
		makeGraphic(Math.round(GlobalVariable.UNIT), Math.round(GlobalVariable.UNIT), FlxColor.RED);
		
		facing = FlxObject.RIGHT;
		
		barPositions[0] = 75;
	}
	
	override public function attack(player:Player, position:Float):Void
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
		
		_bullets.add(new Punch(x, y, XTarget, YTarget, Math.round(damage), getMidpoint().x, getMidpoint().y, facing));
		if (position > barPositions[0]) 
		{
			player._specialState._fall = true;
			player._specialState._fallTimer = 3;
		}
	}
}