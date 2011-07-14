package  
{
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Aaron
	 */
	public class EndGame extends World
	{
		private var gameMode:int;
		private var initials1:Initialer;
		
		public function EndGame(mode:int, p1score:int = -1, p2score:int = -1) 
		{
			initials1 = new Initialer(1, 250, 250);
			add(initials1);
		}
		
	}

}