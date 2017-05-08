package;

import flixel.util.FlxColor;

class HealthPotion extends Item
{

	override public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		hpChange = 10;
		
		makeGraphic(128, 128, FlxColor.YELLOW);
	}
}