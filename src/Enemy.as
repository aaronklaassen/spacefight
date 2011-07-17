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
		public static const TYPE_SPIRE:int = 2;
		public static const TYPE_STARSHIP:int = 3;
		
		[Embed(source = '../assets/images/littlelaser_bolt.png')]
		private const LASER_PROJ:Class;
		[Embed(source = '../assets/sounds/mid_laser.mp3')]
		private const LASER_SND:Class;
		
		protected var weapon:Weapon;
		protected var _firingDelay:Number;
		protected var nextFiringTime:Number;
		protected var firingSound:Sfx;
		
		protected var enemyType:int;
		protected var pointValue:int;
		
		protected var projSpawnPoints:Array;
		
		protected var damage:int;
		
		public function Enemy(etype:int = 1) 
		{
			super();
			enemyType = etype;
			
			layer = LAYER_ENEMIES;
			type = 'enemy';
			
			_maxHealth = 100;
			_health = 100;
			pointValue = 100;
			damage = 5;
			//min_shield_alpha = 0.3;
			firingSound = new Sfx(LASER_SND);
		}
		
		protected function initSprite():void
		{
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
				
				var powerup:Item = chooseDrop();
				if (powerup)
				{
					powerup.x = x;
					powerup.y = y;
					FP.world.add(powerup);
				}
			}
			
			if (onCamera && Main.gametime >= nextFiringTime) {
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
		
		protected function fireWeapon():void
		{				
			var speed:int;
			var spr:Spritemap;
			var p:Projectile;
			
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
		
		protected function closestPlayer():Player
		{
			var gs:Gamespace = FP.world as Gamespace;
			
			if (gs.gameMode == Gamespace.MODE_SINGLE)
			{
				return gs.getPlayer(1);
			} else {
				
				return distanceFrom(gs.getPlayer(1)) > distanceFrom(gs.getPlayer(2)) ? gs.getPlayer(1) : gs.getPlayer(2);
			}
		}
		
		protected function chooseDrop():Item
		{
			var item:Item;
			
			var type:int = Main.random(1, 5);
			if (type == 1) // drop a weapon
			{
				var w:int = Main.random(1, 4);
				
				if (w == 1)
					item = new Missiles();
				else if (w == 2)
					item = new LittleLaser();
				else if (w == 3)
					item = new LightningGun();
				else if (w == 4)
					item = new AutoLaser();
			} else if (type == 2) { // drop some points
				
				var s:int = Main.random(1, 10);
				
				if (s == 1)
					item = new BonusPoints(1000);
				else if (s > 1 && s <= 5)
					item = new BonusPoints(500);
				else
					item = new BonusPoints(250);
			}

			return item;
		}
	}

}