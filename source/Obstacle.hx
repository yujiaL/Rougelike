package;

import flixel.util.FlxColor;

class Obstacle extends Enemy 
{
	public function new(X:Float = 0, Y:Float = 0, Health:Int = 0) 
	{
		super(X, Y, Health, null);
		
		//makeGraphic(256, 256, FlxColor.GRAY);
		
		immovable = true;
	}
}