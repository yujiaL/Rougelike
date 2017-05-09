package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.text.FlxText;

class Tutorial extends FlxState
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
	 * Items and weapons.
	 */
	private var _items:FlxTypedGroup<Item>;
	private var _weapons:FlxTypedGroup<Weapon>;
	
	/**
	 * HUD.
	 */
	private var _damages:FlxTypedGroup<FlxText>;
	private var _texts:FlxTypedGroup<FlxText>;
	private var _hud:HUD;
	
	/**
	 * Levels.
	 */
	private var _current_level:Int;
	
	override public function create():Void
	{
		if (GlobalVariable.LOGGING)
			Main.LOGGER.logLevelStart(-1);
		
		// Map.
		_map = new FlxTilemap();
		_map.loadMapFromCSV(AssetPaths.map__csv, AssetPaths.auto_tilesBig__png, TILE_WIDTH, TILE_HEIGHT, AUTO);
		add(_map);
		
		// Player.
		_player = new Player(0, 0, GlobalVariable.PLAYERHP);
		_player.screenCenter();
		add(_player);
		FlxG.camera.follow(_player, NO_DEAD_ZONE, 1);
		
		_ticks = 0;
		
		_playerBullets = new FlxTypedGroup<Bullet>();
		add(_playerBullets);
		
		//createNewRoom();
		_doors = new FlxTypedGroup<Door>();
		add(_doors);

		// Enemies.
		_enemy_bullets = new FlxTypedGroup<Bullet>();
		add(_enemy_bullets);
		_enemies = new FlxTypedGroup<Enemy>();
		add(_enemies);
		
		// Obstacles.
		_obstacles = new FlxTypedGroup<Obstacle>();
		add(_obstacles);
		
		// Add item.
		_items = new FlxTypedGroup<Item>();
		add(_items);
		
		// Add weapon.
		_weapons = new FlxTypedGroup<Weapon>();
		add(_weapons);
		
		// Add texts.
		_hud = new HUD();
		_damages = new FlxTypedGroup<FlxText>();
		_texts = new FlxTypedGroup<FlxText>();
		add(_texts);
		
		// Load level 1.
		loadLevel(1);
		_current_level = 1;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Levels.
		if (_current_level == 1 && _player._weapon == _weapons.getFirstAlive() && _doors.countLiving() == -1)
		{
			_doors.add(new Door(23 * 256, 6 * 256));
			_texts.add(new FlxText(22 * 256, 10 * 256, 8 * 256, "Proceed to the next level.", 128));
		}
		if (_current_level == 3 && _enemies.countLiving() == 0)
		{
			_doors.add(new Door(23 * 256, 6 * 256));
		}
		
		// Doors.
		FlxG.overlap(_player, _doors, playerTouchDoor);
		
		// Update enemy's vision.
		_enemies.forEachAlive(updateVision);
		
		// Damage.
		FlxG.overlap(_player, _enemies, playerTouchEnemy);
		FlxG.overlap(_player, _enemy_bullets, playerGetsHit);
		FlxG.overlap(_enemies, _playerBullets, enemyGetsHit);
		FlxG.overlap(_obstacles, _enemy_bullets, obstacleGetsHit);
		FlxG.overlap(_obstacles, _playerBullets, obstacleGetsHit);
		
		// Remove all bullets that hits one or more targets.
		_enemy_bullets.forEachAlive(removeBullet);
		_playerBullets.forEachAlive(removeBullet);
		
		// Collide with tiles.
		FlxG.collide(_player, _map);
		FlxG.collide(_enemies, _map);
		FlxG.collide(_obstacles, _player);
		FlxG.collide(_obstacles, _enemies);
		
		// Update hud.
		_hud.updateHUD(_ticks, _player._health, 0, _ticks * _player._chargeSpeed, _player._weapon.barPositions, _player._weight);
		
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
	
	private function playerTouchDoor(P:Player, D:Door):Void
	{
		loadLevel(_current_level + 1);
		D.kill();
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
		P.receiveDamage(B._damage);
		B.updateTarget(P);
		B.hit = true;
	}
	
	private function enemyGetsHit(E:Enemy, B:Bullet):Void
	{
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
	
	private function updateVision(e:Enemy):Void
	{
		e.playerPos.copyFrom(_player.getMidpoint());
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
	
	private function loadLevel(Level:Int):Void
	{
		// Remove all.
		_doors.clear();
		_playerBullets.clear();
		_enemy_bullets.clear();
		_enemies.clear();
		_obstacles.clear();
		_items.clear();
		_texts.clear();
		
		_ticks = 0;
		
		if (Level == 1)
		{
			_weapons.add(new BoxingGlove(7 * 256, 6 * 256, _playerBullets));
			_texts.add(new FlxText(4 * 256, 10 * 256, 8 * 256, "Press E to pick up weapons and items.", 128));
			_texts.add(new FlxText(12 * 256, 10 * 256, 8 * 256, "Use arrow keys to move.", 128));
		}
		
		if (Level == 2)
		{
			add(_hud);
			_doors.add(new Door(16 * 256, 256));
			_obstacles.add(new Small_Rock(14 * 256, 256));
			_obstacles.add(new Small_Rock(15 * 256, 256 * 2));
			_obstacles.add(new Small_Rock(16 * 256, 256 * 3));
			_obstacles.add(new Small_Rock(17 * 256, 256 * 2));
			_obstacles.add(new Small_Rock(18 * 256, 256));
			_texts.add(new FlxText(10 * 256, 10 * 256, 0, "Press SPACE to charge. Release to attack.", 128));
			_current_level = 2;
		}
		
		if (Level == 3)
		{
			_enemies.add(new RockChaseBoy(8 * 256, 8 * 256, _enemy_bullets));
			_texts.add(new FlxText(4 * 256, 10 * 256, 0, "Be careful when you attack...Too much power isn't always a good thing.", 128));
			_current_level = 3;
		}
		
		if (Level == 4)
		{
			if (GlobalVariable.LOGGING)
				Main.LOGGER.logLevelEnd();
			FlxG.switchState(new TitleState());
		}
	}
}