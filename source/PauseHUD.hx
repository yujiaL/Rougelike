package;

import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

using flixel.util.FlxSpriteUtil;

class PauseHUD extends FlxTypedGroup<FlxSprite>
{

	private var _sprBack:FlxSprite;	// this is the background sprite
	
	private var _pauseText:FlxText;
	
	public function new(MaxSize:Int=0) 
	{
		super(MaxSize);
		
		//_pasueScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		//add(_pasueScreen);
		//_sprBack = new FlxSprite().makeGraphic(4400, 3200, FlxColor.WHITE);
		//_sprBack.drawRect(1, 1, 4400, 4400, FlxColor.BLACK);
		//_sprBack.screenCenter();
		add(_sprBack);
		
		_pauseText = new FlxText(1000, 1000, 0, "Pause", 128);
		add(_pauseText);
		
		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set(0, 0);
		});
		
		active = false;
		visible = false;
	}
	
	public function openOrClosePause():Void
	{
		if (visible) 
			visible = false;
		else 
			visible = true;
	}
}