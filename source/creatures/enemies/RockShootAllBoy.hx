package creatures.enemies;

import weapons.Bullet;
import weapons.Rock;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * An enemy that shoots to the four directions once a while.
 */
class RockShootAllBoy extends Enemy
{
	private var _idleTmr:Float;

	public function new(X:Float = 0, Y:Float = 0, bullets:FlxTypedGroup<Bullet>)
	{
		super(X, Y, 12, bullets);
		
		//makeGraphic(Math.round(GlobalVariable.UNIT * 1.5), Math.round(GlobalVariable.UNIT * 1.5), FlxColor.BLUE);
		loadGraphic(AssetPaths.StableRock__PNG, true, Math.round(GlobalVariable.UNIT * 1.5), Math.round(GlobalVariable.UNIT * 1.5));
		
		animation.add("attack", [1, 0], 1, false);
		
		_idleTmr = FlxG.random.int(2, 3);
	}
	
	override public function update(elapsed:Float):Void
	{	
		// Shoots a bullet from 1 to 4 second.
		if (_idleTmr <= 0)
		{
			attack();
			_idleTmr = FlxG.random.int(2, 4);
		}
		else
			_idleTmr -= FlxG.elapsed;
		
		super.update(elapsed);
	}
	
	override public function attack():Void
	{
		animation.play("attack");
		_bullets.add(new Rock(getMidpoint().x, getMidpoint().y, getMidpoint().x + 1, getMidpoint().y, 7, GlobalVariable.UNIT * 5, 5));
		_bullets.add(new Rock(getMidpoint().x, getMidpoint().y, getMidpoint().x - 1, getMidpoint().y, 7, GlobalVariable.UNIT * 5, 5));
		_bullets.add(new Rock(getMidpoint().x, getMidpoint().y, getMidpoint().x, getMidpoint().y + 1, 7, GlobalVariable.UNIT * 5, 5));
		_bullets.add(new Rock(getMidpoint().x, getMidpoint().y, getMidpoint().x, getMidpoint().y - 1, 7, GlobalVariable.UNIT * 5, 5));
	}
}