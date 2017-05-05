package;

class Small_Rock extends Enemy 
{
	public function new((X:Float = 0, Y:Float = 0) 
	{
		super(X, Y, 100, null);
		
		immovable = true;
	}
}