package  
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Aaron
	 */
	public class FlightGroup
	{
		private static const NONE:int = 0;
		private static const HORIZ:int = 1;
		private static const VERT:int = 2;
		private static const DIAMOND:int = 3;
		private static const DIAG_L2R:int = 4;
		private static const DIAG_R2L:int = 5;
		
		private var eType:int;
		private var _rect:Rectangle;
		private var _enemies:Array;
		private var protoEnemy:Enemy;
		private var ySpeed:int;
		private var xSpeed:int;
		
		public function FlightGroup() 
		{
			eType = Main.random(1, 6);
			if (eType == 6)
				eType = Enemy.TYPE_STARSHIP;
			else
				eType = Main.random(1, 2);
				
			
			protoEnemy = new Enemy(eType);
			
			if (eType == Enemy.TYPE_STARSHIP)
			{
				ySpeed = Main.random(Gamespace.SCROLL_SPEED + 20, 100);
				xSpeed = 0;
			} else {
				ySpeed = Main.random(Gamespace.SCROLL_SPEED + 20, 200);
				xSpeed = Main.random(0, 30);
			}
			
			var positions:Array = makeFormation();
			initRect(positions);
			_enemies = new Array();
			
			
			// Always move across the screen, not to the nearest side and gone.
			if (rect.x > FP.screen.width / 2)
				xSpeed = -xSpeed;
			
			var firingDelay:int = Main.random(2, 4);
			for each (var fgPos:Point in positions)
			{
				var e:Enemy = new Enemy(eType);
				e.x = rect.x + fgPos.x;
				e.y = rect.y + fgPos.y;
				
				e.xSpeed = xSpeed;
				e.ySpeed = ySpeed;
				
				e.firingDelay = firingDelay;
				
				_enemies.push(e);
			}
			
		}
		
		private function initRect(positions:Array):void
		{
			var min:Point = new Point();
			var max:Point = new Point();
			
			for each (var fgPos:Point in positions)
			{
				if (min.x == 0 || fgPos.x < min.x)
					min.x = fgPos.x;
					
				if (min.y == 0 || fgPos.y < min.y)
					min.y = fgPos.y;
					
				if (max.x == 0 || fgPos.x > max.x)
					max.x = fgPos.x;
					
				if (max.y == 0 || fgPos.y > max.y)
					max.y = fgPos.y;
			}
			
			
			
			_rect = new Rectangle(Main.random(0, FP.screen.width - (max.x + protoEnemy.width - min.x)),
								  FP.camera.y - (max.y + protoEnemy.height) - min.y,
								  max.x + protoEnemy.width - min.x,
								  max.y + protoEnemy.height - min.y);
		}
		
		private function makeFormation():Array
		{
			var shape:int = NONE;
			if (eType != Enemy.TYPE_STARSHIP)
				shape = Main.random(HORIZ, DIAG_R2L);
			
			
			var points:Array = new Array();
			
			var i:int, count:int, gap:int;
			switch (shape)
			{
				case NONE:
					points.push(new Point(0, 0));
					break;
				case HORIZ:
					count = Main.random(1, 4);
					gap = Main.random(10, 30);
					for (i = 0; i < count; i++)
						points.push(new Point(i * protoEnemy.width + i * gap, 0));
					break;
					
				case VERT:
					count = Main.random(1, 4);
					gap = Main.random(20, 40);
					for (i = 0; i < count; i++)
						points.push(new Point(0, i * protoEnemy.height + i * gap));
					break;
					
				case DIAMOND:
					points.push(new Point(protoEnemy.width, 0)); // top
					points.push(new Point(0, protoEnemy.height)); // left
					points.push(new Point(protoEnemy.width * 2, protoEnemy.height)); // right
					points.push(new Point(protoEnemy.width, protoEnemy.height * 2)); // bottom
					break;
					
				case DIAG_L2R:
					count = Main.random(2, 4);
					for (i = 0; i < count; i++)
						points.push(new Point(i * protoEnemy.width, i * protoEnemy.height));
					break;
					
				case DIAG_R2L:
					count = Main.random(2, 4);
					for (i = 0; i < count; i++)
						points.push(new Point(protoEnemy.width * count - i * protoEnemy.width, i * protoEnemy.height));
					break;
			} 
			
			
			return points;
		}
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function get enemies():Array
		{
			return _enemies;
		}
	}

}