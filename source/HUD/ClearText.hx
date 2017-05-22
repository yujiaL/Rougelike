package hud;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class ClearText extends FlxText 
{
	private var _timer:Float;
	
	public function new() 
	{
		super(0, 0, 0, "CLEAR", GlobalVariable.UNIT * 6);
		
		this.screenCenter();
		
		this.text = "";
		
		this.scrollFactor.set(0, 0);
	}
	
	override public function update(elapsed:Float):Void
	{
		_timer += FlxG.elapsed;
		
		if (_timer > 1.8)
			kill();
		else if (_timer > 1.5)
			this.text = "CLEAR";
		else if (_timer > 1.2)
			this.text = "CLEA ";
		else if (_timer > 0.9)
			this.text = "CLE  ";
		else if (_timer > 0.6)
			this.text = "CL   ";
		else if (_timer > 0.3)
			this.text = "C    ";
		
		super.update(elapsed);
	}
	
	override public function kill():Void
	{
		alive = false;
		FlxTween.tween(this, { x : x, y : -GlobalVariable.UNIT * 6 }, 0.6, { onComplete: finishKill });
	}
	
	private function finishKill(_):Void
	{
		exists = false;
	}
}