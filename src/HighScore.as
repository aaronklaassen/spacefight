package  
{
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import com.adobe.serialization.json.JSON;
	
	/**
	 * ...
	 * @author Aaron
	 */
	public class HighScore extends GameEntity
	{
		public var name:String;
		public var score:int;
		
		private var nameSprite:Text;
		private var pointsSprite:Text;
		
		public function HighScore(data:String, points:int)
		{
			super();

			this.name = data;
			this.score = points;

			
			nameSprite = new Text(name, 0, 0, 150, 50);
			nameSprite.size = 50;
			nameSprite.alpha = 0;
			pointsSprite = new Text('' + score, 0, 0, 200, 50);
			pointsSprite.size = 50;
			pointsSprite.alpha = 0;
		}
		
		public static function arrayFromJSON(jsonData:String):Array
		{
			var json:Object = JSON.decode(jsonData);
			
			var list:Array = new Array();
			for each (var hscore:Object in json.scores)
			{
				list.push(new HighScore(hscore.name, hscore.score));
			}
			
			return list;
		}
		
		public static function arrayToJSON(scores:Array):String
		{
			var json:Array = new Array();
			
			for each (var score:HighScore in scores)
			{
				json.push(score.toJSON());
			}
			
			return '{"scores": [' + json.join() + ']}';
		}
		
		public function toJSON():String
		{
			return '{"name": "' + name + '", "score": "' + score + '"}';
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