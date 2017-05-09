package;

class Medium_Rock extends Obstacle 
{
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y, 30);
		
		loadGraphic(AssetPaths.stone__png, true, 256, 256);
	}
}