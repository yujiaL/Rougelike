package states;

import flixel.FlxSubState;
import flixel.system.debug.watch.Tracker.TrackerProfile;
import weapons.Bullet;
import weapons.Weapon;
import weapons.Pistol;
import weapons.BoxingGlove;
import weapons.MagicWand;
import weapons.MagicWandPlus;
import weapons.SuperMagicWand;
import weapons.FastPistol;
import weapons.Shotgun;
import creatures.Creature;
import creatures.Player;
import creatures.enemies.Enemy;
import creatures.enemies.RockShootAllBoy;
import creatures.enemies.RockWalkShootBoy;
import creatures.enemies.RockShootAllBoyPlus;
import creatures.enemies.RockShootAllBoyPlusPlus;
import creatures.enemies.RockRandomBoy;
import creatures.enemies.RockBoy;
import creatures.enemies.RockChaseBoy;
import creatures.enemies.RockWalkShootBoy;
import creatures.enemies.RockWalkShootAllBoy;
import objects.Door;
import objects.Obstacle;
import objects.Small_Rock;
import objects.Medium_Rock;
import hud.HUD;
import hud.DamageText;
import hud.ItemText;
import hud.PauseHUD;
import items.Item;
import items.Doughnut;
import items.Broccoli;
import items.HpPotionS;
import items.HpPotionM;
import items.HpPotionL;
import items.HairPotion;
import items.HairShortenPotion;

import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
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
	private var _floatingText:FlxTypedGroup<FlxText>;
	private var _level:Int;
	
	override public function create():Void
	{
		// Map and door.
		_map = new FlxTilemap();
		_map.loadMapFromCSV(AssetPaths.map__csv, AssetPaths.Floor2__png, TILE_WIDTH, TILE_HEIGHT, null, 1, 1, 2);
		add(_map);
		
		// Player.
		_player = new Player(0, 0, GlobalVariable.PLAYERHP);
		_player.screenCenter();
		add(_player);
		_ticks = 0;
		FlxG.camera.follow(_player, NO_DEAD_ZONE, 1);
		
		_playerBullets = new FlxTypedGroup<Bullet>();
		add(_playerBullets);
		
		// Create initial room.
		_doors = new FlxTypedGroup<Door>();
		_doors.add(new Door(15 * GlobalVariable.UNIT, GlobalVariable.UNIT));
		add(_doors);

		// Enemies.
		_enemy_bullets = new FlxTypedGroup<Bullet>();
		add(_enemy_bullets);
		_enemies = new FlxTypedGroup<Enemy>();
		add(_enemies);
		
		// Obstacles.
		_obstacles = new FlxTypedGroup<Obstacle>();
		for (i in 1...5)
		{
			_obstacles.add(new Small_Rock(13 * GlobalVariable.UNIT, GlobalVariable.UNIT * i));
			_obstacles.add(new Small_Rock(18 * GlobalVariable.UNIT, GlobalVariable.UNIT * i));
		}
		for (i in 14...18)
			_obstacles.add(new Small_Rock(i * GlobalVariable.UNIT, GlobalVariable.UNIT * 4));
		add(_obstacles);
		
		// Add item.
		_items = new FlxTypedGroup<Item>();
		add(_items);
		
		// Add weapon.
		_weapons = new FlxTypedGroup<Weapon>();
		_weapons.add(new BoxingGlove(GlobalVariable.UNIT * 14, GlobalVariable.UNIT * 6, _playerBullets));
		_weapons.add(new Pistol(GlobalVariable.UNIT * 17, GlobalVariable.UNIT * 6, _playerBullets));
		if (GlobalVariable.DEBUG)
		{
			_weapons.add(new MagicWand(GlobalVariable.UNIT * 14, GlobalVariable.UNIT * 8, _playerBullets));
			_weapons.add(new MagicWandPlus(GlobalVariable.UNIT * 17, GlobalVariable.UNIT * 8, _playerBullets));
			_weapons.add(new FastPistol(GlobalVariable.UNIT * 14, GlobalVariable.UNIT * 10, _playerBullets));
			_weapons.add(new Shotgun(GlobalVariable.UNIT * 17, GlobalVariable.UNIT * 10, _playerBullets));
		}
		add(_weapons);
		
		// HUD.
		_hud = new HUD();
		add(_hud);
		//_pause = new PauseHUD();
		//add(_pause);
		_floatingText = new FlxTypedGroup<FlxText>();
		add(_floatingText);
		
		if (GlobalVariable.DEBUG)
			_floatingText.add(new hud.ClearText());
		
		_level = 0;
		if (GlobalVariable.LOGGING)
			Main.LOGGER.logLevelStart(_level);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Game over.
		if (_player._health <= 0)
		{
			if (GlobalVariable.LOGGING)
				Main.LOGGER.logLevelEnd();

			_player._health = 100;
			setNewRoom();
			openSubState(new GameOverState(_level, _player.getMidpoint()));
		}
		
		// Debug.
		if (GlobalVariable.DEBUG)
		{
			
			if (FlxG.keys.justPressed.I)
			{
				for (i in 1...6)
				{
					_items.add(new Broccoli(GlobalVariable.UNIT * 2, GlobalVariable.UNIT * 2 * i));
					_items.add(new Doughnut(GlobalVariable.UNIT * 4, GlobalVariable.UNIT * 2 * i));
					_items.add(new HairPotion(GlobalVariable.UNIT * 6, GlobalVariable.UNIT * 2 * i));
					_items.add(new HairShortenPotion(GlobalVariable.UNIT * 8, GlobalVariable.UNIT * 2 * i));
				}
				_weapons.add(new SuperMagicWand(GlobalVariable.UNIT * 10, GlobalVariable.UNIT * 2, _playerBullets));
			}
			if (FlxG.keys.justPressed.L)
			{
				_player._health = -1;
			}
		}
		
		// When the level is finished.
		if (!ExistInBound() && _doors.countLiving() == -1)
		{
			_floatingText.add(new hud.ClearText());
			
			var newDoor = new Door();
			randomizeOSPositionSafe(newDoor);
			_doors.add(newDoor);
			
			addItem();
			
			if (FlxG.random.bool(60))
				addWeapon();
		}

		// Set new room,
		if (FlxG.overlap(_player, _doors))
		{
			if (GlobalVariable.LOGGING)
				Main.LOGGER.logLevelEnd();
			_level++;
			if (GlobalVariable.LOGGING)
				Main.LOGGER.logLevelStart(_level, Type.getClassName(Type.getClass(_player._weapon)));
			setNewRoom();
		}
		
		// Update enemy's vision.
		_enemies.forEachAlive(updateVision);
		
		// Damage.
		FlxG.overlap(_player, _enemies, playerTouchEnemy);
		FlxG.overlap(_player, _enemy_bullets, playerGetsHit);
		FlxG.overlap(_enemies, _playerBullets, enemyGetsHit);
		FlxG.overlap(_obstacles, _enemy_bullets, obstacleGetsHit);
		FlxG.overlap(_obstacles, _playerBullets, obstacleGetsHit);
		
		// Collide with tiles.
		FlxG.collide(_player, _map);
		_playerBullets.forEachAlive(bulletHitsWall);
		//FlxG.collide(_playerBullets, _map);
		FlxG.collide(_enemies, _map);
		FlxG.collide(_obstacles, _player);
		FlxG.collide(_obstacles, _enemies);
		
		// Remove all bullets that hits one or more targets.
		_enemy_bullets.forEachAlive(removeBullet);
		_playerBullets.forEachAlive(removeBullet);
		
		// Update hud.
		_hud.updateHUD(_ticks, _player._health, _level, _ticks * _player._chargeSpeed, _player._weapon.barPositions, _player._weight);	
		
		// Player action.
		playerAction();
	}
	
	private function bulletHitsWall(B:Bullet):Void
	{
		if (Std.is(B, weapons.BounceBullet))
			FlxG.collide(B, _map);
	}
	
	private function removeBullet(B:Bullet):Void
	{
		if (B.hit)
			B.kill();
	}
	
	private function ExistInBound():Bool
	{
		for (E in _enemies)
			if (E.alive && E.x > 0 && E.x < FlxG.width && E.y > 0 && E.y < FlxG.height)
				return true;
		return false;
	}
	
	private function playerTouchEnemy(P:Player, E:Enemy):Void
	{
		if (E.barded)
		{
			if (P.receiveDamage(E.bardDamage))
			{
				if (GlobalVariable.LOGGING)
					Main.LOGGER.logLevelAction(LoggingActions.ENEMY_GETSHIT);
				
				_floatingText.add(new DamageText(P.x, P.y, E.bardDamage));
			}
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
		if (P.receiveDamage(B._damage))
		{
			if (GlobalVariable.LOGGING)
				Main.LOGGER.logLevelAction(LoggingActions.PLAYER_GETSHIT);
		
			_floatingText.add(new DamageText(P.x, P.y, B._damage));
			B.updateTarget(P);
			B.hit = true;
		}
	}
	
	private function enemyGetsHit(E:Enemy, B:Bullet):Void
	{
		if (GlobalVariable.LOGGING)
			Main.LOGGER.logLevelAction(LoggingActions.ENEMY_GETSHIT);
		
		_floatingText.add(new DamageText(E.x, E.y, B._damage));
		E._health -= B._damage;
		B.updateTarget(E);
		B.hit = true;
	}
	
	private function obstacleGetsHit(O:Obstacle, B:Bullet):Void
	{
		_floatingText.add(new DamageText(O.x, O.y, B._damage));
		O._health -= B._damage;
		B.hit = true;
	}
	
	private function playerPickItem(P:Player, I:Item):Void
	{
		P.pickUpItem(I);
		_floatingText.add(new ItemText(P.x, P.y, I));
	}
	
	private function playerPickWeapon(P:Player, W:Weapon):Void
	{
		P.pickUpWeapon(W);
		if (GlobalVariable.LOGGING && _level == 0) {
			if (Std.is(W, Pistol)) {
				Main.LOGGER.logLevelAction(LoggingActions.PICK_UP_PISTOL);
			} else if (Std.is(W, BoxingGlove)) {
				Main.LOGGER.logLevelAction(LoggingActions.PICK_UP_GLOVE);
			}
		}
	}
	
	private function playerAction():Void
	{
		if (!_player._specialState.updateStates(_player))
		{
			// Attack.
			if (FlxG.keys.anyPressed([UP, DOWN, LEFT, RIGHT])) {
				_ticks++;
			}
			if (_ticks != 0 && !FlxG.keys.anyPressed([UP, DOWN, LEFT, RIGHT])) {

				if (GlobalVariable.LOGGING)
					Main.LOGGER.logLevelAction(LoggingActions.PLAYER_ATTACK);
				_player.attack(_ticks);
				_ticks = 0;
			}
			
			//   Check stats.
			//if (FlxG.keys.justPressed.Q)
			//	_pause.openOrClosePause();
			
			// pick up items
			if (FlxG.keys.justReleased.SPACE)
			{
				FlxG.overlap(_player, _items, playerPickItem);
				FlxG.overlap(_player, _weapons, playerPickWeapon);
			}
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
		randomizeOSPositionSafe(_player);
		
		_ticks = 0;
		
		// Add Enemies.
		_enemy_bullets.clear();
		_enemies.clear();
		addEnemy();
		
		// Add obstacles.
		_obstacles.clear();
		addObstacles();
		
		// Remove item.
		_items.clear();
		
		// Remove weapon.
		_weapons.forEach(destroyWeapon);
		
		// Remove door.
		_doors.clear();
	}
	
	private function randomizeOSPositionSafe(OS:FlxSprite, ?Object2:FlxObject):Void
	{
		// Pick a random place.
		OS.x = FlxG.random.int(GlobalVariable.UNIT * 2, 29 * GlobalVariable.UNIT);
		OS.y = FlxG.random.int(GlobalVariable.UNIT * 2, 15 * GlobalVariable.UNIT);
		
		// Check overlap.
		FlxG.overlap(OS, _enemies, randomizeOSPosition);
		FlxG.overlap(OS, _player, randomizeOSPosition);
		FlxG.overlap(OS, _doors, randomizeOSPosition);
	}
	
	private function randomizeOSPosition(OS:FlxSprite, ?Object2:FlxObject):Void
	{
		// Pick a random place.
		OS.x = FlxG.random.int(GlobalVariable.UNIT, 30 * GlobalVariable.UNIT);
		OS.y = FlxG.random.int(GlobalVariable.UNIT, 16 * GlobalVariable.UNIT);
		
		// Check overlap.
		FlxG.overlap(OS, _enemies, randomizeOSPosition);
		FlxG.overlap(OS, _player, randomizeOSPosition);
		FlxG.overlap(OS, _doors, randomizeOSPosition);
	}
	
	private function destroyWeapon(W:Weapon)
	{
		if (W != _player._weapon)
			W.destroy();
	}
	
	private function addObstacles():Void
	{
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
	}
	
	private function addEnemy():Void
	{
		if (_level < 5) {
			for (i in 1...Math.round(Math.min(_level + 1, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockRandomBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockChaseBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
			
			for (i in 1...Math.round(Math.min(_level - 1, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockShootAllBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
		} else if (_level == 5) {
			var enemy1 = new RockChaseBoy(0, 0, _enemy_bullets);
			randomizeOSPosition(enemy1);
			_enemies.add(enemy1);
			
			var enemy2 = new RockRandomBoy(0, 0, _enemy_bullets);
			randomizeOSPosition(enemy2);
			_enemies.add(enemy2);
			
			var enemy3 = new RockShootAllBoyPlus(0, 0, _enemy_bullets);
			randomizeOSPosition(enemy3);
			_enemies.add(enemy3);
			
		} else if (_level <= 9) {
			for (i in 1...Math.round(Math.min(_level - 4, 3)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockRandomBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 4, 3)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockChaseBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
			
			for (i in 1...Math.round(Math.min(_level - 5, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockShootAllBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 5, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
		} else if (_level == 10) {
			for (i in 1...8) {
				var enemy = new RockChaseBoy(0, 0, _enemy_bullets);
				randomizeOSPosition(enemy);
				_enemies.add(enemy);
			}
		} else if (_level <= 14) {
			for (i in 1...Math.round(Math.min(_level - 9, 3)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockShootAllBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 9, 3)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 9, 3)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockShootAllBoyPlus(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 10, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockRandomBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 10, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockChaseBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
		} else if (_level == 15) {
			for (i in 1...5) {
				var enemy = new RockShootAllBoyPlusPlus(0, 0, _enemy_bullets);
				randomizeOSPosition(enemy);
				_enemies.add(enemy);
			}
		} else if (_level <= 19) {
			for (i in 1...Math.round(Math.min(_level - 14, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockRandomBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 15, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockChaseBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 15, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockShootAllBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 15, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 15, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockShootAllBoyPlus(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 15, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockShootAllBoyPlusPlus(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
		} else if (_level == 20) {
			var enemy1 = new RockBoy(0, 0, _enemy_bullets);
			randomizeOSPosition(enemy1);
			_enemies.add(enemy1);
			
			var enemy2 = new RockChaseBoy(0, 0, _enemy_bullets);
			randomizeOSPosition(enemy2);
			_enemies.add(enemy2);
			
			var enemy3 = new RockRandomBoy(0, 0, _enemy_bullets);
			randomizeOSPosition(enemy3);
			_enemies.add(enemy3);
			
			var enemy4 = new RockShootAllBoy(0, 0, _enemy_bullets);
			randomizeOSPosition(enemy4);
			_enemies.add(enemy4);
			
			var enemy5 = new RockShootAllBoyPlus(0, 0, _enemy_bullets);
			randomizeOSPosition(enemy5);
			_enemies.add(enemy5);
			
			var enemy6 = new RockShootAllBoyPlusPlus(0, 0, _enemy_bullets);
			randomizeOSPosition(enemy6);
			_enemies.add(enemy6);
			
			var enemy7 = new RockWalkShootBoy(0, 0, _enemy_bullets);
			randomizeOSPosition(enemy7);
			_enemies.add(enemy7);
			
			var enemy8 = new RockWalkShootAllBoy(0, 0, _enemy_bullets);
			randomizeOSPosition(enemy8);
			_enemies.add(enemy8);
			
		} else {
			for (i in 1...Math.round(Math.min(_level - 20, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockRandomBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 20, 3)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockChaseBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 19, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockShootAllBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 20, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockBoy(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
			
			for (i in 1...Math.round(Math.min(_level - 19, 3)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockShootAllBoyPlus(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
			
			for (i in 1...Math.round(Math.min(_level - 20, 3)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockShootAllBoyPlusPlus(0, 0, _enemy_bullets);
					randomizeOSPosition(enemy);
					_enemies.add(enemy);
				}
				
			for (i in 1...Math.round(Math.min(_level - 20, 2)))
				if (FlxG.random.bool(100 / i))
				{
					var enemy = new RockWalkShootBoy(0, 0, _enemy_bullets);
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
	}
	
	private function addWeapon()
	{
		var prob = FlxG.random.int(0, 100);
		
		var weapon:Weapon;
		if (prob <= 10) {
			weapon = new Shotgun(GlobalVariable.UNIT * 17, GlobalVariable.UNIT * 10, _playerBullets);
		} else if (prob <= 20) {
			weapon = new MagicWandPlus(GlobalVariable.UNIT * 23, GlobalVariable.UNIT * 6, _playerBullets);
		} else if (prob <= 30) {
			weapon = new MagicWand(GlobalVariable.UNIT * 20, GlobalVariable.UNIT * 6, _playerBullets);
		} else if (prob <= 50) {
			weapon = new FastPistol(GlobalVariable.UNIT * 14, GlobalVariable.UNIT * 10, _playerBullets);
		} else if (prob <= 70) {
			weapon = new Pistol(GlobalVariable.UNIT * 17, GlobalVariable.UNIT * 6, _playerBullets);
		} else {
			weapon = new BoxingGlove(GlobalVariable.UNIT * 14, GlobalVariable.UNIT * 6, _playerBullets);
		}
		
		randomizeOSPosition(weapon);
		_weapons.add(weapon);
	}
}
