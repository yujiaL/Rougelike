package objects;

class Medium_Rock extends Obstacle 
{
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y, 20);
		
		loadGraphic(AssetPaths.stone__png, true, GlobalVariable.UNIT, GlobalVariable.UNIT);
	}
}