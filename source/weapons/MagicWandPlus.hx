package weapons;

import creatures.Player;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup.FlxTypedGroup;

class MagicWandPlus extends Weapon 
{

	override public function new(?X:Float=0, ?Y:Float=0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, bullets);
		
		loadGraphic(AssetPaths.MagicWandPlus__png, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, true);
		animation.add("lr", [0], 6, false);
		
		barPositions[0] = 50;
	}
	
	override public function update(elapsed:Float):Void
	{
		if (facing == FlxObject.LEFT || facing == FlxObject.RIGHT)
			animation.play("lr");
		
		super.update(elapsed);
	}
	
	override public function attack(player:Player, position:Float, weight:Int, scale:Float):Void
	{	
		var randomAngle:Float = Math.random() * 2 * Math.PI;

		var XTarget = Math.cos(randomAngle) * getMidpoint().x + getMidpoint().x;
		var YTarget = Math.sin(randomAngle) * getMidpoint().y + getMidpoint().y;
		
		// Damage calculator.
		var damage = position * position / 1000 + FlxG.random.int(0, Math.round(position / 10 + 1));
		
		_bullets.add(new BouncePlus(x, y, XTarget, YTarget, Math.round(damage), scale));
		
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