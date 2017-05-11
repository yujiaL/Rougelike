package states;

import objects.Door;
import creatures.Player;
import weapons.Bullet;
import weapons.Pistol;
import weapons.BoxingGlove;
import weapons.MagicWand;
import weapons.MagicWandPlus;
import creatures.enemies.Enemy;
import creatures.enemies.RockShootAllBoy;
import creatures.enemies.RockWalkShootBoy;
import creatures.enemies.RockShootAllBoyPlus;
import creatures.enemies.RockRandomBoy;
import creatures.enemies.RockBoy;
import creatures.enemies.RockChaseBoy;
import objects.Obstacle;
import objects.Small_Rock;
import objects.Medium_Rock;
import weapons.Weapon;
import hud.HUD;
import hud.DamageText;
import creatures.Creature;
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
import flixel.util.FlxAxes;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
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
	private var _enemyMagicBullets:FlxTypedGroup<Bullet>;
	
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
		var door = new Door();
		door.screenCenter(FlxAxes.X);
		door.y = GlobalVariable.UNIT;
		_doors.add(door);
		add(_doors);

		// Enemies.
		_enemy_bullets = new FlxTypedGroup<Bullet>();
		add(_enemy_bullets);
		_enemies = new FlxTypedGroup<Enemy>();
		add(_enemies);
		//_enemyMagicBullets = new FlxTypedGroup<Bullet>();
		//add(_enemyMagicBullets);
		
		// Obstacles.
		_obstacles = new FlxTypedGroup<Obstacle>();
		add(_obstacles);
		
		// Add item.
		_items = new FlxTypedGroup<Item>();
		add(_items);
		
		// Add weapon.
		_weapons = new FlxTypedGroup<Weapon>();
		_weapons.add(new BoxingGlove(GlobalVariable.UNIT * 14, GlobalVariable.UNIT * 6, _playerBullets));
		_weapons.add(new Pistol(GlobalVariable.UNIT * 17, GlobalVariable.UNIT * 6, _playerBullets));
		_weapons.add(new MagicWand(GlobalVariable.UNIT * 20, GlobalVariable.UNIT * 6, _playerBullets));
		_weapons.add(new MagicWandPlus(GlobalVariable.UNIT * 23, GlobalVariable.UNIT * 6, _playerBullets));
		add(_weapons);
		
		// HUD.
		_hud = new HUD();
		add(_hud);
		//_pause = new PauseHUD();
		//add(_pause);
		_damages = new FlxTypedGroup<FlxText>();
		add(_damages);
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
			FlxG.switchState(new GameOverState(_level));
		}
		
		// Debug.
		if (FlxG.keys.justPressed.I)
		{
			for (i in 1...6)
			{
				_items.add(new Broccoli(GlobalVariable.UNIT * 2, GlobalVariable.UNIT * 2 * i));
				_items.add(new Doughnut(GlobalVariable.UNIT * 4, GlobalVariable.UNIT * 2 * i));
				_items.add(new HairPotion(GlobalVariable.UNIT * 6, GlobalVariable.UNIT * 2 * i));
				_items.add(new HairShortenPotion(GlobalVariable.UNIT * 8, GlobalVariable.UNIT * 2 * i));
			}
		}
		
		// When leve is finished.
		if (_enemies.countLiving() == 0 && _doors.countLiving() == -1)
		{
			var newDoor = new Door();
			randomizeOSPosition(newDoor);
			_doors.add(newDoor);
			
			addItem();
		}

		// Set new room,
		if (FlxG.overlap(_player, _doors))
		{
			if (GlobalVariable.LOGGING)
				Main.LOGGER.logLevelEnd();
			_level++;
			if (GlobalVariable.LOGGING)
				Main.LOGGER.logLevelStart(_level);
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
		FlxG.collide(_playerBullets, _map);
		FlxG.collide(_enemies, _map);
		FlxG.collide(_obstacles, _player);
		FlxG.collide(_obstacles, _enemies);
		
		// Remove all bullets that hits one or more targets.
		_enemy_bullets.forEachAlive(removeBullet);
		_playerBullets.forEachAlive(removeBullet);
		
		// Update hud.
		_hud.updateHUD(_ticks, _player._health, _level, _ticks * _player._chargeSpeed, _player._weapon.barPositions, _player._weight);	
		
		// If special state.
		if (_player._specialState.updateStates(_player))
		{
			return;
		}
			
		
		// Attack.
		playerAttack();
		
		//   Check stats.
		//if (FlxG.keys.justPressed.Q)
		//	_pause.openOrClosePause();
		
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
			P.receiveDamage(E.bardDamage);
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
		if (GlobalVariable.LOGGING)
			Main.LOGGER.logLevelAction(LoggingActions.PLAYER_GETSHIT);
		
		_damages.add(new DamageText(P.x, P.y, B._damage));
		P.receiveDamage(B._damage);
		B.updateTarget(P);
		B.hit = true;
	}
	
	private function enemyGetsHit(E:Enemy, B:Bullet):Void
	{
		if (GlobalVariable.LOGGING)
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

			if (GlobalVariable.LOGGING)
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
		
		
		// Remove item.
		_items.clear();
		
		// Remove weapon.
		_weapons.forEach(destroyWeapon);
		
		// Remove door.
		_doors.clear();
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
	
	private function addEnemy()
	{
		for (i in 1...(_level + 1))
		{
			if (FlxG.random.bool(100 / i))
			{
				var enemy = new RockWalkShootBoy(0, 0, _enemy_bullets);
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
