package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Draw;
	
	
	/**
	 * ...
	 * @author Aaron
	 */
	public class LightningBolt extends Projectile
	{
		[Embed(source = '../assets/images/lightning.png')]
		private const LIGHTNING:Class;
		
		[Embed(source = '../assets/sounds/electricity.mp3')]
		private const HIT_SND:Class;
		
		// These are NOT adjusted for the dimensions of the sprite. Assume the sprite is a line.
		private var startPoint:Point;
		private var endPoint:Point;
		
		public function LightningBolt(start:Point, end:Point)
		{
			super(null, null, null, 0, 0, 0);
							
			startPoint = start;
			endPoint = end;
			initSprite();
			setHitbox(sprite.width, sprite.height);

			layer = LAYER_PLAYERS + 1;
			sprite.originX = sprite.width / 2;
			sprite.originY = sprite.height;
			
			x = startPoint.x - sprite.width / 2;
			y = startPoint.y - sprite.height;
			
			hitSound = new Sfx(HIT_SND);
			hitSound.play(0.5);
		}
		
		private function initSprite():void
		{
			var length:int = 800;
			var angle:int = 0;
			
			length = FP.distance(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
			angle = FP.angle(startPoint.x, startPoint.y, endPoint.x, endPoint.y);

			// The angles returned by FP.angle are offset from how Spritemap uses them. Dumb.
			angle = (angle + 270) % 360;
			
			sprite = new Spritemap(LIGHTNING, 50, length);
			sprite.add('normal', [0]);
			sprite.angle = angle;
			
			// Mix it up at bit.
			if (Main.random(0, 1))
				sprite.flipped = true;
				
			graphic = sprite;
		}
		

		override public function update():void
		{
			sprite.alpha -= 0.07;
			
			if (sprite.alpha <= 0)
			{
				FP.world.remove(this);
			}
		}
		
		
		
		/*
		override public function render():void
		{
			super.render();
			//Draw.rect(x - MAX_JUMP_DIST / 2, y - MAX_JUMP_DIST / 2, MAX_JUMP_DIST, MAX_JUMP_DIST, 0xff00ff, 0.5);
			Draw.hitbox(this, true, 0xff00ff);
		}
		*/
	}

}