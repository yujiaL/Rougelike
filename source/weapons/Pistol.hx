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
		
		loadGraphic(AssetPaths.pistol__png, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, true);
		
		facing = FlxObject.RIGHT;
		
		barPositions[0] = 85;
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
					player.velocity.set(GlobalVariable.UNIT * 15, 0);
				case FlxObject.RIGHT:
					player.velocity.set(GlobalVariable.UNIT * -15, 0);
				case FlxObject.UP:
					player.velocity.set(0, GlobalVariable.UNIT * 15);
				case FlxObject.DOWN:
					player.velocity.set(0, GlobalVariable.UNIT * -15);
			}
			player._specialState._pushed = true;
			player._specialState._pushedTimer = 0.8;
		}
	}
}

private class PistolBullet extends Bullet
{
	public function new(X:Float, Y:Float,  XTarget:Float, YTarget:Float, Damage:Int, Scale:Float)
	{
		super(X, Y, XTarget, YTarget, Damage, GlobalVariable.UNIT * 8, Scale);
		
		makeGraphic(Math.round(GlobalVariable.UNIT * 0.5), Math.round(GlobalVariable.UNIT * 0.5), FlxColor.PINK);
	}
}