package creatures.enemies;

import weapons.Bullet;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

class RockBoy extends Enemy 
{
	
	private var _idleTmr:Float;

	public function new(X:Float = 0, Y:Float = 0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, 10, bullets);
		
		makeGraphic(Math.round(GlobalVariable.UNIT * 1.5), Math.round(GlobalVariable.UNIT * 1.5), FlxColor.YELLOW);
		
		_idleTmr = 0;
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
		_bullets.add(new Bullet(x, y, playerPos.x, playerPos.y, 5, GlobalVariable.UNIT * 3.5, 2.5));
	}
}