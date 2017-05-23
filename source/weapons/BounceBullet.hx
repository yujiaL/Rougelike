package weapons;

class BounceBullet extends Bullet
{
	override public function new(X:Float, Y:Float, XTarget:Float, YTarget:Float, damage:Int, speed:Float = GlobalVariable.UNIT * 5, duration:Float = 99999) 
	{
		super(X, Y, XTarget, YTarget, damage, speed, duration);
		
		elasticity = 1;
	}
}