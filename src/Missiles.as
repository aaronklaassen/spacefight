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
	public class Missiles extends Weapon
	{
		[Embed(source = '../assets/images/missile_icon.png')]
		private const MISSILE_ICON:Class;
		[Embed(source = '../assets/images/missile_proj.png')]
		private const MISSILE_PROJ:Class;
		[Embed(source = '../assets/sounds/missile_fire.mp3')]
		private const MISSILE_SND:Class;
		
		public function Missiles(own:GameEntity = null) 
		{
			super(own);
			
			name = 'Missiles'
			
			_cooldown = 0.3;
			damage = 25;
			
			icon = new Spritemap(MISSILE_ICON, 33, 40);
			icon.add('floating', [0, 1], 4, true);
			icon.add('hud_1', [0], 1, true);
			icon.add('hud_2', [2], 1, true);
			graphic = icon;
			
			setSpawnPoints();
			
			firingSound = new Sfx(MISSILE_SND);
		}
		
		override protected function setSpawnPoints():void
		{
			if (owner)
			{
				// TODO: vary by playerNum?
				projSpawnPoints[0] = new Point(15, 32);
				projSpawnPoints[1] = new Point(43, 32);
				
				projSpawnPoints[2] = new Point(0, 40);
				projSpawnPoints[3] = new Point(55, 40);
				
				projSpawnPoints[4] = new Point(25, 24);
				projSpawnPoints[5] = new Point(33, 24);
			}
		}
		
		override public function fire():void
		{
			if (isCool())
			{
				firingSound.play();
				for (var i:int = 0; i < Math.min(6, 2 * level); i++)
				{
					var spr:Spritemap = new Spritemap(MISSILE_PROJ, 10, 36);
					spr.add('normal', [0, 1, 2, 1], 16, true);
					spr.play('normal');

					var p:Projectile = new Projectile(spr, projSpawnPoints[i] as Point, owner, 0, -600, damage);
					FP.world.add(p);
				}
				lastFiringTime = Main.gametime;
			}
		}
		
	}

}