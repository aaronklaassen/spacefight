package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Aaron
	 */
	public class EndGame extends Entity
	{
		private var gameMode:int;
		private var initials1:Initialer;
	
		
		public function EndGame(mode:int, p1score:int = -1, p2score:int = -1) 
		{
			//initials1 = new Initialer(1, 250, 250);
			//add(initials1);
			
			var scores:Array = getHighScores(1);
			
			p1score = 1550001;
			var p1Place:int = placement(p1score, scores);
			scores = insertGap(scores, p1score);
			
			for (var i:int = 0; i < scores.length; i++)
			{
				var x:int = 260;
				var y:int = 150 + i * 50;
				
				if (scores[i] == null)
				{
					FP.world.add(new Initialer(1, x, y));
				} else {
					scores[i].x = x;
					scores[i].y = y;
					add(scores[i]);
				}
			}
			
		}
		
		private function insertGap(scores:Array, gapIndex:int):Array
		{
			for (var i:int = scores.length - 1; i > gapIndex; i--)
			{
				scores[i] = scores[i - 1];
			}
			scores[gapIndex] = null;
			
			return scores;
		}
		
		// Watch out; this is zero-based.
		private function placement(playerScore:int, scores:Array):int
		{
			for (var i:int = 0; i < scores.length; i++)
			{
				if (playerScore > scores[i].points)
					return i;
			}
			
			return scores.length;
		}
		
		private function getHighScores(gametype:int):Array
		{
			// TODO
			var scores:Array = new Array();
			scores[0] = new HighScore('A__', 1900001);
			scores[1] = new HighScore('B__', 1800001);
			scores[2] = new HighScore('C__', 1700001);
			scores[3] = new HighScore('D__', 1600001);
			scores[4] = new HighScore('E__', 1500001);
			scores[5] = new HighScore('F__', 1400001);
			scores[6] = new HighScore('G__', 1300001);
			scores[7] = new HighScore('H__', 1200001);
			scores[8] = new HighScore('I__', 1100001);
			scores[9] = new HighScore('J__', 1000001);
			
			return scores;
		}
		
		private function saveHighScores(scores:Array, gametype:int):void
		{
			// TODO
			for (var i:int = 0; i < 10; i++)
			{
				
			}
		}
		
		override public function update():void
		{
			super.update();
		}
	}

}