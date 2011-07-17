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
	public class EnemySpire extends Enemy
	{
		[Embed(source = '../assets/images/enemy_spire.png')]
		private const SPIRE:Class;
		
		public function EnemySpire() 
		{
			super(TYPE_SPIRE);
			
			initSprite();
			setHitbox(sprite.width, sprite.height);
			
			projectileColor = 0xff9000;
			damage = 20;
			shieldFrameOffset = 1;
			_maxShields = 800;
			_shields = 800;
			
			projSpawnPoints = new Array(new Point(13, 110));
		}
		
		override protected function initSprite():void
		{
			mask = new Pixelmask(SPIRE);
			
			shieldSprite = new Spritemap(SPIRE, 26, 120);
			shieldSprite.alpha = min_shield_alpha;
			
			sprite = new Spritemap(SPIRE, 26, 120);
			sprite.add('normal', [0], 4);
			
			sprite.play('normal');
			graphic = sprite;
		}
		
	}

}