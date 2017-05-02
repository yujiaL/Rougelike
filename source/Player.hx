package source;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Player 
{
	public var speed:Float = 200;
	
	private var _weapon:Weapon;
	private var _health:Int;
	
	public function new(?X:Float=0, ?Y:Float=0, weapon:Weapon) 
	{
		super(X, Y);
		makeGraphic(16, 16, FlxColor.PINK);
	}
	
}