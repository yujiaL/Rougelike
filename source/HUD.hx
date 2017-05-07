package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;

class HUD extends FlxTypedGroup<FlxSprite>
{
	private var _hpBar:FlxBar;
	private var _chargeBar:FlxBar;

	private var _ticksText:FlxText;
	private var _playerHpText:FlxText;
	
	private var _limit:FlxSprite;
	
	// For test.
	private var enemyHp:FlxText;
	
	public function new() 
	{
		super();
		
		_hpBar = new FlxBar(0, 0, LEFT_TO_RIGHT, cast(FlxG.width - GlobalVariable.UNIT * 2, Int), cast(GlobalVariable.UNIT / 2, Int));
		_hpBar.screenCenter(FlxAxes.X);
		_hpBar.y = FlxG.height - GlobalVariable.UNIT * 2;
		_hpBar.createFilledBar(0xff464646, FlxColor.WHITE, true, FlxColor.WHITE);
		add(_hpBar);
		
		_chargeBar = new FlxBar(0, 0, LEFT_TO_RIGHT, cast(FlxG.width - GlobalVariable.UNIT * 2, Int), cast(GlobalVariable.UNIT / 2, Int));
		_chargeBar.screenCenter(FlxAxes.X);
		_chargeBar.y = FlxG.height - GlobalVariable.UNIT * 1;
		_chargeBar.createFilledBar(0xff464646, FlxColor.WHITE, true, FlxColor.WHITE);
		add(_chargeBar);
		
		_limit = new FlxSprite(0, 0);
		_limit.makeGraphic(cast(GlobalVariable.UNIT / 8, Int), cast(GlobalVariable.UNIT / 2, Int), FlxColor.ORANGE);
		add(_limit);
		
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
	
	public function updateHUD(TimePressed:Int = 0, PlayerHP:Int = 0, EnemyHP:Int = 0, BarValue:Int = 0, Limit:Int = 0):Void
    {
        _ticksText.text = "Time pressed: " + TimePressed;
		_playerHpText.text = "HP: " + PlayerHP;
        enemyHp.text = "Enemy HP: " + EnemyHP;
		_chargeBar.value = BarValue;
		_hpBar.value = PlayerHP;
		_limit.setPosition(Limit, _chargeBar.y);
    }
}