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
	private var _playerBullets:FlxTypedGroup<Bullet>;
	private var _ticksText:FlxText;
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
	
	
	
	private var hp:FlxText;
	private var enemyHp:FlxText;
	
	override public function create():Void
	{
		// Map and door.
		_map = new FlxTilemap();
		_map.loadMapFromCSV(AssetPaths.map__csv, AssetPaths.auto_tiles__png, TILE_WIDTH, TILE_HEIGHT, AUTO);
		add(_map);
		
		// Player.
		_player = new Player(32, 32, 100);   // set player health to 100 now, may change later
		add(_player);
		
		
	
		//createNewRoom();
		_doors = new FlxTypedGroup<Door>();
		_doors.add(new Door(112, 240));
		_doors.add(new Door(128, 240));
		_doors.add(new Door(112, 288));
		_doors.add(new Door(128, 288));
		add(_doors);
		
		// Player.
		_playerBullets = new FlxTypedGroup<Bullet>();
		add(_playerBullets);
		_player.setPosition(32, 32);
		FlxG.camera.follow(_player, TOPDOWN, 1);
		
		_ticks = -1;
		
		
		// Enemies.
		_enemy_bullets = new FlxTypedGroup<Bullet>();
		add(_enemy_bullets);
		_enemies = new FlxTypedGroup<Enemy>();
		_enemies.add(new RockBoy(120, 120, 100, _enemy_bullets));
		add(_enemies);
		
		// Add item.
		_items = new FlxTypedGroup<Item>();
		_items.add(new HealthPotion(160, 160));
		add(_items);
		
		// Add weapon.
		_weapons = new FlxTypedGroup<Weapon>();
		_weapons.add(new BoxingGlove(60, 160, _playerBullets));
		var green = new BoxingGlove(120, 160, _playerBullets);
		green.makeGraphic(12, 12, FlxColor.GREEN);
		_weapons.add(green);
		add(_weapons);
		
		
		
		
		// HUD.
		_ticksText = new FlxText(16, 2, 0, "Time pressed " + 0, 12);
		_ticksText.scrollFactor.set(0, 0);
		add(_ticksText);
		
		hp = new FlxText(16, 36, 0, "HP: " + _player._health, 12);
		hp.scrollFactor.set(0, 0);
		add(hp);
		enemyHp = new FlxText(200, 36, 0, "Enemy HP: " + _enemies.getFirstAlive()._health, 12);
		enemyHp.scrollFactor.set(0, 0);
		add(enemyHp);
		
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
		
		// Collide with doors.
		for (door in _doors)
			if (!door._open)
				FlxG.collide(_player, door);
				
		// Update enemy's vision.
		_enemies.forEachAlive(updateVision);
		
		// Update health.
		hp.text = "HP: " + _player._health;
		if (countLiving() > 0)
			enemyHp.text = "Enemy HP: " + _enemies.getFirstAlive()._health;
		
		// Damage.
		FlxG.overlap(_player, _enemy_bullets, playerGetsHit);
		FlxG.overlap(_enemies, _playerBullets, enemyGetsHit);
		
		// Show bar.
		if (_ticks != -1)
			_ticksText.text = "Time pressed " + (FlxG.game.ticks - _ticks);
		else
			_ticksText.text = "Time pressed " + 0;
		
		// If special state.
		if (_player._specialState.updateStates(_player))
			return;
		
		// Attack.
		playerAttack();
		
		// pick up items
		if (FlxG.keys.justReleased.E)
		{
			_player._health++;
			FlxG.overlap(_player, _items, playerPickItem);
			FlxG.overlap(_player, _weapons, playerPickWeapon);
		}
	}
	
	private function playerGetsHit(P:Player, B:Bullet):Void
	{
		P._health -= B._damage;
		B.kill();
	}
	
	private function enemyGetsHit(E:Enemy, B:Bullet):Void
	{
		E._health -= B._damage;
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
		if (FlxG.keys.justPressed.SPACE) {
			_ticks = FlxG.game.ticks;
		}
		if (_ticks == -1)
			return;
		if (FlxG.keys.justReleased.SPACE) {
			_player.attack(FlxG.game.ticks - _ticks);
			_ticks = -1;
		}
	}
	
	private function updateVision(e:Enemy):Void
	{
		e.playerPos.copyFrom(_player.getMidpoint());
	}
	
	private function setNewRoom():Void
	{
		_doors.clear();
		_doors.add(new Door(112, 240));
		_doors.add(new Door(128, 240));
		_doors.add(new Door(112, 288));
		_doors.add(new Door(128, 288));
		
		// Player.
		_playerBullets.clear();
		_player.setPosition(32, 32);
		
		_ticks = -1;
		
		
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
		_items.add(new HealthPotion(160, 160));
		
		// Add weapon.
		_weapons.forEach(destroyWeapon);
		_weapons.add(new BoxingGlove(60, 160, _playerBullets));
		var green = new BoxingGlove(120, 160, _playerBullets);
		green.makeGraphic(12, 12, FlxColor.GREEN);
		_weapons.add(green);
	}
	
	private function randomizeOSPosition(OS:FlxSprite, ?Object2:FlxObject):Void
	{
		// Pick a random place.
		OS.x = FlxG.random.int(0, 240);
		OS.y = FlxG.random.int(0, 240);
		
		// Check overlap.
		// FlxG.overlap(OS, _map, randomizeOSPosition);
		FlxG.overlap(OS, _doors, randomizeOSPosition);
		FlxG.overlap(OS, _enemies, randomizeOSPosition);
		FlxG.overlap(OS, _player, randomizeOSPosition);
	}
	
	private function destroyWeapon(W:Weapon)
	{
		if (W != _player._weapon)
			W.destroy();
	}
}
