package weapons;

import creatures.Creature;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Bounce extends Bullet
{
	
	public function new(X:Float, Y:Float,  XTarget:Float, YTarget:Float, Damage:Int, Scale:Float)
	{
		super(X, Y, XTarget, YTarget, Damage, GlobalVariable.UNIT * 10, 3 * Scale);
		
		makeGraphic(Math.round(GlobalVariable.UNIT * 0.5), Math.round(GlobalVariable.UNIT * 0.5), FlxColor.RED);
	}
}