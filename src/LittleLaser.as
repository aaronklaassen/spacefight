package  
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Aaron
	 */
	public class LittleLaser extends Weapon
	{
		[Embed(source = '../assets/images/laser_icon.png')]
		private const LASER_ICON:Class;
		[Embed(source = '../assets/images/littlelaser_bolt.png')]
		private const LASER_PROJ:Class;
		[Embed(source = '../assets/sounds/mid_laser.mp3')]
		private const LASER_SND:Class;
		
		public function LittleLaser(own:GameEntity = null) 
		{
			super(own);
			
			name = 'Laser'
			
			icon = new Spritemap(LASER_ICON, 33, 40);
			icon.add('floating', [0, 1], 4, true);
			icon.add('hud_1', [0], 1, true);
			icon.add('hud_2', [2], 1, true);
			graphic = icon;
			
			_cooldown = 0.1;
			damage = 10;
			projectileSpeed = -750;
			
			if (owner && owner is Enemy)
			{
				projectileSpeed = 400;
				damage = 5;
			}
			
			firingSound = new Sfx(LASER_SND);
		}
		
		override protected function setSpawnPoints():void
		{
			if (owner)
			{
				projSpawnPoints[0] = new Point(25, 32);
				projSpawnPoints[1] = new Point(33, 32);
				projSpawnPoints[2] = new Point(15, 37);
				projSpawnPoints[3] = new Point(43, 37);
				projSpawnPoints[4] = new Point(0, 32);
				projSpawnPoints[5] = new Point(56, 32);
			}
		}
		
		override public function fire():void
		{
			if (isCool())
			{
				firingSound.play(0.4);
								
				for (var i:int = 0; i < 2 * level; i++)
				{
					var bolt:Spritemap = new Spritemap(LASER_PROJ, 8, 18);
					bolt.add('normal', [0], 1, true);
					bolt.play('normal');
					bolt.color = 0x34cb3b;
					

					var xspeed:int = 0;
					var yspeed:int = projectileSpeed;
					var rad:Number;
					if (i == 2) // up/left
					{
						//rad = 0.78;
						//bolt.angle = 45;
						rad = 1.17;
						bolt.angle = 22;
						yspeed = Math.sin(rad) * projectileSpeed;
						xspeed = Math.cos(rad) * projectileSpeed;
					} else if (i == 3) { // up/right
						//rad = 5.49;
						//bolt.angle = 315;
						rad = 1.95;
						bolt.angle = 338;
						yspeed = Math.sin(rad) * projectileSpeed;
						xspeed = Math.cos(rad) * projectileSpeed;
					}
					
					var p:Projectile = new Projectile(bolt, projSpawnPoints[i] as Point, owner, xspeed, yspeed, damage);
					FP.world.add(p);
				}
				lastFiringTime = Main.gametime;
			}
		}
	}

}