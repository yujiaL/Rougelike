package weapons;

class BouncePlus extends Bullet
{
	public function new(X:Float, Y:Float,  XTarget:Float, YTarget:Float, Damage:Int, Scale:Float)
	{
		super(X, Y, XTarget, YTarget, Damage, GlobalVariable.UNIT, Scale * 5);
		
		elasticity = 1;
		
		loadGraphic(AssetPaths.FireBullet__png, false, Math.round(GlobalVariable.UNIT / 2), Math.round(GlobalVariable.UNIT / 2));
	}
}