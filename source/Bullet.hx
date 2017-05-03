package;

import flixel.addons.weapon.FlxBullet;
import flixel.util.FlxColor;

class Bullet extends FlxBullet
{
	private var _damage:Float;

	public function new(X:Float, Y:Float, damage:Float) 
	{
		super(X, Y);
		
		makeGraphic(4, 4, FlxColor.RED);
		
		_damage = damage;
	}
}