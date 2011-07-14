package  
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Aaron
	 */
	public class Enemy extends GameEntity
	{
		
		public static const TYPE_SCOUT:int = 1;
		[Embed(source = '../assets/images/enemy_scout.png')]
		private const SCOUT:Class;
		
		public static const TYPE_SPIRE:int = 2;
		[Embed(source = '../assets/images/enemy_spire.png')]
		private const SPIRE:Class;
		
		public static const TYPE_STARSHIP:int = 3;
		[Embed(source = '../assets/images/enemy_starship.png')]
		private const STARSHIP:Class;

		
		[Embed(source = '../assets/images/littlelaser_bolt.png')]
		private const LASER_PROJ:Class;
		[Embed(source = '../assets/sounds/mid_laser.mp3')]
		private const LASER_SND:Class;
		
		[Embed(source = '../assets/images/homing_flare.png')]
		private const FLARE_PROJ:Class;
		
		
		private var weapon:Weapon;
		private var _firingDelay:Number;
		private var nextFiringTime:Number;
		private var firingSound:Sfx;
		
		private var enemyType:int;
		private var pointValue:int;
		
		public function Enemy(etype:int = 1) 
		{
			super();
			enemyType = etype;
			
			initSprite();
			setHitbox(sprite.width, sprite.height);
			layer = LAYER_ENEMIES;
			type = 'enemy';
			
			_maxHealth = 100;
			_health = 100;
			
			if (enemyType == TYPE_STARSHIP)
				_health = 500;
			
			pointValue = 100;
			
			firingSound = new Sfx(LASER_SND);
		}
		
		private function initSprite():void
		{
			
			if (enemyType == TYPE_SCOUT)
			{
				mask = new Pixelmask(SCOUT);
				
				sprite = new Spritemap(SCOUT, 52, 70);
				sprite.add('normal', [0], 4);
			} else if (enemyType == TYPE_SPIRE) {
				mask = new Pixelmask(SPIRE);
				
				sprite = new Spritemap(SPIRE, 26, 120);
				sprite.add('normal', [0], 4);
			} else if (enemyType == TYPE_STARSHIP) {
				mask = new Pixelmask(STARSHIP);
				
				sprite = new Spritemap(STARSHIP, 63, 128);
				sprite.add('normal', [0], 4);
			}
			
			sprite.play('normal');
			graphic = sprite;
		}
		
		public function set firingDelay(fd:int):void
		{
			_firingDelay = fd;
			nextFiringTime = Main.gametime + _firingDelay;
		}
		
		override public function update():void
		{
			super.update();
			if (!onCamera && y > FP.world.camera.y)
			{
				FP.world.remove(this);
			}
			
			if (health <= 0)
			{
				FP.world.add(new Explosion(Explosion.SIZE_MED, x, y));
				FP.world.remove(this);
				
				if (Main.random(1, 100) <= 10)
				{
					var powerup:Item = new LittleLaser();
					powerup.x = x;
					powerup.y = y;
					FP.world.add(powerup);
				}
			}
			
			if (onCamera && Main.gametime >= nextFiringTime)
			{
				sprite.play('fire');
				fireWeapon();
				nextFiringTime = Main.gametime + _firingDelay;
			} else if (sprite.complete)
				sprite.play('normal');

		}
		
		override public function takeDamage(damage:int, doneBy:GameEntity = null):void
		{
			super.takeDamage(damage);
			
			if (health <= 0 && doneBy is Player)
			{
				(doneBy as Player).score += pointValue;
			}
		}
		
		private function fireWeapon():void
		{
			var projSpawnPoints:Array;
			
			if (enemyType == TYPE_SCOUT)
				projSpawnPoints = new Array(new Point(3, 35),
											new Point(49, 35));
			else if (enemyType == TYPE_SPIRE)
				projSpawnPoints = new Array(new Point(13, 110));
			else if (enemyType == TYPE_STARSHIP)
				projSpawnPoints = new Array(new Point(0, 90));
			else
				projSpawnPoints = new Array(new Point(0, 0)); // this shouldn't ever happen
			
			var damage:int;
			var speed:int;
			var spr:Spritemap;
			var p:Projectile;
			
			if (enemyType == TYPE_STARSHIP)
			{
				damage = 20;
				speed = ySpeed + 75;
				
				for (var i:int = 0; i < projSpawnPoints.length; i++)
				{
					spr = new Spritemap(FLARE_PROJ, 64, 64);
					spr.add('normal', [0, 1, 2, 3, 2, 1], 8);
					spr.play('normal');
					
					var target:Player = closestPlayer();
					var dist:int = distanceFrom(target);
					
					var pxSpeed:int = speed * (target.x - x) / dist;
					var pySpeed:int = speed * (target.y - y) / dist;
					
					p = new Projectile(spr, projSpawnPoints[i] as Point, this, pxSpeed, pySpeed, damage);
					p.rotating = true;
					FP.world.add(p);
				}
				
			} else {
				damage = 5;
				speed = ySpeed + 100;
				for (var j:int = 0; j < projSpawnPoints.length; j++)
				{
					spr = new Spritemap(LASER_PROJ, 10, 36);
					spr.add('normal', [0]);
					spr.play('normal');
					spr.color = 0xff3c3c;
					
					p = new Projectile(spr, projSpawnPoints[j] as Point, this, 0, speed, damage);
					
					
					FP.world.add(p);
				}
				firingSound.play(0.3);
			}
		}
		
		private function closestPlayer():Player
		{
			var gs:Gamespace = FP.world as Gamespace;
			
			if (gs.gameMode == Gamespace.MODE_SINGLE)
			{
				return gs.getPlayer(1);
			} else {
				
				return distanceFrom(gs.getPlayer(1)) > distanceFrom(gs.getPlayer(2)) ? gs.getPlayer(1) : gs.getPlayer(2);
				
			}
		}
		
		override public function toString():String
		{
			return super.toString() + ': type ' + enemyType;
		}
	}

}