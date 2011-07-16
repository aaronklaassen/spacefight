package  
{
	import flash.geom.Point;
	import flash.net.getClassByAlias;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author Aaron
	 */
	public class Player extends GameEntity
	{
		[Embed(source = '../assets/images/players.png')]
		public static const PLANE:Class;
		
		public static const START_POINTS:Array = new Array(new Point(480, 640), new Point(720, 640), new Point(210, 640));
		private static const MAX_SPEED:Number = 450; // pix/sec
		
		private var KEY_UP:int;
		private var KEY_DOWN:int;
		private var KEY_LEFT:int;
		private var KEY_RIGHT:int;
		private var KEY_FIRE:int;
		
		private var weapons:Vector.<Weapon>;
		
		private var alphaDelta:Number;
		private var spawnTime:Number;
		private var shieldRegenRate:Number; // pts/sec
		
		private var hud:HUD;
		
		private var _playerNum:int;
		private var _score:int;
		public var lives:int;
		
		
		private var lastEnemyCollision:Number;
		
		public function Player(player:int = 1, lives:int = 3, flicker:Boolean = false, gameMode:int = 0) 
		{
			super();
			
			_playerNum = player;
			this.lives = lives;
			weapons = new Vector.<Weapon>;
			
			initSprite();
			initControls();
			
			lastEnemyCollision = 0;
			cameraBound = true;
			layer = LAYER_PLAYERS;
			
			mask = new Pixelmask(PLANE);
			setHitbox(64, 64);
			type = 'player';
			
			_maxHealth = 100;
			_health = 100;
			_maxShields = 300;
			_shields = 300;
			shieldRegenRate = 1;
			shieldFrameOffset = 14;
			score = 0;
			
			
			hud = new HUD(this, gameMode);
			
			spawnTime = Main.gametime;
			if (flicker)
				alphaDelta = 0.03;
			else
				alphaDelta = 0;
		}
		
		private function initSprite():void
		{
			sprite = new Spritemap(PLANE, 64, 64);
			shieldSprite = new Spritemap(PLANE, 64, 64);
			shieldSprite.alpha = 0;
			
			if (playerNum == 1)
			{
				sprite.add('normal', [3]);
				sprite.add('bank left', [2, 1, 0], 24, false);
				sprite.add('left to mid', [0, 1, 2, 3], 24, false);
				sprite.add('bank right', [4, 5, 6], 24, false);
				sprite.add('right to mid', [6, 5, 4, 3], 24, false);				
			} else if (playerNum == 2) {
				sprite.add('normal', [3]);
				sprite.add('bank left', [2, 1, 0], 24, false);
				sprite.add('left to mid', [0, 1, 2, 3], 24, false);
				sprite.add('bank right', [4, 5, 6], 24, false);
				sprite.add('right to mid', [6, 5, 4, 3], 24, false)
				
				/*
				sprite.add('normal', [10]);
				sprite.add('bank left', [9, 8, 7], 24, false);
				sprite.add('left to mid', [7, 8, 9, 10], 24, false);
				sprite.add('bank right', [11, 12, 13], 24, false);
				sprite.add('right to mid', [13, 12, 11, 10], 24, false);
				*/
			}
			sprite.play('normal');
			shieldSprite.play('normal');
			
			graphic = sprite;
		}
		
		private function initControls():void
		{
			// TODO: if winnitron
			if (playerNum == 1)
			{
				KEY_UP = Key.UP;
				KEY_DOWN = Key.DOWN;
				KEY_LEFT = Key.LEFT;
				KEY_RIGHT = Key.RIGHT;
				KEY_FIRE = Key.ENTER;
			} else if (playerNum == 2) {
				KEY_UP = Key.W;
				KEY_DOWN = Key.S;
				KEY_LEFT = Key.A;
				KEY_RIGHT = Key.D;
				KEY_FIRE = Key.SPACE;
			}
		}
		
		override public function added():void
		{
			FP.world.add(hud);
		}
		
		override public function removed():void
		{
			FP.world.remove(hud);
		}
		
		override public function update():void
		{
			checkInput();
			super.update();

			if (invulnerable)
			{
				sprite.alpha += alphaDelta;
				if (sprite.alpha <= 0.2 || sprite.alpha == 1.0)
					alphaDelta = -alphaDelta;
				
			} else {
				sprite.alpha = 1.0;
			}
			
			
			var enemy:Enemy = collide('enemy', x, y) as Enemy;
			if (!invulnerable && enemy && Main.gametime >= lastEnemyCollision + 0.3)
			{
				var eHP:int = enemy.health + enemy.shields;
				var pHP:int = health + shields;
				
				enemy.takeDamage(Math.abs(pHP), this);
				takeDamage(Math.abs(eHP));
				lastEnemyCollision = Main.gametime;
			}
			
			if (health / maxHealth <= 0.2)
			{
				if (Main.random(0, 100) <= 5)
				{
					var ex:int = Main.random(x, x + width);
					var ey:int = Main.random(y, y + height);
					var expl:Explosion = new Explosion(Explosion.SIZE_SMALL, ex, ey, Main.random(0.5, 0.9));
					FP.world.add(expl);
				}
				// TODO: add some smoke, too.
				
			}

		
			if (health <= 0)
			{
				FP.world.add(new Explosion(Explosion.SIZE_MED, x, y));
				FP.world.remove(this);
				FP.world.removeList(weapons);
				
				if (lives > 0)
				{
					var resurrected:Player = new Player(playerNum, lives - 1, true);
					
					var si:int = (FP.world as Gamespace).playerCount == 1 ? 0 : playerNum;
					resurrected.x = FP.world.camera.x + (Player.START_POINTS[si] as Point).x;
					resurrected.y = FP.world.camera.y + (Player.START_POINTS[si] as Point).y;
					
					resurrected.score = score;
					
					var w:Missiles = new Missiles(resurrected);
					w.pickup();
					FP.world.add(w);
					
					FP.world.add(resurrected);
					(FP.world as Gamespace).setPlayer(playerNum, resurrected);
				} else {
					trace('player ' + playerNum + ' dead.');
					lives = -1;
				}
				
			}
			
			shields += shieldRegenRate * FP.elapsed;
		}
		
		override public function render():void
		{
			super.render();
			//Draw.hitbox(this, true, 0xFF00FF);
		}
		
		private function checkInput():void
		{
			xSpeed = 0;
			ySpeed = 0;	
			if (Input.check(KEY_LEFT))
			{
				xSpeed = -MAX_SPEED;
				sprite.play('bank left');
			} else if (Input.check(KEY_RIGHT)) {
				xSpeed = MAX_SPEED;
				sprite.play('bank right');
			} else {
				if (sprite.currentAnim == 'bank left')
					sprite.play('left to mid');
				else if (sprite.currentAnim == 'bank right')
					sprite.play('right to mid');
			}
			
			if (Input.check(KEY_UP))
				ySpeed = -MAX_SPEED;
			else if (Input.check(KEY_DOWN))
				ySpeed = MAX_SPEED;
				
			if (Input.check(KEY_FIRE) && weapons.length > 0)
			{
				for each (var weapon:Weapon in weapons)
					weapon.fire();
			}
			
		}
		
		
		
		public function get playerNum():int
		{
			return _playerNum;
		}
		
		public function get score():int
		{
			return _score;
		}
		
		public function set score(newScore:int):void
		{
			var newLifeEvery:int = 50000;
			if (Math.floor(newScore / newLifeEvery) > Math.floor(_score / newLifeEvery))
			{
				lives++;
				// TODO: play a sweet sound
			}
			
			_score = newScore;
		}
		
		public function addWeapon(newWeapon:Weapon):void
		{
			// Uncommenting the below line will limit players to a single weapon at a time.
			//weapons = new Vector.<Weapon>;
			
			var found:Boolean = false;
			for each (var current:Weapon in weapons)
			{
				if (current is getClass(newWeapon))
				{
					found = true;
					current.upgrade();
				}
			}
			
			if (!found)
				weapons.push(newWeapon);
		}
		
		override public function get invulnerable():Boolean
		{
			var duration:int = 3;
			return Main.gametime > duration && Main.gametime <= spawnTime + duration;
		}
		
	}

}