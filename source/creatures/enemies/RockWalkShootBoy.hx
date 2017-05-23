package creatures.enemies;

import weapons.Bullet;
import weapons.Rock;

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
		super(X, Y, 12, bullets);
		
		loadGraphic(AssetPaths.MovingRock__PNG, true, Math.round(GlobalVariable.UNIT * 1.5), Math.round(GlobalVariable.UNIT * 1.5));
		
		animation.add("move", [0, 2, 0, 1, 3, 1], 3, false);
		animation.add("attack", [4, 6, 4, 5, 7, 5], 15, false);
		
		_walkSpeed = GlobalVariable.UNIT * FlxG.random.int(4, 6);
		
		_idleTmr = FlxG.random.int(2, 3);
	}
	
	override public function update(elapsed:Float):Void
	{
		// Shoots a bullet from 1 to 4 second.
		if (_idleTmr <= 0)
		{
			animation.play("attack");
			attack();
			_idleTmr = FlxG.random.int(2, 3);
		}
		else
		{
			animation.play("move");
			_idleTmr -= FlxG.elapsed;
		}
		walkAround();
		
		super.update(elapsed);
	}
	
	override public function attack():Void
	{
		_bullets.add(new Rock(getMidpoint().x, getMidpoint().y, playerPos.x, playerPos.y, 3, GlobalVariable.UNIT * 5, 3));
	}
}