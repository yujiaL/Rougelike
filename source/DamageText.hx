package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;

class DamageText extends FlxText 
{

	public function new(X:Float=0, Y:Float=0, Damage:Int, Size:Int=64) 
	{
		
		setFormat(null, 128, FlxColor.RED);
		
		kill();
	}
	
	override public function kill():Void
	{
		alive = false;
		FlxTween.tween(this, { x : x, y: y - GlobalVariable.UNIT / 6}, 1, { ease: FlxEase.quadInOut, onComplete: finishKill });
	}
	
	private function finishKill(_):Void
	{
		exists = false;
	}
}