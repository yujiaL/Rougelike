package weapons;

import creatures.Player;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

class MagicWand extends Weapon
{

	override public function new(?X:Float=0, ?Y:Float=0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, bullets);
		
		makeGraphic(Math.round(GlobalVariable.UNIT * 0.5), Math.round(GlobalVariable.UNIT * 1.5), FlxColor.RED);
		
		barPositions[0] = 75;
	}
	
	override public function attack(player:Player, position:Float, weight:Int, scale:Float):Void
	{	
		var randomAngle:Float = Math.random() * 2 * Math.PI;

		var XTarget = Math.cos(randomAngle) * getMidpoint().x + getMidpoint().x;
		var YTarget = Math.sin(randomAngle) * getMidpoint().y + getMidpoint().y;
		
		// Damage calculator.
		var damage = position * position / 1000;
		
		_bullets.add(new Bounce(x, y, XTarget, YTarget, Math.round(damage), scale));
		
		// Effects.
		if (position > barPositions[0] + weight) 
		{
			player._specialState._fall = true;
			player._specialState._fallTimer = 2;
		}
	}
	
}