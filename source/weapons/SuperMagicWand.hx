package weapons;

import creatures.Player;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * ...
 * @author 
 */
class SuperMagicWand extends Weapon 
{

	override public function new(?X:Float=0, ?Y:Float=0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, bullets);
		
		makeGraphic(Math.round(GlobalVariable.UNIT * 0.5), Math.round(GlobalVariable.UNIT * 1.5), FlxColor.BLACK);
		
		barPositions[0] = 50;
	}
	
	override public function attack(player:Player, position:Float, weight:Int, scale:Float):Void
	{	
		var randomAngle:Float = Math.random() * 2 * Math.PI;

		var XTarget = Math.cos(randomAngle) * getMidpoint().x + getMidpoint().x;
		var YTarget = Math.sin(randomAngle) * getMidpoint().y + getMidpoint().y;
		
		// Damage calculator.
		var damage = position * position / 1000 + FlxG.random.int(2, 10);
		
		for (i in ( -2)...3)
		{
			for (j in ( -2)...3)
			{
				if (i != 0 || j != 0)
					_bullets.add(new Bounce(getMidpoint().x, getMidpoint().y, getMidpoint().x + i, getMidpoint().y + j, Math.round(damage), scale * 3));
			}
		}
		
		// Effects.
		if (position > barPositions[0] + weight) 
		{
			var mA:Float = FlxG.random.int(0, 360);
			player.velocity.set(GlobalVariable.UNIT * 25, 0);
			player.velocity.rotate(FlxPoint.weak(0, 0), mA);
			player._specialState._pushed = true;
			player._specialState._pushedTimer = 0.6;
		}
	}
}