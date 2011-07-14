package  
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Aaron
	 */
	public class Initialer extends Entity
	{
		private static const ALPHABET:String = '_ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		
		private var KEY_UP:int;
		private var KEY_DOWN:int;
		private var KEY_LEFT:int;
		private var KEY_RIGHT:int;
		private var KEY_ENTER:int;
		
		
		private var initials:Vector.<Text>;
		private var selectedInit:int;
		private var playerNum:int;
		
		private var finished:Boolean;
		
		public function Initialer(pn:int, sx:int, sy:int)
		{
			x = sx;
			y = sy;
			playerNum = pn;
			
			selectedInit = 0;
			finished = false;
			initials = new Vector.<Text>();
			
			for (var i:int = 0; i < 3; i++)
			{
				initials[i] = new Text('_', 0, 0, 75, 75);
				initials[i].size = 75;
			}
			
			initControls();
			
		}
		
		private function initControls():void
		{
			if (playerNum == 1)
			{
				KEY_UP = Key.UP;
				KEY_DOWN = Key.DOWN;
				KEY_LEFT = Key.LEFT;
				KEY_RIGHT = Key.RIGHT;
				KEY_ENTER = Key.ENTER;
			} else if (playerNum == 2) {
				KEY_UP = Key.W;
				KEY_DOWN = Key.S;
				KEY_LEFT = Key.A;
				KEY_RIGHT = Key.D;
				KEY_ENTER = Key.SPACE;
			}
		}
		
		override public function update():void
		{
			super.update();
			
			if (!finished)
			{
				if (Input.released(KEY_RIGHT))
				{
					selectedInit = (selectedInit + 1) % initials.length;
				}
				
				if (Input.released(KEY_LEFT))
				{
					selectedInit--;
					if (selectedInit < 0)
						selectedInit = initials.length - 1;
				}
				
				var curIndex:int = ALPHABET.search(initials[selectedInit].text);
				if (Input.released(KEY_UP))
				{
					curIndex = (curIndex + 1) % ALPHABET.length;
					initials[selectedInit].text = ALPHABET.slice(curIndex, curIndex + 1);
				}
				
				if (Input.released(KEY_DOWN))
				{
					curIndex--;
					if (curIndex < 0)
						curIndex = ALPHABET.length - 1;
						
					initials[selectedInit].text = ALPHABET.slice(curIndex, curIndex + 1);
				}
			}
			
			if (Input.check(KEY_ENTER))
				finished = true;
			
		}
		
		
		override public function render():void
		{
			//super.render();
			var target:BitmapData = renderTarget ? renderTarget : FP.buffer;
			
			for (var i:int = 0; i < initials.length; i++)
			{
				if (i != selectedInit || Main.ticks % 40 < 20)
					initials[i].render(target, new Point(x + i * (initials[i].width + 5), y), FP.world.camera);
			}
		}
		
		public function get done():Boolean
		{
			return finished;
		}
		
		public function get enteredString():String
		{
			var str:String = '';
			
			if (done)
			{
				for each (var initial:Text in initials)
					str += initial.text == '_' ? ' ' : initial.text;
			}
			
			return str;
		}
		
	}

}