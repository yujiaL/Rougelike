package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	/**
	 * Some static constants for the size of the tilemap tiles.
	 */
	private static inline var TILE_WIDTH:Int = 16;
	private static inline var TILE_HEIGHT:Int = 16;
	
	/**
	 * Tilemap and doors.
	 */
	private var _map:FlxTilemap;
	private var _doors:FlxTypedGroup<Door>;
	
	/**
	 * Player.
	 */
	private var _player:Player;
	
	override public function create():Void
	{
		// Map and door.
		_map = new FlxTilemap();
		_map.loadMapFromCSV(AssetPaths.map__csv, AssetPaths.auto_tiles__png, TILE_WIDTH, TILE_HEIGHT, AUTO);
		add(_map);
		
		_doors = new FlxTypedGroup<Door>();
		_doors.add(new Door(112, 240));
		_doors.add(new Door(128, 240));
		_doors.add(new Door(112, 288));
		_doors.add(new Door(128, 288));
		add(_doors);
		
		// Player.
		_player = new Player(32, 32);
		add(_player);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Collide with tiles.
		FlxG.collide(_player, _map);
		
		// Collide with doors.
		for (door in _doors)
			if (!door._open)
				FlxG.collide(_player, door);
	}
}
