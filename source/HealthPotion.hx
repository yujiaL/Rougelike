package;

class HealthPotion extends Item
{

	override public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		hpChange = 50;
	}
}