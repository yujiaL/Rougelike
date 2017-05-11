package creatures;

import weapons.Weapon;
import items.Item;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;

class Player extends Creature
{
	// player stats
	public var speed:Float;	
	public var _weapon:Weapon;
	public var _weight:Int;
	public var _chargeSpeed:Float;
	
	private var _coins:Int;
	private var _hairLength:Int;
	private var _attackScale:Float;
	
	override public function new(?X:Float=0, ?Y:Float=0, health:Int) 
	{
		super(X, Y, health);
		loadGraphic(AssetPaths.dango__png, true, Math.round(GlobalVariable.UNIT * 4.5), Math.round(GlobalVariable.UNIT * 1.5));
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		setSize(GlobalVariable.UNIT * 1.5, GlobalVariable.UNIT * 1.5);
		offset.set(GlobalVariable.UNIT * 1.5, 0);
		
		animation.add("lr", [1, 2, 3, 2, 1], 6, false);
		
		// initialize player stats
		_weapon = new Weapon(0, 0, null);
		
		_coins = 0;
		
		speed = GlobalVariable.UNIT * 8;
		_weight = 0;
		_hairLength = 0;
		_chargeSpeed = 1.5;
		_attackScale = 3;
		
		drag.x = drag.y = GlobalVariable.UNIT * 50;
	}
	
	override public function update(elapsed:Float):Void
	{
		// Check stats.
		if (_health > 100)
			_health = 100;
			
		if (_chargeSpeed < 0.5)
			_chargeSpeed = 0.5;
		if (_chargeSpeed > 2.5)
			_chargeSpeed = 2.5;
			
		if (speed < GlobalVariable.UNIT * 3)
			speed = GlobalVariable.UNIT * 3;
		if (speed > GlobalVariable.UNIT * 13)
			speed = GlobalVariable.UNIT * 13;
		
		holdWeapon();
		
		// If no special state.
		if (!_specialState.updateStates(this))
			movement();
		
		super.update(elapsed);
	}
	
	private function holdWeapon():Void
	{
		switch (facing)
		{
			case FlxObject.LEFT:
				_weapon.hold(this.x - this.width / 2 - _weapon.width / 2 - _hairLength, this.y + this.height / 2 - _weapon.height / 2, facing);
				animation.play("lr");
			case FlxObject.RIGHT :
				_weapon.hold(this.x + this.width * 1.5 - _weapon.width / 2 + _hairLength, this.y + this.height / 2 - _weapon.height / 2, facing);
				animation.play("lr");
			case FlxObject.UP:
				_weapon.hold(this.x + this.width / 2 - _weapon.width / 2, this.y - this.height / 2 - _weapon.height / 2 - _hairLength, facing);
				animation.play("lr");
			case FlxObject.DOWN:
				_weapon.hold(this.x + this.width / 2 - _weapon.width / 2, this.y + this.height * 1.5 - _weapon.height / 2 + _hairLength, facing);
				animation.play("lr");
		}
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
			
			// Main.LOGGER.logLevelAction(LoggingActions.PLAYER_MOVE);
		}
	}
	
	public function pickUpItem(item:Item):Void
	{
		if (GlobalVariable.LOGGING)
			Main.LOGGER.logLevelAction(LoggingActions.PICK_UP_ITEM);
		
		_health += item.hpChange;
		_coins += item.coinChange;
		_weight += item.weightChange;
		_hairLength += item.hairChange;
		speed += item.speedChange;
		_chargeSpeed += item.chargeSpeedChange;
		_attackScale += item.attackScaleChange;
		
		item.kill();
	}
	
	public function pickUpWeapon(weapon:Weapon):Void
	{
		if (GlobalVariable.LOGGING)
			Main.LOGGER.logLevelAction(LoggingActions.PICK_UP_WEAPON);
		
		//pick up new weapon
		_weapon = weapon;
	}
	
	public function attack(ticks:Int)
	{
		var position = ticks * _chargeSpeed;
		if (position > 100)
			position = 100;
		_weapon.attack(this, position, _weight, _attackScale);
	}
	
	public function receiveDamage(damage:Int)
	{
		if (!FlxSpriteUtil.isFlickering(this))
		{
			FlxG.camera.shake(0.005, 0.1);
			_health -= damage;
			FlxSpriteUtil.flicker(this, 1, 0.2);
		}
	}
}