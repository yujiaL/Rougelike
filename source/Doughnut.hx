package;

class Doughnut extends Item
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		weightChange = 5;
		speedChannge = -200;
		
		loadGraphic(AssetPaths.donut__png, true, 128, 128);
	}
	
}