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
		loadGraphic(AssetPaths.dango__png, true, Math.round(GlobalVariable.UNIT * 4.5), Math.round(GlobalVariable.UNIT * 4.5));
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		setSize(GlobalVariable.UNIT * 1.5, GlobalVariable.UNIT * 1.5);
		offset.set(GlobalVariable.UNIT * 1.5, GlobalVariable.UNIT * 1.5);
		
		animation.add("lr", [0, 1, 0], 6, false);
		animation.add("up", [2], 1, false);
		animation.add("dn", [3], 1, false);
		animation.add("fuzzy", [4], 1, false);
		
		// initialize player stats
		_weapon = new Weapon(0, 0, null);
		
		_coins = 0;
		
		speed = GlobalVariable.UNIT * 9;
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
			
		if (_weight < -25)
			_weight = -25;
		if (_weight > 25)
			_weight = 25;
			
		if (_attackScale < 1)
			_attackScale = 1;
		if (_attackScale > 5)
			_attackScale = 5;
		
		holdWeapon();
		
		// If no special state.
		if (!_specialState.updateStates(this))
		{
			movement();
			updateFacing();
		}
		else if (_specialState._fall)
			animation.play("fuzzy");
		
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
				animation.play("up");
			case FlxObject.DOWN:
				_weapon.hold(this.x + this.width / 2 - _weapon.width / 2, this.y + this.height * 1.5 - _weapon.height / 2 + _hairLength, facing);
				animation.play("dn");
		}
	}
	
	private function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		_up = FlxG.keys.pressed.W;
		_down = FlxG.keys.pressed.S;
		_left = FlxG.keys.pressed.A;
		_right = FlxG.keys.pressed.D;
		
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
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
			}
			else if (_left)
			{
				mA = 180;
			}
			else if (_right)
			{
				mA = 0;
			}
			
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), mA);
			
			// Main.LOGGER.logLevelAction(LoggingActions.PLAYER_MOVE);
		}
	}
	
	private function updateFacing():Void
	{
		if (FlxG.keys.justPressed.UP)
		{
			facing = FlxObject.UP;
		}
		else if (FlxG.keys.justPressed.DOWN)
		{
			facing = FlxObject.DOWN;
		}
		else if (FlxG.keys.justPressed.LEFT)
		{
			facing = FlxObject.LEFT;
		}
		else if (FlxG.keys.justPressed.RIGHT)
		{
			facing = FlxObject.RIGHT;
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
	
	public function attack(ticks:Int):Void
	{
		var position = ticks * _chargeSpeed;
		if (position > 100)
			position = 100;
		_weapon.attack(this, position, _weight, _attackScale);
	}
	
	// Return if damage is applied or not.
	public function receiveDamage(damage:Int):Bool
	{
		if (FlxSpriteUtil.isFlickering(this))
			return false;
		
		FlxG.camera.shake(0.005, 0.1);
		_health -= damage;
		FlxSpriteUtil.flicker(this, 1, 0.2);
		return true;
	}
}