package hud;

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
	private var _hpIndicator:FlxText;
	private var _chargeBar:FlxBar;
	private var _chargeIndicator:FlxText;

	private var _ticksText:FlxText;
	private var _playerHpText:FlxText;
	
	private var _limit1:FlxSprite;
	private var _limit2:FlxSprite;
	private var _limit3:FlxSprite;
	private var _limit4:FlxSprite;
	
	// For test.
	private var _level:FlxText;
	
	public function new() 
	{
		super();
		
		_hpBar = new FlxBar(0, 0, LEFT_TO_RIGHT, cast(FlxG.width - GlobalVariable.UNIT * 2, Int), cast(GlobalVariable.UNIT / 2, Int));
		_hpBar.screenCenter(FlxAxes.X);
		_hpBar.y = FlxG.height - GlobalVariable.UNIT * 2.5;
		_hpBar.createFilledBar(0xff464646, 0xff00FF00, true, FlxColor.BLACK);
		add(_hpBar);
		
		_hpIndicator = new FlxText(0, 0, 0, "Health", GlobalVariable.FONT_SIZE);
		_hpIndicator.screenCenter(FlxAxes.X);
		_hpIndicator.y = FlxG.height - GlobalVariable.UNIT * 3.5;
		add(_hpIndicator);
		
		_chargeBar = new FlxBar(0, 0, LEFT_TO_RIGHT, cast(FlxG.width - GlobalVariable.UNIT * 2, Int), cast(GlobalVariable.UNIT / 2, Int));
		_chargeBar.screenCenter(FlxAxes.X);
		_chargeBar.y = FlxG.height - GlobalVariable.UNIT * 1;
		_chargeBar.createFilledBar(0xff464646, 0xffFFFF33, true, FlxColor.BLACK);
		add(_chargeBar);
		
		_chargeIndicator = new FlxText(0, 0, 0, "Charge", GlobalVariable.FONT_SIZE);
		_chargeIndicator.screenCenter(FlxAxes.X);
		_chargeIndicator.y = FlxG.height - GlobalVariable.UNIT * 2;
		add(_chargeIndicator);
		
		_limit1 = new FlxSprite(0, 0);
		_limit1.makeGraphic(cast(GlobalVariable.UNIT / 8, Int), cast(GlobalVariable.UNIT / 2, Int), FlxColor.ORANGE);
		_limit1.visible = false;
		add(_limit1);
		
		_limit2 = new FlxSprite(0, 0);
		_limit2.makeGraphic(cast(GlobalVariable.UNIT / 8, Int), cast(GlobalVariable.UNIT / 2, Int), FlxColor.RED);
		_limit2.visible = false;
		add(_limit2);
		
		_limit3 = new FlxSprite(0, 0);
		_limit3.makeGraphic(cast(GlobalVariable.UNIT / 8, Int), cast(GlobalVariable.UNIT / 2, Int), FlxColor.PINK);
		_limit3.visible = false;
		add(_limit3);
		
		_limit4 = new FlxSprite(0, 0);
		_limit4.makeGraphic(cast(GlobalVariable.UNIT / 8, Int), cast(GlobalVariable.UNIT / 2, Int), FlxColor.CYAN);
		_limit4.visible = false;
		add(_limit4);
		
		_level = new FlxText(GlobalVariable.UNIT, GlobalVariable.UNIT * 0.5, 0, "Level: ", GlobalVariable.FONT_SIZE);
		add(_level);
		
		if (GlobalVariable.DEBUG)
		{
			_ticksText = new FlxText(GlobalVariable.UNIT, GlobalVariable.UNIT * 2, 0, "Time pressed: ", GlobalVariable.FONT_SIZE);
			add(_ticksText);
			
			_playerHpText = new FlxText(GlobalVariable.UNIT, GlobalVariable.UNIT * 3, 0, "HP: ", GlobalVariable.FONT_SIZE);
			add(_playerHpText);
		}
		
		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set(0, 0);
		});
	}
	
	public function updateHUD(TimePressed:Int = 0, PlayerHP:Int = 0, Level:Int = 0, BarValue:Float = 0, Limits:Array<Int>, Weight:Int):Void
    {
		if (GlobalVariable.DEBUG)
		{
			_ticksText.text = "Time pressed: " + TimePressed;
			_playerHpText.text = "HP: " + PlayerHP;
		}
		
        _level.text = "Level: " + Level;
		_chargeBar.value = BarValue;
		_hpBar.value = PlayerHP;
		
		if (Limits[0] > 0)
		{
			_limit1.setPosition((Limits[0] + Weight) / 100.0 * _chargeBar.barWidth + _chargeBar.x, _chargeBar.y);
			_limit1.visible = true;
		} else
		{
			_limit1.visible = false;
		}
		
		if (Limits[1] > 0)
		{
			_limit2.setPosition((Limits[1] + Weight) / 100.0 * _chargeBar.barWidth + _chargeBar.x, _chargeBar.y);
			_limit2.visible = true;
		} else
		{
			_limit2.visible = false;
		}
		
		if (Limits[2] > 0)
		{
			_limit3.setPosition((Limits[2] + Weight) / 100.0 * _chargeBar.barWidth + _chargeBar.x, _chargeBar.y);
			_limit3.visible = true;
		} else
		{
			_limit3.visible = false;
		}
		
		if (Limits[3] > 0)
		{
			_limit4.setPosition((Limits[3] + Weight) / 100.0 * _chargeBar.barWidth + _chargeBar.x, _chargeBar.y);
			_limit4.visible = true;
		} else
		{
			_limit4.visible = false;
		}
    }
}