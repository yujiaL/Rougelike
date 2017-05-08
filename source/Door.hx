package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * A door object that open and closes.
 * Use access _open to open and close the door.
 */
class Door extends FlxSprite
{
	override public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(256, 256, FlxColor.BLUE);
		immovable = true;
	}
}