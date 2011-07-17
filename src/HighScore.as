package  
{
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Aaron
	 */
	public class HighScore extends GameEntity
	{
		public var name:String;
		public var points:int;
		
		private var nameSprite:Text;
		private var pointsSprite:Text;
		
		public function HighScore(data:String, points:int = -1)
		{
			super();
			if (points == -1)
			{
				fromJSON(data);
			} else {
				this.name = data;
				this.points = points;
			}
			
			nameSprite = new Text(name, 0, 0, 150, 50);
			nameSprite.size = 50;
			nameSprite.alpha = 0;
			pointsSprite = new Text('' + points, 0, 0, 200, 50);
			pointsSprite.size = 50;
			pointsSprite.alpha = 0;
		}
		
		private function fromJSON(json:String):void
		{
			// TODO
		}
		
		override public function update():void
		{
			super.update();
			nameSprite.alpha += 0.01;
			pointsSprite.alpha += 0.01;
		}
		
		override public function render():void
		{
			var target:BitmapData = renderTarget ? renderTarget : FP.buffer;
			
			nameSprite.render(target, new Point(x, y), FP.world.camera);
			pointsSprite.render(target, new Point(x + 300, y), FP.world.camera);
		}
	}

}