package weapons;

import creatures.Player;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;

class BoxingGlove extends Weapon
{

	override public function new(?X:Float=0, ?Y:Float=0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, bullets);
		
		loadGraphic(AssetPaths.BoxingGlove__PNG, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, true);
		
		animation.add("lr", [0], 1, false);
		animation.add("ud", [1], 1, false);
		
		facing = FlxObject.RIGHT;
		
		barPositions[0] = 75;
	}
	
	override public function update(elapsed:Float):Void
	{
		if (facing == FlxObject.LEFT || facing == FlxObject.RIGHT)
			animation.play("lr");
		if (facing == FlxObject.UP || facing == FlxObject.DOWN)
			animation.play("ud");
		
		super.update(elapsed);
	}
	
	override public function attack(player:Player, position:Float, weight:Int, scale:Float):Void
	{	
		var XTarget = getMidpoint().x;
		var YTarget = getMidpoint().y;
		
		switch (facing)
		{
			case FlxObject.LEFT:
				XTarget--;
			case FlxObject.RIGHT:
				XTarget++;
			case FlxObject.UP:
				YTarget--;
			case FlxObject.DOWN:
				YTarget++;
		}
		
		// Damage calculator.
		var damage = position * position / 900;
		
		_bullets.add(new Punch(x, y, XTarget, YTarget, Math.round(damage), getMidpoint().x, getMidpoint().y, facing, scale));
		
		// Effects.
		if (position > barPositions[0] + weight) 
		{
			player._specialState._fall = true;
			player._specialState._fallTimer = 1.8;
		}
	}
}