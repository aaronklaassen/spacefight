package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='60')]
	public class Main extends Engine 
	{
		[Embed(source = '../assets/sounds/p0ss-oga-manifest.mp3')]
		private const MUSIC:Class;
		
		public static const PLATFORM:String = 'PC';
		//public static const PLATFORM:String = 'WINNITRON';
		
		
		private static var _gametime:Number;
		private static var _loopcount:uint;
		
		private var pauseGame:Boolean;
		private var bgMusic:Sfx;
		
		public function Main():void 
		{
			super(1024, 768);
		}
		
		override public function init():void 
		{
			bgMusic = new Sfx(MUSIC);
			bgMusic.loop();
			
			_gametime = 0;
			pauseGame = false;
			FP.world = new Menu();
		}
		
		public static function fps():int
		{
			return 1 / FP.elapsed;
		}
		
		override public function update():void
		{
			if (!pauseGame)
			{
				super.update();
				_gametime += FP.elapsed;
				_loopcount++;
			}
			
			if (Input.released(Key.P))
				pauseGame = !pauseGame;
		}

		public static function get gametime():Number
		{
			return _gametime;
		}
		
		public static function resetGametime():void
		{
			_gametime = 0;
		}
		
		public static function get ticks():uint
		{
			return _loopcount;
		}
		
		public static function random(min:Number, max:Number):Number
		{
			return (Math.random() * (max + 1 - min)) + min;
		}
		
		public static function toRadians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
		public static function mergeArrays(a1:Array, a2:Array):Array
		{
			for (var i:int = 0; i < a2.length; i++)
				a1[a1.length] = a2[i];
			
			return a1;
		}
		
		
	}
	
	
	
}