package creatures;

import flixel.FlxG;

/*
 *	Class control the special states of a player or enemy.
 * 	Change states by setting variable to true and set the timer.
 */
class SpecialStatesManager
{
	public var _fall:Bool;
	public var _fallTimer:Float;
	
	public var _dash:Bool;
	public var _dashTimer:Float;

	public function new() 
	{
		_fall = false;
		_dash = false;
	}
	
	// Call to update special states of the creature.
	// Return false if we should disable the creature(keeping updating).
	public function updateStates(C:Creature):Bool
	{
		if (_fall)
		{
			// Timer management.
			if (_fallTimer <= 0)
				_fall = false;
			else
				_fallTimer -= FlxG.elapsed;
			
			// Play animation.
			// C.animation.play("fall");
			
			// Return true to indicate the player cannot move for a while.
			return true;
		}
		
		if (_dash)
		{
			// Timer management.
			if (_dashTimer <= 0)
				_dash = false;
			else
				_dashTimer -= FlxG.elapsed;
			
			// Play animation.
			// C.animation.play("fall");
			
			// Return true to indicate the player cannot move for a while.
			return false;
		}
		
		return false;
	}
}