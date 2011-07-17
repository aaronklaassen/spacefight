package  
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Aaron
	 */
	public class Projectile extends GameEntity
	{
		[Embed(source = '../assets/sounds/hit.mp3')]
		private const HIT_SND:Class;
		
		protected var firedBy:GameEntity;
		protected var damage:int;
		
		protected var collidesWith:String;
		protected var hitSound:Sfx;
		
		public var rotating:Boolean;
		public var flashing:Boolean;
		private var flashDelta:Number = -0.03;
		
		
		public function Projectile(spritemap:Spritemap, startLoc:Point, owner:GameEntity, xs:int, ys:int, dam:int) 
		{
			super();
			
			

			if (owner)
			{
				firedBy = owner;
				layer = firedBy.layer + 2;
				
				if (startLoc)
				{
					x = owner.x + startLoc.x;
					y = owner.y + startLoc.y;
				}
			}
			xSpeed = xs;
			ySpeed = ys;
			damage = dam;
			sprite = spritemap;
			rotating = false;
			
			if (sprite)
			{
				graphic = sprite;
				sprite.centerOrigin();
				setHitbox(sprite.width, sprite.height);
			}
			
			
			
			
			type = 'projectile';
			if (owner is Player)
				collidesWith = 'enemy';
			else
				collidesWith = 'player';
				
			hitSound = new Sfx(HIT_SND);
		}
		
		override public function update():void
		{
			super.update();
			
			if (onCamera)
			{
				var victim:GameEntity = collide(collidesWith, x, y) as GameEntity;
				if (victim && !victim.invulnerable)
				{
					//hitSound.play(0.2);
					victim.takeDamage(damage, firedBy);
					FP.world.add(new Explosion(Explosion.SIZE_SMALL, x, y));
					FP.world.remove(this);
				}
				
				if (rotating)
				{
					sprite.angle = (sprite.angle + 10) % 360;
				}
				
				if (flashing)
				{
					sprite.alpha += flashDelta;
					if (sprite.alpha <= 0.6 || sprite.alpha == 1)
						flashDelta = -flashDelta;
				}
				
			} else {
				FP.world.remove(this);
			}
		}
	}

}