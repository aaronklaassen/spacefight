package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	/**
	 * ...
	 * @author Aaron
	 */
	public class FloatingText extends Entity 
	{
		private var text:Text;
		
		public function FloatingText(msg:String, x:int, y:int, color:uint = 0xFFFFFF)
		{
			text = new Text(msg);
			text.color = color;
			graphic = text;
			
			this.x = x;
			this.y = y;
		}
		
		override public function update():void
		{
			super.update();
			y -= 1.5;
			text.alpha -= 0.015;
			if (text.alpha == 0)
				FP.world.remove(this);
		}
	}

}