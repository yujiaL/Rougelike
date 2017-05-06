package;

import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.FlxG;
import flixel.addons.weapon.FlxWeapon;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	/**
	 * Some static constants for the size of the tilemap tiles.
	 */
	private static inline var TILE_WIDTH:Int = GlobalVariable.UNIT;
	private static inline var TILE_HEIGHT:Int = GlobalVariable.UNIT;
	
	/**
	 * Tilemap and doors.
	 */
	private var _map:FlxTilemap;
	private var _doors:FlxTypedGroup<Door>;
	
	/**
	 * Player.
	 */
	private var _player:Player;
	private var _playerBullets:FlxTypedGroup<Bullet>;
	private var _ticks:Int;
	
	/**
	 * Enemies and their bullets.
	 */
	private var _enemies:FlxTypedGroup<Enemy>;
	private var _enemy_bullets:FlxTypedGroup<Bullet>;
	
	/**
	 * Items and weapons
	 */
	private var _items:FlxTypedGroup<Item>;
	private var _weapons:FlxTypedGroup<Weapon>;
	
	/**
	 * HUD
	 */
	private var _hud:HUD;
	
	override public function create():Void
	{
		// Map and door.
		_map = new FlxTilemap();
		//_map.loadMapFromCSV(AssetPaths.map__csv, AssetPaths.auto_tiles__png, TILE_WIDTH, TILE_HEIGHT, AUTO);
		_map.loadMapFromCSV(AssetPaths.map__csv, AssetPaths.Tilemap__png, TILE_WIDTH, TILE_HEIGHT, AUTO);
		add(_map);
		
		// Player.
		_player = new Player(2560, 2560, GlobalVariable.PLAYERHP);   // set player health to 100 now, may change later
		add(_player);
		
		_playerBullets = new FlxTypedGroup<Bullet>();
		add(_playerBullets);
		FlxG.camera.follow(_player, NO_DEAD_ZONE, 1);
		
		_ticks = 0;
				
	
		//createNewRoom();
		_doors = new FlxTypedGroup<Door>();
		add(_doors);
		

		// Enemies.
		_enemy_bullets = new FlxTypedGroup<Bullet>();
		add(_enemy_bullets);
		_enemies = new FlxTypedGroup<Enemy>();
		_enemies.add(new RockBoy(3600, 1200, 100, _enemy_bullets));
		add(_enemies);
		
		// Add item.
		_items = new FlxTypedGroup<Item>();
		_items.add(new HealthPotion(1200, 3000));
		add(_items);
		
		// Add weapon.
		_weapons = new FlxTypedGroup<Weapon>();
		_weapons.add(new BoxingGlove(2000, 2500, _playerBullets));
		var green = new BoxingGlove(4500, 2800, _playerBullets);
		green.makeGraphic(128, 128, FlxColor.GREEN);
		_weapons.add(green);
		add(_weapons);
		
		
		// HUD.
		_hud = new HUD();
		add(_hud);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Create new room.
		if (FlxG.keys.justPressed.C)
			setNewRoom();
		
		
		// Collide with tiles.
		FlxG.collide(_player, _map);
		FlxG.collide(_enemies, _map);
		
		// Collide with enemies
		FlxG.overlap(_player, _enemies, separateCreatures);
		
		// Collide with doors.
		for (door in _doors)
			if (!door._open)
				FlxG.collide(_player, door);
				
		// Update enemy's vision.
		_enemies.forEachAlive(updateVision);
		
		// Update hud.
		_hud.updateHUD(_ticks, _player._health, _enemies.getFirstAlive()._health);
		
		// Damage.
		FlxG.overlap(_player, _enemy_bullets, playerGetsHit);
		FlxG.overlap(_enemies, _playerBullets, enemyGetsHit);
		
		// If special state.
		if (_player._specialState.updateStates(_player))
			return;
		
		// Attack.
		playerAttack();
		
		// pick up items
		if (FlxG.keys.justReleased.E)
		{
			FlxG.overlap(_player, _items, playerPickItem);
			FlxG.overlap(_player, _weapons, playerPickWeapon);
		}
	}
	
	private function separateCreatures(C1:Creature, C2:Creature):Void
	{
		FlxObject.separate(C1, C2);
		C1.velocity.set();
		C2.velocity.set();
	}
	
	private function playerGetsHit(P:Player, B:Bullet):Void
	{
		P._health -= B._damage;
		B.updateTarget(P);
		B.kill();
	}
	
	private function enemyGetsHit(E:Enemy, B:Bullet):Void
	{
		E._health -= B._damage;
		B.updateTarget(E);
		B.kill();
	}
	
	private function playerPickItem(P:Player, I:Item):Void
	{
		P.pickUpItem(I);
	}
	
	private function playerPickWeapon(P:Player, W:Weapon):Void
	{
		P.pickUpWeapon(W);
	}
	
	private function playerAttack():Void
	{
		if (FlxG.keys.pressed.SPACE) {
			_ticks++;
		}
		if (FlxG.keys.justReleased.SPACE) {
			_player.attack(_ticks);
			_ticks = 0;
		}
	}
	
	private function updateVision(e:Enemy):Void
	{
		e.playerPos.copyFrom(_player.getMidpoint());
	}
	
	private function setNewRoom():Void
	{
		_doors.clear();
		
		// Player.
		_playerBullets.clear();
		_player.setPosition(2560, 2560);
		
		_ticks = 0;
		
		
		// Enemies.
		_enemy_bullets.clear();
		_enemies.clear();
		for (i in 0...FlxG.random.int(1, 5))
		{
			var enemy = new RockBoy(0, 0, 100, _enemy_bullets);
			randomizeOSPosition(enemy);
			_enemies.add(enemy);
		}
		
		
		// Add item.
		_items.clear();
		_items.add(new HealthPotion(1200, 3000));
		
		// Add weapon.
		_weapons.forEach(destroyWeapon);
		_weapons.add(new BoxingGlove(2000, 2500, _playerBullets));
		var green = new BoxingGlove(4500, 2800, _playerBullets);
		green.makeGraphic(128, 128, FlxColor.GREEN);
		_weapons.add(green);
	}
	
	private function randomizeOSPosition(OS:FlxSprite, ?Object2:FlxObject):Void
	{
		// Pick a random place.
		OS.x = FlxG.random.int(257, 23 * 256 - 1);
		OS.y = FlxG.random.int(257, 16 * 256 - 1);
		
		// Check overlap.
		// FlxG.overlap(OS, _doors, randomizeOSPosition);
		FlxG.overlap(OS, _enemies, randomizeOSPosition);
		FlxG.overlap(OS, _player, randomizeOSPosition);
	}
	
	private function destroyWeapon(W:Weapon)
	{
		if (W != _player._weapon)
			W.destroy();
	}
}
