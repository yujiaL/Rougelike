package objects;

class Small_Rock extends Obstacle 
{
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y, 10);
		
		loadGraphic(AssetPaths.stone__png, true, 256, 256);
	}
}