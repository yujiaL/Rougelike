package hud;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import items.Item;
import items.HpPotionS;
import items.HpPotionM;
import items.HpPotionL;
import items.HairPotion;
import items.HairShortenPotion;
import items.Broccoli;
import items.Doughnut;

class ItemText extends FlxText
{

	public function new(X:Float=0, Y:Float=0, I:Item, Size:Int=28) 
	{
		var xx = X;
		var yy = Y - GlobalVariable.UNIT / 2;
		if (Std.is(I, HpPotionS)) {
			super(xx, yy, 0, "Hp+", Size);
		} else if (Std.is(I, HpPotionM)) {
			super(xx, yy, 0, "Hp++", Size);
		} else if (Std.is(I, HpPotionL)) {
			super(xx, yy, 0, "Hp+++", Size);
		} else if (Std.is(I, HairPotion)) {
			super(xx, yy, 0, "Hair Length+", Size);
		} else if (Std.is(I, HairShortenPotion)) {
			super(xx, yy, 0, "Hair Length-", Size);
		} else if (Std.is(I, Broccoli)) {
			super(xx, yy, 0, "Weight-", Size);
		} else {
			super(xx, yy, 0, "Weight+", Size);
		}
		
		setFormat(AssetPaths.VCR__ttf, Math.round(GlobalVariable.FONT_SIZE / 3), FlxColor.WHITE);
		
		kill();
	}
	
	override public function kill():Void
	{
		alive = false;
		FlxTween.tween(this, { x : x, y: y - GlobalVariable.UNIT / 6}, 0.8, { onComplete: finishKill });
	}
	
	private function finishKill(_):Void
	{
		exists = false;
	}
	
}