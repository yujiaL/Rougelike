package creatures.enemies;

/**
 * An enemy that shoots around it self one bullet by one bullet.
 */

 
 // TODO
class RockShootShootAllBoyMinus 
{
	private var _idleTmr:Float;

	public function new(X:Float = 0, Y:Float = 0, bullets:FlxTypedGroup<Bullet>)
	{
		super(X, Y, 12, bullets);
		
		makeGraphic(Math.round(GlobalVariable.UNIT * 1.5), Math.round(GlobalVariable.UNIT * 1.5), FlxColor.BLUE);
		
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
		
		_bullets.add(new Bullet(getMidpoint().x, getMidpoint().y, getMidpoint().x + 1, getMidpoint().y, 7, GlobalVariable.UNIT * 5, 5));
		_bullets.add(new Bullet(getMidpoint().x, getMidpoint().y, getMidpoint().x - 1, getMidpoint().y, 7, GlobalVariable.UNIT * 5, 5));
		_bullets.add(new Bullet(getMidpoint().x, getMidpoint().y, getMidpoint().x, getMidpoint().y + 1, 7, GlobalVariable.UNIT * 5, 5));
		_bullets.add(new Bullet(getMidpoint().x, getMidpoint().y, getMidpoint().x, getMidpoint().y - 1, 7, GlobalVariable.UNIT * 5, 5));
	}
}
	
}