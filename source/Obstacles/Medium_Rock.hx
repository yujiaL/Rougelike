package;

class Medium_Rock extends Enemy 
{
	public function new((X:Float = 0, Y:Float = 0) 
	{
		super(X, Y, 500, null);
		
		immovable = true;
	}
}