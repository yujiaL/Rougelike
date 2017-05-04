package;

/**
 * ...
 * @author ...
 */
class RockBoy extends Enemy 
{
	
	private var _idleTmr:Float;

	public function new((X:Float = 0, Y:Float = 0, bullets:FlxTypedGroup<Bullet>)) 
	{
		super(X, Y, bullets);
		
		makeGraphic(16, 16, FlxColor.YELLOW);
		
		_idleTmr = 0;
	}
	
	override public function update(elapsed:Float):Void
	{
		// Shoots a bullet from 1 to 4 second.
		if (_idleTmr <= 0)
		{
			attack();
			_idleTmr = FlxG.random.int(1, 4);
			
		}
		else
			_idleTmr -= FlxG.elapsed;
		
		super.update(elapsed);
	}
	
	override public function attack():Void
	{
		_bullets.add(new Bullet(x, y, playerPos.x, playerPos.y, 1, 50, 1));
	}
}