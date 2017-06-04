package hud;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

class LevelText extends FlxText
{
	private var _timer:Float;
	private var _level:Int;
	
	public function new(Level:Int) 
	{
		super(0, 0, 0, "LEVEL: " + Level, GlobalVariable.UNIT * 6);
		
		_timer = 0;
		_level = Level;
		
		this.screenCenter();
		
		this.text = "";
		
		this.scrollFactor.set(0, 0);
	}
	
	override public function update(elapsed:Float):Void
	{
		_timer += FlxG.elapsed;
		
		if (_timer > 1.4)
			kill();
		else if (_timer > 0.8)
			this.text = "LEVEL: " + _level;
		else if (_timer > 0.2)
			this.text = "LEVEL: ";
		
		super.update(elapsed);
	}
	
	override public function kill():Void
	{
		alive = false;
		FlxTween.tween(this, { x : x, y : -GlobalVariable.UNIT * 6 }, 0.4, { onComplete: finishKill });
	}
	
	private function finishKill(_):Void
	{
		exists = false;
	}
}