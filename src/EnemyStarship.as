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
	public class EnemyStarship extends Enemy
	{
		[Embed(source = '../assets/images/enemy_starship.png')]
		private const STARSHIP:Class;
		
		[Embed(source = '../assets/images/homing_flare.png')]
		private const FLARE_PROJ:Class;
		
		public function EnemyStarship() 
		{
			super(TYPE_STARSHIP);
			_maxHealth = 500;
			_health = _maxHealth;
			pointValue = 200;
			damage = 20;
			projSpawnPoints = new Array(new Point(0, 90));
			shieldFrameOffset = 1;
			
			initSprite();
			setHitbox(sprite.width, sprite.height);
		}
		
		override protected function initSprite():void
		{
			mask = new Pixelmask(STARSHIP);
			
			shieldSprite = new Spritemap(STARSHIP, 63, 128);
			shieldSprite.alpha = min_shield_alpha;
			
			sprite = new Spritemap(STARSHIP, 63, 128);
			sprite.add('normal', [0], 4);
			
			sprite.play('normal');
			graphic = sprite;
		}
		
		override protected function fireWeapon():void
		{
			var damage:int;
			var speed:int;
			var spr:Spritemap;
			var p:Projectile;
			
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
			
		}
	}

}