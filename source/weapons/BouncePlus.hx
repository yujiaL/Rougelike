package weapons;
import weapons.BouncePlus;

class BouncePlus extends BounceBullet
{
	public function new(X:Float, Y:Float,  XTarget:Float, YTarget:Float, Damage:Int, Scale:Float)
	{
		super(X, Y, XTarget, YTarget, Damage, GlobalVariable.UNIT, Scale * 5);
		
		loadGraphic(AssetPaths.FireBullet__png, false, Math.round(GlobalVariable.UNIT / 2), Math.round(GlobalVariable.UNIT / 2));
	}
}