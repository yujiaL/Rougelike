package weapons;

import creatures.Player;

import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

class Pistol extends Weapon
{

	override public function new(?X:Float=0, ?Y:Float=0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, bullets);
		
		loadGraphic(AssetPaths.Pistol__png, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, true);
		
		animation.add("lr", [0], 1, false);
		animation.add("ud", [1], 1, false);
		
		facing = FlxObject.RIGHT;
		
		barPositions[0] = 85;
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
		
		var damage = position * position / 1250 + 0.3;
		
		_bullets.add(new PistolBullet(getMidpoint().x, getMidpoint().y, XTarget, YTarget, Math.round(damage), scale * 0.5));
		
		if (position > barPositions[0] + weight) 
		{
			switch (player.facing)
			{
				case FlxObject.LEFT:
					player.velocity.set(GlobalVariable.UNIT * 20, 0);
				case FlxObject.RIGHT:
					player.velocity.set(GlobalVariable.UNIT * -20, 0);
				case FlxObject.UP:
					player.velocity.set(0, GlobalVariable.UNIT * 20);
				case FlxObject.DOWN:
					player.velocity.set(0, GlobalVariable.UNIT * -20);
			}
			player._specialState._pushed = true;
			player._specialState._pushedTimer = 0.6;
		}
	}
}

private class PistolBullet extends Bullet
{
	public function new(X:Float, Y:Float,  XTarget:Float, YTarget:Float, Damage:Int, Scale:Float)
	{
		super(X, Y, XTarget, YTarget, Damage, GlobalVariable.UNIT * 12, Scale);
		
		loadGraphic(AssetPaths.PistolBullet__png);
	}
}