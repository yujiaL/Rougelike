package objects;

import creatures.enemies.Enemy;

class Obstacle extends Enemy 
{
	public function new(X:Float = 0, Y:Float = 0, Health:Int = 0) 
	{
		super(X, Y, Health, null);
		
		immovable = true;
	}
}