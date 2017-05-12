package weapons;

import creatures.Creature;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Bounce extends Bullet
{
	
	public function new(X:Float, Y:Float,  XTarget:Float, YTarget:Float, Damage:Int, Scale:Float)
	{
		super(X, Y, XTarget, YTarget, Damage, GlobalVariable.UNIT * 10, Scale);
		
		elasticity = 1;
		
		loadGraphic(AssetPaths.MagicBullet__PNG, false, Math.round(GlobalVariable.UNIT / 2), Math.round(GlobalVariable.UNIT / 2));
	}
	
	override public function update(elapsed:Float):Void
	{
		angle += FlxG.elapsed * 120;
		
		super.update(elapsed);
	}
}