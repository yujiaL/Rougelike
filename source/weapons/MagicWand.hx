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
		
		loadGraphic(AssetPaths.MagicWand__PNG, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, true);
		animation.add("lr", [0], 1, false);
		
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
		for (i in 1...4)
		{
			var randomAngle:Float = Math.random() * 2 * Math.PI;

			var XTarget = Math.cos(randomAngle) * getMidpoint().x + getMidpoint().x;
			var YTarget = Math.sin(randomAngle) * getMidpoint().y + getMidpoint().y;
			
			// Damage calculator.
			var damage = position * position / 1000 + FlxG.random.int(0, Math.round(position / 10 + 1));
			
			_bullets.add(new Bounce(x, y, XTarget, YTarget, Math.round(damage), scale));
		}
		
		// Effects.
		if (position > barPositions[0] + weight) 
		{
			player._specialState._fall = true;
			player._specialState._fallTimer = 2;
		}
	}
}