package states;

import flixel.FlxSprite;

class TitleBackground extends FlxSprite
{
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.title1__png, false, 800, 600);
	}
}