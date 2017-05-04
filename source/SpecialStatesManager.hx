package;

import flixel.FlxG;

/*
 *	Class control the special states of a player or enemy.
 * 	Change states by setting variable to true and set the timer.
 */
class SpecialStatesManager
{
	public var _fall:Bool;
	private var _fallTimer:Float;

	public function new() 
	{
		_fall = false;
	}
	
	// Call to update special states of the player.
	// Return false if we should disable the player(keeping updating).
	public function updateStates(player:Player):Bool
	{
		if (_fall)
		{
			// Timer management.
			if (_fallTimer <= 0)
				_fall = false;
			else
				_fallTimer -= FlxG.elapsed;
			
			// Play animation.
			// player.animation.play("fall");
			
			// Return true to indicate the player cannot move for a while.
			return true;
		}
		return false;
	}
}