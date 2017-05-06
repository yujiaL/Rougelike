package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class HUD extends FlxTypedGroup<FlxSprite>
{

	private var _ticksText:FlxText;
	private var _playerHpText:FlxText;
	
	// For test.
	private var enemyHp:FlxText;
	
	public function new() 
	{
		super();
		
		_ticksText = new FlxText(GlobalVariable.UNIT, GlobalVariable.UNIT, 0, "Time pressed: ", 128);
		add(_ticksText);
		
		_playerHpText = new FlxText(GlobalVariable.UNIT, GlobalVariable.UNIT * 2, 0, "HP: ", 128);
		add(_playerHpText);
		
		enemyHp = new FlxText(GlobalVariable.UNIT, GlobalVariable.UNIT * 3, 0, "Enemy HP: ", 128);
		add(enemyHp);
		
		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set(0, 0);
		});
	}
	
	public function updateHUD(TimePressed:Int = 0, PlayerHP:Int = 0, EnemyHP:Int = 0):Void
    {
        _ticksText.text = "Time pressed: " + TimePressed;
		_playerHpText.text = "HP: " + PlayerHP;
        enemyHp.text = "Enemy HP: " + EnemyHP;
    }
}