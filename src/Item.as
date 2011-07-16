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
	public class Item extends GameEntity
	{
		[Embed(source = '../assets/sounds/17633__flatfly__pman8.mp3')]
		private static const DEFAULT_PICKUP:Class;
		
		public var owner:GameEntity;
		protected var icon:Spritemap;
		protected var level:int;

		protected var pickupSound:Sfx;
		
		private var floatRadius:int = 10;
		private var floatdX:Number = -0.2;
		private var floatdY:Number = -1;
		
		public function Item(own:GameEntity = null) 
		{
			super();
			owner = own;
			ySpeed = Gamespace.SCROLL_SPEED;
			layer = LAYER_PLAYERS + 1;
			
			pickupSound = new Sfx(DEFAULT_PICKUP);
		}
		
		override public function update():void
		{
			super.update();
			if (owner)
			{
				xSpeed = 0;
				ySpeed = 0;
				collidable = false;
				//icon.play('hud_' + level);
				graphic = null;
			} else {
				icon.play('floating');

				var play:Player = collide('player', x, y) as Player;
				if (play)
				{
					owner = play;
					pickupSound.play();
					pickup();
				}
				
				if (!onCamera)
					FP.world.remove(this);
				
				icon.x += floatdX;
				if (icon.x <= -floatRadius || icon.x >= floatRadius)
				{
					floatdX = -floatdX;
					floatdY = -floatdY;
				}
				icon.y = Math.sqrt(floatRadius * floatRadius - icon.x * icon.x) * floatdY;
			}
		}
		
		public function pickup():void { }
		
	}

}