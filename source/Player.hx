package;

import flixel.FlxSprite;
import flixel.addons.weapon.FlxWeapon;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import haxe.CallStack.StackItem;
import flixel.group.FlxGroup.FlxTypedGroup;

class Player extends Creature
{
	// player stats
	public var speed:Float = 150;	
	private var _weapon:Weapon;
	private var _coins:Int;
	private var _weight:Int;
	private var _hairLength:Int;
	private var _chargeSpeed:Int;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(16, 16, FlxColor.PINK);
		_weapon = new Weapon();
		_chargeSpeed = 1;
		drag.x = drag.y = 1600;
	}
	
	override public function update(elapsed:Float):Void
	{
		
		movement();
		super.update(elapsed);
	}
	
	private function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		_up = FlxG.keys.anyPressed([UP, W]);
		_down = FlxG.keys.anyPressed([DOWN, S]);
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);
		
		if (_up || _down || _left || _right)
		{
			if (_up && _down)
				_up = _down = false;
			if (_left && _right)
				_left = _right = false;
			
			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;
				facing = FlxObject.UP;
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
				facing = FlxObject.DOWN;
			}
			else if (_left)
			{
				mA = 180;
				facing = FlxObject.LEFT;
			}
			else if (_right)
			{
				mA = 0;
				facing = FlxObject.RIGHT;
			}
			
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), mA);
			
		}
	}
	
	public function pickUpItem(item:Item):Void
	{
		
		item.pickup();
	}
	
	public function pickUpWeapon(weapon:Weapon):Void
	{		
		//drop off previous weapon
		
		
		//pick up new weapon
		_weapon = weapon;
	}
	
	public function attack(ticks:Int)
	{
		_weapon.attack(this, ticks * _chargeSpeed);
	}
}