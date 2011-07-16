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
	public class EnemyScout extends Enemy
	{
		[Embed(source = '../assets/images/enemy_scout.png')]
		private const SCOUT:Class;
		
		public function EnemyScout() 
		{
			super(TYPE_SCOUT);
			
			initSprite();
			setHitbox(sprite.width, sprite.height);
			
			projSpawnPoints = new Array(new Point(3, 35),
										new Point(49, 35));
		}
		
		override protected function initSprite():void
		{
			mask = new Pixelmask(SCOUT);
			
			sprite = new Spritemap(SCOUT, 52, 70);
			sprite.add('normal', [0], 4);
			
			sprite.play('normal');
			graphic = sprite;
		}
		
	}

}