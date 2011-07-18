package  
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Aaron
	 */
	public class AutoLaser extends Weapon
	{
		[Embed(source = '../assets/images/crosshair.png')]
		private const AUTOLASER_ICON:Class;
		
		[Embed(source = '../assets/sounds/laser2.mp3')]
		private const LASER_SND:Class;
		
		private const RANGE:int = 400;
		
		private var fireTick:int;
		private var target:GameEntity;
		private var endX:int;
		private var endY:int;
		
		public function AutoLaser(own:GameEntity = null) 
		{
			super(own);
			
			name = 'Auto Laser'
			
			icon = new Spritemap(AUTOLASER_ICON, 35, 35);
			icon.add('floating', [0, 1], 4, true);
			graphic = icon;
			
			layer = LAYER_PLAYERS + 1;
			
			fireTick = 0;
			_cooldown = 3;
			
			damage = 60;
			
			firingSound = new Sfx(LASER_SND);
		}
		
		override public function update():void
		{
			super.update();
			if (owner)
			{
				fire();
				_cooldown = 1.5 / level;
			}
		}
		
		override public function fire():void
		{
			if (isCool())
			{
				
				target = FP.world.nearestToEntity('enemy', owner, true) as GameEntity;
				
				if (target && owner.distanceFrom(target) <= RANGE)
				{
					
					firingSound.play(0.6);
					target.takeDamage(damage * level, owner);
					
					fireTick = Main.ticks;
					
					endX = target.x + target.halfWidth + Main.random( -target.halfWidth / 2, target.halfWidth / 2);
					endY = target.y + target.halfHeight + Main.random( -target.halfHeight / 2, target.halfHeight / 2);
					
					FP.world.add(new Explosion(Explosion.SIZE_SMALL, endX - 12, endY - 12, Main.random(0.4, 0.6)));
					
					lastFiringTime = Main.gametime;
				}
			}
		}
		
		override public function render():void
		{
			super.render();
			
			if (owner && fireTick > 0 && Main.ticks < fireTick + 8)
			{
				Draw.line(owner.x + owner.halfWidth, owner.y + owner.halfHeight, endX, endY, 0xf03e3e);
				Draw.line(owner.x + owner.halfWidth, owner.y + owner.halfHeight - 1, endX, endY - 1, 0xea6262);
				Draw.line(owner.x + owner.halfWidth, owner.y + owner.halfHeight + 1, endX, endY + 1, 0xea6262);
				
				endY -= Gamespace.SCROLL_SPEED * FP.elapsed;
			} else {
				fireTick = 0 ;
			}
		}
		
	}

}