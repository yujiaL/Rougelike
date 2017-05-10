package items;

class HpPotionM extends Item
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		hpChange = 50;
		
		loadGraphic(AssetPaths.health_potion_m__png, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
	}
	
}