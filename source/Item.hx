package;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;


class Item extends FlxSprite
{
	public var hpChange:Int;
	public var coinChange:Int;
	public var weightChange:Int;
	public var hairChange:Int;
	public var speedChange:Int;
	public var chargeSpeedChange:Float;
	public var attackScaleChange:Float;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		hpChange = 0;
		coinChange = 0;
		weightChange = 0;
		hairChange = 0;
		speedChange = 0;
		chargeSpeedChange = 0.0;
		attackScaleChange = 0.0;
	}
	
	public function pickup():Void
	{
		// add animation
	}
	
	override public function kill():Void
	{
		alive = false;
		FlxTween.tween(this, { alpha: 0, y: y - 16 }, .33, { ease: FlxEase.circOut, onComplete: finishKill });
	}
	
	private function finishKill(_):Void
	{
		exists = false;
	}
}