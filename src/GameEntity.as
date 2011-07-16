package  
{
	
	import net.flashpunk.Sfx;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Aaron
	 */
	public class GameEntity extends Entity
	{
		[Embed(source = '../assets/sounds/shield_hit.mp3')]
		private static const SHIELD_HIT_SND:Class;
		[Embed(source = '../assets/sounds/hit.mp3')]
		private static const HIT_SND:Class;
		
		public static const LAYER_PLAYERS:int = 0;
		public static const LAYER_ENEMIES:int = 5;
		
		protected static const MAX_SHIELD_ALPHA:Number = 0.85;
		protected static const SHIELD_ALPHA_DELTA:Number = -0.04; // per frame
		protected var min_shield_alpha:Number = 0;
		
		protected var sprite:Spritemap;
		protected var shieldSprite:Spritemap;
		protected var shieldFrameOffset:int;
		private var shieldHitSound:Sfx;
		private var hitSound:Sfx;
		
		public var xSpeed:Number; // current. pix/sec
		public var ySpeed:Number;
		
		protected var cameraBound:Boolean;
		protected var _maxHealth:int;
		protected var _health:int;
		protected var _maxShields:int;
		protected var _shields:Number;
		
		public function GameEntity() 
		{
			xSpeed = 0;
			ySpeed = 0;
			cameraBound = false;
			
			health = 1;
			shields = 0;
			
			shieldHitSound = new Sfx(SHIELD_HIT_SND);
			hitSound = new Sfx(HIT_SND);
		}
		
		public function get speed():Number
		{
			return Math.sqrt(xSpeed * xSpeed + ySpeed * ySpeed);
		}
		
		public function get maxHealth():int
		{
			return _maxHealth;
		}
		
		public function get health():int
		{
			return _health;
		}
		
		public function set health(h:int):void
		{
			_health = Math.min(h, maxHealth);
		}
		
		public function get shields():Number
		{
			return _shields;
		}
		
		public function set shields(s:Number):void
		{
			_shields = Math.min(s, maxShields);
		}
		
		public function get maxShields():int
		{
			return _maxShields;
		}
		
		public function set maxShields(s:int):void
		{
			_maxShields = s;
		}
		
		public function takeDamage(damage:int, doneBy:GameEntity = null):void
		{
			if (shieldSprite && shields > 0)
			{
				shieldSprite.alpha = MAX_SHIELD_ALPHA;
				
				if (this is Player)
					shieldHitSound.play();
			}
			
			shields -= damage;
			if (shields < 0)
			{
				if (shieldSprite)
					shieldSprite.alpha = 0;
				
				_health -= Math.abs(shields);
				shields = 0;
				hitSound.play(0.2);
			}
		}
		
		
		
		override public function update():void
		{
			super.update();
			
			var dx:Number = xSpeed * FP.elapsed;
			var dy:Number = ySpeed * FP.elapsed;
			
			x += dx;
			y += dy - Gamespace.SCROLL_SPEED * FP.elapsed; // stay with the camera.
				
			if (cameraBound)
			{
				if (x + dx <= 0)
					x = 0;
				else if (x + dx >= FP.screen.width - width)
					x = FP.screen.width - width;
			
				if (y + dy <= FP.world.camera.y)
					y = FP.world.camera.y;
				else if (y + dy >= FP.world.camera.y + FP.screen.height - height)
					y = FP.world.camera.y + FP.screen.height - height;
			}
			
			
			if (shieldSprite && shieldSprite.alpha > min_shield_alpha)
				shieldSprite.alpha += SHIELD_ALPHA_DELTA;
		}
		
		override public function render():void
		{
			super.render();
			
			if (shieldSprite)
			{
				shieldSprite.frame = sprite.frame + shieldFrameOffset;
				var target:BitmapData = renderTarget ? renderTarget : FP.buffer;
				shieldSprite.render(target, new Point(x, y), FP.world.camera);
			}
		}
		
		public function get invulnerable():Boolean
		{
			return false;
		}
		
		public static function getClass(obj:Object):Class
		{
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		
	}

}