package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.addons.ui.FlxButtonPlus;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxSpriteUtil;


class TitleState extends FlxState
{

	private var _btnPlay:FlxButtonPlus;
	private var _background:TitleBackground;
	private var _message:FlxText;

	override public function create():Void
	{
		_background = new TitleBackground(0, 0);
		add(_background);
		
		_message = new FlxText(2000, 3000, 0, "Press Space to Start! ", 120);
		//FlxTween.tween(_message, { x: 2000, y: 3000 }, 2.0, { ease: FlxEase.expoIn, type: FlxTween.O});
		FlxSpriteUtil.flicker(_message, 0, 0.5);
		add(_message);
		//_btnPlay = new FlxButtonPlus(2000, 3000, clickPlay, "Start!", 512, 256);
		//add(_btnPlay);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justReleased.SPACE)
		{
			clickPlay();
		}
	}
	
	private function clickPlay(): Void
	{
		FlxG.switchState(new PlayState());
	}
	
}