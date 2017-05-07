package;

import flixel.text.FlxText;
import flixel.util.FlxColor;

class DamageText extends FlxText 
{
	
	private var _duration:Float;

	public function new(X:Float=0, Y:Float=0, Damage:Int, Size:Int=128) 
	{
		super(X, Y, 0, "" + Damage, Size);
		
		setFormat(null, 128, FlxColor.RED);
	}
}