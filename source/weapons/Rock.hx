package weapons;

import flixel.FlxG;

class Rock extends Bullet
{

	override public function new(X:Float, Y:Float, XTarget:Float, YTarget:Float, damage:Int, speed:Float = GlobalVariable.UNIT * 5, duration:Float = 99999) 
	{
		super(X, Y, XTarget, YTarget, damage, speed, duration);
		
		loadGraphic(AssetPaths.Rock__PNG);
	}
	
	override public function update(elapsed:Float):Void
	{
		angle += FlxG.elapsed * 90;
		
		super.update(elapsed);
	}
}