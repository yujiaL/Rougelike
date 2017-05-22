package creatures.enemies;
import creatures.enemies.RockWalkShootAllBoy;

class RockWalkShootAllBoy extends creatures.enemies.RockWalkShootBoy
{
	override public function attack():Void
	{
		_bullets.add(new Rock(getMidpoint().x, getMidpoint().y, getMidpoint().x + 1, getMidpoint().y, 7, GlobalVariable.UNIT * 5, 5));
		_bullets.add(new Rock(getMidpoint().x, getMidpoint().y, getMidpoint().x - 1, getMidpoint().y, 7, GlobalVariable.UNIT * 5, 5));
		_bullets.add(new Rock(getMidpoint().x, getMidpoint().y, getMidpoint().x, getMidpoint().y + 1, 7, GlobalVariable.UNIT * 5, 5));
		_bullets.add(new Rock(getMidpoint().x, getMidpoint().y, getMidpoint().x, getMidpoint().y - 1, 7, GlobalVariable.UNIT * 5, 5));
	}
}