package creatures.enemies;

import weapons.Bullet;
import weapons.Rock;

import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * An enemy that shoots a lot of bullets around itself.
 */
class RockShootAllBoyPlusPlus extends RockShootAllBoy
{
	override public function new(X:Float = 0, Y:Float = 0, bullets:FlxTypedGroup<Bullet>)
	{
		super(X, Y, bullets);
		
		this._health = 20;
	}
	
	override public function attack():Void
	{
		for (i in ( -2)...3)
		{
			for (j in ( -2)...3)
			{
				if (i != 0 || j != 0)
					_bullets.add(new Rock(getMidpoint().x, getMidpoint().y, getMidpoint().x + i, getMidpoint().y + j, 4, GlobalVariable.UNIT * 4, 3));
			}
		}
	}
}