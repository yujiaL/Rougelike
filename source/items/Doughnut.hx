package items;

class Doughnut extends Item
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		weightChange = 5;
		speedChange = GlobalVariable.UNIT * -1;
		
		loadGraphic(AssetPaths.donut__png, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
	}
}