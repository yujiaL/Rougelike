package objects;

import flixel.FlxSprite;

/**
 * A door object that open and closes.
 * Use access _open to open and close the door.
 */
class Door extends FlxSprite
{
	override public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		immovable = true;
		loadGraphic(AssetPaths.cave__png, true, GlobalVariable.UNIT * 2, GlobalVariable.UNIT * 2);
	}
}