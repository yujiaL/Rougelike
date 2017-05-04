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
		
		makeGraphic(12, 12, FlxColor.RED);
		
		facing = FlxObject.RIGHT;
		
		_bar = 50;
	}
	
	override public function attack(player:Player, position:Float):Void
	{	
		var XTarget = x;
		var YTarget = y;
		
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
		
		if (position < _bar) 
		{
			var bullet = new Bullet(x, y, XTarget, YTarget, 1, 50, 2);
			bullet.makeGraphic(4, 4, FlxColor.BLUE);
			_bullets.add(bullet);
		}
		else
		{
			var bullet = new Bullet(x, y, XTarget, YTarget, 10, 100, 0.2);
			bullet.setSize(48, 48);
			bullet.makeGraphic(48, 48, FlxColor.BLUE);
			_bullets.add(bullet);
		}
	}
}