package weapons;

import creatures.Player;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class Weapon extends FlxSprite
{
	private static inline var _CHARGE_MAX:Float = 100;
	
	// _bar needs to be updated every frame.
	public var barPositions:Array<Int>;
	private var _bullets:FlxTypedGroup<Bullet>;
	
	public function new(?X:Float=0, ?Y:Float=0, bullets:FlxTypedGroup<Bullet>) 
	{
		super(X, Y);
		
		barPositions = new Array<Int>();
		barPositions.push(-1);
		barPositions.push(-1);
		barPositions.push(-1);
		barPositions.push(-1);
		
		_bullets = bullets;
	}

	public function hold(X:Float, Y:Float, f:Int):Void
	{
		setPosition(X, Y);
		facing = f;
	}
	
	public function attack(player:Player, position:Float, weight:Int, scale:Float):Void
	{
		// Logging action.
		if (GlobalVariable.LOGGING)
			if (position > barPositions[0] + weight)
				Main.LOGGER.logLevelAction(LoggingActions.PLAYER_OVERCHARGE);
			else if (position > (barPositions[0] + weight) / 2)
				Main.LOGGER.logLevelAction(LoggingActions.PLAYER_ATTACKSTRONG);
			else if (position > 0)
				Main.LOGGER.logLevelAction(LoggingActions.PLAYER_ATTACKWEAK);
	}
}