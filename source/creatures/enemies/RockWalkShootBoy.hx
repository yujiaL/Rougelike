package creatures.enemies;

import weapons.Bullet;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * An enemy that walks for a while and shoot.
 */
class RockWalkShootBoy extends Enemy
{
	private var _idleTmr:Float;
	
	public function new(X:Float = 0, Y:Float = 0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, 7, bullets);
		
		makeGraphic(Math.round(GlobalVariable.UNIT * 1.5), Math.round(GlobalVariable.UNIT * 1.5), FlxColor.PINK);
		
		_walkSpeed = GlobalVariable.UNIT * FlxG.random.int(4, 6);
		
		_idleTmr = FlxG.random.int(2, 3);
	}
	
	override public function update(elapsed:Float):Void
	{
		// Shoots a bullet from 1 to 4 second.
		if (_idleTmr <= 0)
		{
			attack();
			_idleTmr = FlxG.random.int(2, 3);
		}
		else
		{
			_idleTmr -= FlxG.elapsed;
		}
		walkAround();
		
		super.update(elapsed);
	}
	
	override public function attack():Void
	{
		_bullets.add(new Bullet(getMidpoint().x, getMidpoint().y, playerPos.x, playerPos.y, 3, GlobalVariable.UNIT * 3, 3));
	}
}