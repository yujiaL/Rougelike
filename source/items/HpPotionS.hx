package items;

class HpPotionS extends Item
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		hpChange = 20;
		
		loadGraphic(AssetPaths.health_potion_s__png, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
	}
	
}