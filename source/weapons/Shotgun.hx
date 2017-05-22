package weapons;

import creatures.Player;
import flixel.math.FlxPoint;

import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

class Shotgun extends Weapon
{

	override public function new(?X:Float=0, ?Y:Float=0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y, bullets);
		
		loadGraphic(AssetPaths.pistol__png, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.UP, false, false);
		setFacingFlip(FlxObject.DOWN, false, true);
		
		animation.add("lr", [0], 1, false);
		animation.add("ud", [1], 1, false);
		
		facing = FlxObject.RIGHT;
		
		barPositions[0] = 50;
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
		var target1 = getMidpoint();
		var target2 = getMidpoint();
		var target3 = getMidpoint();
		
		switch (facing)
		{
			case FlxObject.LEFT:
				target1.x--;
				target2.x -= 2;
				target2.y--;
				target3.x -= 2;
				target3.y++;
			case FlxObject.RIGHT:
				target1.x++;
				target2.x += 2;
				target2.y--;
				target3.x += 2;
				target3.y++;
			case FlxObject.UP:
				target1.y--;
				target2.x--;
				target2.y -= 2;
				target3.x++;
				target3.y -= 2;
			case FlxObject.DOWN:
				target1.y++;
				target2.x--;
				target2.y += 2;
				target3.x++;
				target3.y += 2;
		}
		
		var damage = position * position / 1250 + 0.1;
		
		_bullets.add(new PistolBullet(getMidpoint().x, getMidpoint().y, target1.x, target1.y, Math.round(damage), scale * 0.4));
		_bullets.add(new PistolBullet(getMidpoint().x, getMidpoint().y, target2.x, target2.y, Math.round(damage), scale * 0.4));
		_bullets.add(new PistolBullet(getMidpoint().x, getMidpoint().y, target3.x, target3.y, Math.round(damage), scale * 0.4));
		
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
			player._specialState._fall = true;
			player._specialState._fallTimer = 1.5;
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