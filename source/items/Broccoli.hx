package items;

class Broccoli extends Item
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		weightChange = -5;
		speedChange = GlobalVariable.UNIT;
		
		loadGraphic(AssetPaths.chunk_rotten__png, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
	}
}