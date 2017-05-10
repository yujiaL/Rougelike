package items;

class HpPotionL extends Item
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		hpChange = 100;
		
		loadGraphic(AssetPaths.health_potion_l__png, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
	}
	
}