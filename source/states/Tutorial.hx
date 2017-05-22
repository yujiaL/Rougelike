package states;

import flixel.FlxSprite;
import flixel.ui.FlxBar;
import objects.Door;
import creatures.Player;
import weapons.Bullet;
import creatures.enemies.Enemy;
import creatures.enemies.RockRandomBoy;
import objects.Obstacle;
import items.Item;
import weapons.Weapon;
import hud.HUD;
import hud.DamageText;
import creatures.Creature;
import weapons.BoxingGlove;
import objects.Medium_Rock;
import objects.Small_Rock;


import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxBar;
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
	private var _sprites:FlxTypedGroup<FlxSprite>;
	private var _bars:FlxTypedGroup<FlxBar>;
	
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
		_map.loadMapFromCSV(AssetPaths.map__csv, AssetPaths.Floor2__png, TILE_WIDTH, TILE_HEIGHT, null, 1, 1, 2);
		add(_map);
		
		// Player.
		_player = new Player(0, 0, GlobalVariable.PLAYERHP);
		_player.screenCenter();
		_player.y = GlobalVariable.UNIT * 8;
		add(_player);
		FlxG.camera.follow(_player, NO_DEAD_ZONE, 1);
		
		_ticks = 0;
		
		_playerBullets = new FlxTypedGroup<Bullet>();
		add(_playerBullets);
		
		// Doors.
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
		
		// Add sprites.
		_sprites = new FlxTypedGroup<FlxSprite>();
		add(_sprites);
		
		// Add bars.
		_bars = new FlxTypedGroup<FlxBar>();
		add(_bars);
		
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
			_doors.add(new Door(23 * GlobalVariable.UNIT, 6 * GlobalVariable.UNIT));
			_texts.add(new FlxText(21.5 * GlobalVariable.UNIT, 14 * GlobalVariable.UNIT, 8 * GlobalVariable.UNIT, "Next Level", GlobalVariable.FONT_SIZE));
		}
		if (_current_level == 3 && _enemies.countLiving() == 0)
		{
			_doors.add(new Door(23 * GlobalVariable.UNIT, 6 * GlobalVariable.UNIT));
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
		
		// Collide with tiles.
		FlxG.collide(_player, _map);
		FlxG.collide(_enemies, _map);
		FlxG.collide(_obstacles, _player);
		FlxG.collide(_obstacles, _enemies);
		
		// Remove all bullets that hits one or more targets.
		_enemy_bullets.forEachAlive(removeBullet);
		_playerBullets.forEachAlive(removeBullet);
		
		// Update hud.
		_hud.updateHUD(_ticks, _player._health, 0, _ticks * _player._chargeSpeed, _player._weapon.barPositions, _player._weight);
		
		// If special state.
		if (!_player._specialState.updateStates(_player))
		{
			// Attack.
			playerAttack();
			
			// pick up items
			if (FlxG.keys.justReleased.E)
			{
				FlxG.overlap(_player, _items, playerPickItem);
				FlxG.overlap(_player, _weapons, playerPickWeapon);
			}
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
			if (P.receiveDamage(E.bardDamage))
			{
				if (GlobalVariable.LOGGING)
					Main.LOGGER.logLevelAction(LoggingActions.ENEMY_GETSHIT);
				
				_damages.add(new DamageText(P.x, P.y, E.bardDamage));
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
		
			_damages.add(new DamageText(P.x, P.y, B._damage));
			B.updateTarget(P);
			B.hit = true;
		}
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

			if (GlobalVariable.LOGGING)
				Main.LOGGER.logLevelAction(LoggingActions.PLAYER_ATTACK);
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
		_sprites.clear();
		_bars.clear();
		
		_ticks = 0;
		
		if (Level == 1)
		{
			_weapons.add(new BoxingGlove(7 * GlobalVariable.UNIT, 6 * GlobalVariable.UNIT, _playerBullets));
			
			var buttonE = new FlxSprite(7 * GlobalVariable.UNIT, 12 * GlobalVariable.UNIT);
			buttonE.loadGraphic(AssetPaths.ButtonE__PNG);
			_sprites.add(buttonE);
			_texts.add(new FlxText(5.5 * GlobalVariable.UNIT, 14 * GlobalVariable.UNIT, 0, "Pick Up", GlobalVariable.FONT_SIZE));
			
			var arrowKeys = new FlxSprite(14.5 * GlobalVariable.UNIT, 11 * GlobalVariable.UNIT);
			arrowKeys.loadGraphic(AssetPaths.ArrowKeys__PNG);
			_sprites.add(arrowKeys);
			_texts.add(new FlxText(14.5 * GlobalVariable.UNIT, 14 * GlobalVariable.UNIT, 0, "Move", GlobalVariable.FONT_SIZE));
		}
		
		if (Level == 2)
		{
			add(_hud);
			add(_damages);
			
			_doors.add(new Door(16 * GlobalVariable.UNIT, GlobalVariable.UNIT));
			
			for (i in 1...5)
			{
				_obstacles.add(new Small_Rock(14 * GlobalVariable.UNIT, GlobalVariable.UNIT * i));
				_obstacles.add(new Small_Rock(19 * GlobalVariable.UNIT, GlobalVariable.UNIT * i));
			}
			for (i in 15...19)
				_obstacles.add(new Small_Rock(i * GlobalVariable.UNIT, GlobalVariable.UNIT * 4));
			
			var spaceBar = new FlxSprite(14 * GlobalVariable.UNIT, 12 * GlobalVariable.UNIT);
			spaceBar.loadGraphic(AssetPaths.SpaceBar__PNG);
			_sprites.add(spaceBar);
			_texts.add(new FlxText(6.5 * GlobalVariable.UNIT, 14 * GlobalVariable.UNIT, 0, "Hold to charge.    Release to attack.", GlobalVariable.FONT_SIZE));
			_current_level = 2;
		}
		
		if (Level == 3)
		{
			_enemies.add(new RockRandomBoy(8 * GlobalVariable.UNIT, 8 * GlobalVariable.UNIT, _enemy_bullets));
			// _texts.add(new FlxText(9 * GlobalVariable.UNIT, 14 * GlobalVariable.UNIT, 0, "Hit with maximum power!", GlobalVariable.FONT_SIZE));
			
			// Different bars.
			_texts.add(new FlxText(9 * GlobalVariable.UNIT, 14 * GlobalVariable.UNIT, 0, "Weak", GlobalVariable.FONT_SIZE));
			var bar1 = new FlxBar(0, 0, LEFT_TO_RIGHT, cast(FlxG.width - GlobalVariable.UNIT * 2, Int), cast(GlobalVariable.UNIT / 2, Int));
			bar1.screenCenter(FlxAxes.X);
			bar1.y = FlxG.height - GlobalVariable.UNIT * 10;
			bar1.createFilledBar(0xff464646, 0xffFFFF33, true, FlxColor.BLACK);
			bar1.value = 10;
			_bars.add(bar1);
			
			_current_level = 3;
		}
		
		if (Level == 4)
		{
			if (GlobalVariable.LOGGING)
				Main.LOGGER.logLevelEnd();
			FlxG.switchState(new PlayState());
		}
	}
}