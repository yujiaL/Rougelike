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
		
		makeGraphic(cast(GlobalVariable.UNIT / 2, Int), cast(GlobalVariable.UNIT / 2, Int), FlxColor.RED);
		
		facing = FlxObject.RIGHT;
		
		_bar = 50;
	}
	
	override public function attack(player:Player, position:Float):Void
	{	
		var XOrigin = getMidpoint().x;
		var YOrigin = getMidpoint().y;
		var XTarget = getMidpoint().x;
		var YTarget = getMidpoint().y;
		
		switch (facing)
		{
			case FlxObject.LEFT:
				XOrigin -= cast(GlobalVariable.UNIT / 2, Int);
				XTarget -= 999999;
			case FlxObject.RIGHT:
				XOrigin += cast(GlobalVariable.UNIT / 2, Int);
				XTarget += 999999;
			case FlxObject.UP:
				YOrigin -= cast(GlobalVariable.UNIT / 2, Int);
				YTarget -= 999999;
			case FlxObject.DOWN:
				YOrigin += cast(GlobalVariable.UNIT / 2, Int);
				YTarget += 999999;
		}
		
		if (position < _bar) 
		{
			var bullet = new Bullet(getMidpoint().x, getMidpoint().y, XTarget, YTarget, 1, 1000, 2);
			bullet.makeGraphic(32, 32, FlxColor.BLUE);
			_bullets.add(bullet);
		}
		else
		{
			_bullets.add(new Punch(getMidpoint().x, getMidpoint().y, XTarget, YTarget, 10, x, y));
			_bullets.add(new Punch(XOrigin, YOrigin, XTarget, YTarget, 10, x, y));
			player._specialState._fall = true;
			player._specialState._fallTimer = 2;
		}
	}
}