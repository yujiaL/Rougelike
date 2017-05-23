package hud;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class DamageText extends FlxText 
{
	public function new(X:Float=0, Y:Float=0, Damage:Int, Size:Int=28) 
	{
		var x = X + FlxG.random.int(0, Math.round(GlobalVariable.UNIT / 4));
		var y = Y - GlobalVariable.UNIT / 4 + FlxG.random.int(0, Math.round(GlobalVariable.UNIT / 4));
		super(x, y, 0, Damage + "", Size);
		
		setFormat(AssetPaths.VCR__ttf, Math.round(GlobalVariable.FONT_SIZE / 2), FlxColor.RED);
		
		kill();
	}
	
	override public function kill():Void
	{
		alive = false;
		FlxTween.tween(this, { x : x, y: y - GlobalVariable.UNIT / 6}, 0.5, { ease: FlxEase.quadInOut, onComplete: finishKill });
	}
	
	private function finishKill(_):Void
	{
		exists = false;
	}
}