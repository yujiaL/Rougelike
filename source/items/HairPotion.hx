package items;

class HairPotion extends Item
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		chargeSpeedChange = -0.2;
		attackScaleChange = 0.4;
		
		loadGraphic(AssetPaths.hair_potion__png, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
	}
	
}