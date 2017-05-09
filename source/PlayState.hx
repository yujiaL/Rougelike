package;

import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.graphics.tile.FlxDrawBaseItem;
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
	 * Obstacles.
	 */
	private var _obstacles:FlxTypedGroup<Obstacle>;
	
	/**
	 * Items and weapons
	 */
	private var _items:FlxTypedGroup<Item>;
	private var _weapons:FlxTypedGroup<Weapon>;
	
	/**
	 * HUD
	 */
	private var _hud:HUD;
	private var _pause:PauseHUD;
	private var _damages:FlxTypedGroup<FlxText>;
	private var _level:Int;
	
	override public function create():Void
	{
		
		Main.LOGGER.logLevelStart(_level);
		
		// Map and door.
		_map = new FlxTilemap();
		//_map.loadMapFromCSV(AssetPaths.map__csv, AssetPaths.auto_tiles__png, TILE_WIDTH, TILE_HEIGHT, AUTO);
		//_map.loadMapFromCSV(AssetPaths.map__csv, AssetPaths.Tilemap__png, TILE_WIDTH, TILE_HEIGHT, AUTO);
		_map.loadMapFromCSV(AssetPaths.map__csv, AssetPaths.auto_tilesBig__png, TILE_WIDTH, TILE_HEIGHT, AUTO);
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
		var door = new Door();
		door.screenCenter();
		_doors.add(door);
		add(_doors);

		// Enemies.
		_enemy_bullets = new FlxTypedGroup<Bullet>();
		add(_enemy_bullets);
		_enemies = new FlxTypedGroup<Enemy>();
		//_enemies.add(new RockBoy(3600, 1200, _enemy_bullets));
		add(_enemies);
		
		// Obstacles.
		_obstacles = new FlxTypedGroup<Obstacle>();
		add(_obstacles);
		
		// Add item.
		_items = new FlxTypedGroup<Item>();
		//_items.add(new HealthPotion(1200, 3000));
		add(_items);
		
		// Add weapon.
		_weapons = new FlxTypedGroup<Weapon>();
		_weapons.add(new BoxingGlove(2000, 2500, _playerBullets));
		_weapons.add(new Pistol(4500, 2800, _playerBullets));
		add(_weapons);
		
		// HUD.
		_hud = new HUD();
		add(_hud);
		_pause = new PauseHUD();
		add(_pause);
		_damages = new FlxTypedGroup<FlxText>();
		add(_damages);
		_level = 0;
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Create new room.
		//if (FlxG.keys.justPressed.C)
		//	FlxG.switchState(new Tutorial(_level));
			
		if (_player._health <= 0)
		{
			Main.LOGGER.logLevelEnd();
			FlxG.switchState(new GameOverState(_level));
		}
			
		if (_enemies.countLiving() == 0 && _doors.countLiving() == -1)
		{
			var newDoor = new Door();
			randomizeOSPosition(newDoor);
			_doors.add(newDoor);
			
			addItem();
		}
		
		// Collision
		FlxG.overlap(_player, _enemies, playerTouchEnemy);
		
		// Set new room,
		if (FlxG.overlap(_player, _doors))
		{
			Main.LOGGER.logLevelEnd();
			_level++;
			Main.LOGGER.logLevelStart(_level);
			setNewRoom();
		}
			
		
		// Update enemy's vision.
		_enemies.forEachAlive(updateVision);
		
		// Update hud.
		_hud.updateHUD(_ticks, _player._health, _level, _ticks * _player._chargeSpeed, _player._weapon.barPositions, _player._weight);	
		
		// Damage.
		FlxG.overlap(_player, _enemy_bullets, playerGetsHit);
		FlxG.overlap(_enemies, _playerBullets, enemyGetsHit);
		FlxG.overlap(_obstacles, _enemy_bullets, obstacleGetsHit);
		FlxG.overlap(_obstacles, _playerBullets, obstacleGetsHit);
		
		// Collide with tiles.
		FlxG.collide(_player, _map);
		FlxG.collide(_enemies, _map);
		FlxG.collide(_obstacles, _player);
		FlxG.collide(_obstacles, _enemies);
		
		// Remove all bullets that hits one or more targets.
		_enemy_bullets.forEachAlive(removeBullet);
		_playerBullets.forEachAlive(removeBullet);
		
		// If special state.
		if (_player._specialState.updateStates(_player))
			return;
		
		// Attack.
		playerAttack();
		
		//   Check stats.
		if (FlxG.keys.justPressed.Q)
			_pause.openOrClosePause();
		
		// pick up items
		if (FlxG.keys.justReleased.E)
		{
			FlxG.overlap(_player, _items, playerPickItem);
			FlxG.overlap(_player, _weapons, playerPickWeapon);
		}
	}
	
	private function removeBullet(B:Bullet):Void
	{
		if (B.hit)
			B.kill();
	}
	
	private function playerTouchEnemy(P:Player, E:Enemy):Void
	{
		if (E.barded)
		{
			P.receiveDamage(E.bardDamage);
			
		}
		separateCreatures(P, E);
	}
	
	private function separateCreatures(C1:Creature, C2:Creature):Void
	{
		FlxObject.separate(C1, C2);
		C1.velocity.set();
		C2.velocity.set(); 
	}
	
	private function playerGetsHit(P:Player, B:Bullet):Void
	{
		Main.LOGGER.logLevelAction(LoggingActions.PLAYER_GETSHIT);
		
		_damages.add(new DamageText(P.x, P.y, B._damage));
		P.receiveDamage(B._damage);
		B.updateTarget(P);
		B.hit = true;
	}
	
	private function enemyGetsHit(E:Enemy, B:Bullet):Void
	{
		Main.LOGGER.logLevelAction(LoggingActions.ENEMY_GETSHIT);
		
		_damages.add(new DamageText(E.x, E.y, B._damage));
		E._health -= B._damage;
		B.updateTarget(E);
		B.hit = true;
	}
	
	private function obstacleGetsHit(O:Obstacle, B:Bullet):Void
	{
		_damages.add(new DamageText(O.x, O.y, B._damage));
		O._health -= B._damage;
		B.hit = true;
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
			Main.LOGGER.logLevelAction(LoggingActions.PLAYER_ATTACK);
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
		
		
		
		// Player.
		_playerBullets.clear();
		randomizeOSPosition(_player);
		
		_ticks = 0;
		
		
		// Add Enemies.
		_enemy_bullets.clear();
		_enemies.clear();
		addEnemy();
		
		// Add obstacles.
		_obstacles.clear();
		for (i in 0...FlxG.random.int(4, 8))
		{
			var obstacle = new Small_Rock();
			randomizeOSPosition(obstacle);
			_obstacles.add(obstacle);
		}
		for (i in 0...FlxG.random.int(3, 6))
		{
			var obstacle = new Medium_Rock();
			randomizeOSPosition(obstacle);
			_obstacles.add(obstacle);
		}
		
		
		// Add item.
		_items.clear();
		
		// Add weapon.
		_weapons.forEach(destroyWeapon);
		
		// Add door.
		_doors.clear();
	}
	
	private function randomizeOSPosition(OS:FlxSprite, ?Object2:FlxObject):Void
	{
		// Pick a random place.
		OS.x = FlxG.random.int(GlobalVariable.UNIT, 30 * GlobalVariable.UNIT);
		OS.y = FlxG.random.int(GlobalVariable.UNIT, 16 * GlobalVariable.UNIT);
		
		// Check overlap.
		// FlxG.overlap(OS, _doors, randomizeOSPosition);
		FlxG.overlap(OS, _enemies, randomizeOSPosition);
		FlxG.overlap(OS, _player, randomizeOSPosition);
		FlxG.overlap(OS, _doors, randomizeOSPosition);
	}
	
	private function destroyWeapon(W:Weapon)
	{
		if (W != _player._weapon)
			W.destroy();
	}
	
	private function addEnemy()
	{
		for (i in 1...(_level + 1))
		{
			if (FlxG.random.bool(100 / i))
			{
				var enemy = new RockChaseBoy(0, 0, _enemy_bullets);
				randomizeOSPosition(enemy);
				_enemies.add(enemy);
			}
		}
		for (i in 1...(_level - 2))
		{
			if (FlxG.random.bool(100 / i))
			{
				var enemy = new RockBoy(0, 0, _enemy_bullets);
				randomizeOSPosition(enemy);
				_enemies.add(enemy);
			}
		}
	}
	
	private function addItem()
	{
		// items that changes the player weight
		if (FlxG.random.bool(30))
		{
			var doughnut = new Doughnut();
			randomizeOSPosition(doughnut);
			_items.add(doughnut);
		}
		
		if (FlxG.random.bool(30))
		{
			var broccoli = new Broccoli();
			randomizeOSPosition(broccoli);
			_items.add(broccoli);
		}
		
		// items that changes the player hp
		if (FlxG.random.bool(60))
		{
			var hpS = new HpPotionS();
			randomizeOSPosition(hpS);
			_items.add(hpS);
		}
		
		if (FlxG.random.bool(10))
		{
			var hpM = new HpPotionM();
			randomizeOSPosition(hpM);
			_items.add(hpM);
		}
		
		if (FlxG.random.bool(5))
		{
			var hpL = new HpPotionL();
			randomizeOSPosition(hpL);
			_items.add(hpL);
		}
		
		if (FlxG.random.bool(30))
		{
			var hairLonger = new HairPotion();
			randomizeOSPosition(hairLonger);
			_items.add(hairLonger);
		}
		
		if (FlxG.random.bool(30))
		{
			var hairShorter = new HairShortenPotion();
			randomizeOSPosition(hairShorter);
			_items.add(hairShorter);
		}
	}
}
