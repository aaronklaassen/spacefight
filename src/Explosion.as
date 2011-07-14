package  
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Aaron
	 */
	public class Explosion extends GameEntity
	{
		[Embed(source = '../assets/images/explosion_23.png')]
		private const EXP_SMALL:Class;
		[Embed(source = '../assets/images/explosion_47.png')]
		private const EXP_MED:Class;
		
		[Embed(source = '../assets/sounds/explode1.mp3')]
		private const SND_1:Class;
		[Embed(source = '../assets/sounds/explode2.mp3')]
		private const SND_2:Class;
		
		public static const SIZE_SMALL:int = 0; // you know, like the island
		public static const SIZE_MED:int = 1;
		
		private var expSound:Sfx;
		
		public function Explosion(size:int, sx:int, sy:int, alpha:Number = 1.0) 
		{
			initSprite(size);
			x = sx;
			y = sy;
			layer = LAYER_PLAYERS - 5; // above players
			
			if (size != SIZE_SMALL)
			{
				if (Main.random(0, 1))
					expSound = new Sfx(SND_1);
				else
					expSound = new Sfx(SND_2);
			}
		}
		
		private function initSprite(size:int):void
		{
			if (size == SIZE_SMALL)
			{
				sprite = new Spritemap(EXP_SMALL, 23, 23);
				sprite.add('explode', [0, 1, 2, 3, 4, 5, 6, 7], 32, false);
				sprite.alpha = Main.random(0.3, 0.9);
			} else if (size == SIZE_MED) {
				sprite = new Spritemap(EXP_MED, 48, 48);
				sprite.add('explode', [0, 1, 2, 3, 4, 5, 6, 7], 24, false);
				sprite.alpha = Main.random(0.7, 1.0);
			}
			
			sprite.play('explode');
			graphic = sprite;
		}
		
		override public function update():void
		{
			super.update();
			
			if (expSound && !expSound.playing)
				expSound.play();
				
			if (sprite.complete)
				FP.world.remove(this);
			
		}
		
	}

}