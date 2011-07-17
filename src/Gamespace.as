package  
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author Aaron
	 */
	public class Gamespace extends World
	{
		[Embed(source = '../assets/images/starfield.jpg')]
		private const STARFIELD:Class;
		[Embed(source = '../assets/sounds/p0ss-oga-manifest.mp3')]
		private const MUSIC:Class;
		
		public static const LAYER_BACKGROUND:int = 1000;
		public static const SCROLL_SPEED:Number = 50; // pixels/sec
		
		public static const MODE_SINGLE:int = 0;
		public static const MODE_COOP:int = 1;
		public static const MODE_VS:int = 2;
		
		public static const MAX_HIGH_SCORES:int = 10;
		
		private var freeCamera:Boolean;
		
		private var gameEndTime:Number;
		private var highScores:Array;
		private var shownScores:Boolean = false;
		
		private var nextFGspawn:Number;
		private var betweenSpawns:Number; // max time between FG spawns
		private var recentSpawnRects:Array;
		
		private var addedLastFrame:FlightGroup;
			
		private var _playerCount:int;
		private var _gameMode:int;
		
		private var players:Array;
		
		private var bgMusic:Sfx;
		
		public function Gamespace(numPlayers:int = 1, mode:int = MODE_SINGLE) 
		{
			Main.resetGametime();
			addGraphic(new Backdrop(STARFIELD), LAYER_BACKGROUND);
			bgMusic = new Sfx(MUSIC);
			bgMusic.loop();
			
			freeCamera = false;
			
			nextFGspawn = 1; // increase this to add some delay before the first one
			betweenSpawns = 10;
			recentSpawnRects = new Array();
			
			playerCount = numPlayers;
			_gameMode = mode;
			
			players = new Array();
			for (var p:int = 1; p <= numPlayers; p++)
			{
				var pl:Player = new Player(p, 0, false, mode);
				
				var si:int = playerCount == 1 ? 0 : p;
				
				pl.x = FP.world.camera.x + (Player.START_POINTS[si] as Point).x;
				pl.y = FP.world.camera.y + (Player.START_POINTS[si] as Point).y;
				
				players[p] = pl;
				add(pl);
				
				var w:Missiles = new Missiles(pl);
				//var w:LittleLaser = new LittleLaser(pl);
				w.pickup();
				add(w);
			}
			
			
			players[1].score = 1540001; // TODO: temp test
			
			
			//var m:Missiles = new Missiles();
			//var m:LittleLaser = new LittleLaser();
			//var m:LightningGun = new LightningGun();
			//var m:AutoLaser = new AutoLaser();
			//m.x = 400;
			//m.y = 300;
			//add(m);
			//
			//
			//var m2:AutoLaser = new AutoLaser();
			//var m2:Missiles = new Missiles();
			//var m2:LittleLaser = new LittleLaser();
			//m2.x = 500;
			//m2.y = 300;
			//add(m2);
			//
			//
			//var m3:AutoLaser = new AutoLaser();
			//var m3:LightningGun = new LightningGun();
			//m3.x = 600;
			//m3.y = 300;
			//add(m3);
			
			/*
			var e:Enemy = new Enemy(1);
			e.x = 100;
			e.y = 50;
			e.ySpeed = 0;
			add(e);
			
			var e2:Enemy = new Enemy(2);
			e2.x = 200;
			e2.y = 50;
			e2.ySpeed = 0;
			add(e2);
			
			var e3:Enemy = new EnemySpire();
			e3.x = 300;
			e3.y = 150;
			e3.ySpeed = 0;
			e3.firingDelay = 5;
			add(e3);
			*/
			
		}
		
		override public function update():void
		{
			super.update();
			
			if (Input.released(Key.F1))
				freeCamera = !freeCamera;
			
			if (freeCamera)
			{
				if (Input.check(Key.NUMPAD_8))
					camera.y -= 20;
				
				if (Input.check(Key.NUMPAD_5))
					camera.y += 20;
			} else {
				camera.y -= SCROLL_SPEED * FP.elapsed;
			}
		
			// Can't do these collision detections right after the add (i.e. last frame),
			// because entity additions don't take place until end of frame.
			if (addedLastFrame)
			{
				var collision:Boolean = false;
				for each (var newEnemy:Enemy in addedLastFrame.enemies)
				{
					if (newEnemy.collide('enemy', newEnemy.x, newEnemy.y))
						collision = true;
				}
				
				if (collision)
					removeList(addedLastFrame.enemies);
					
				addedLastFrame = null;
			}
			
			if (nextFGspawn <= Main.gametime)
			{
				var fg:FlightGroup = new FlightGroup();
				// BUT! They might get removed next frame if they're colliding with existing enemies
				// i.e. before we ever see them.
				addList(fg.enemies);
				addedLastFrame = fg;
				nextFGspawn = Main.random(2, Main.gametime + betweenSpawns);
			}
			
			
			
			
			// If a player has died, check if their score is high enough to be in the
			// high score table, and ask them for initials if so.
			for each (var player:Player in players)
			{
				if (player.lives < 0 && !player.hasDied)
				{
					
					
					highScores = getHighScores();
					player.hasDied = true;
	
					var goodEnoughForPosterity:Boolean = placementInScoreTable(player.score) <= MAX_HIGH_SCORES;
					if (goodEnoughForPosterity)
					{
						var ix:int = 425;
						var iy:int = 300;
						
						if (gameMode != MODE_SINGLE)
						{
							if (Main.PLATFORM == 'PC')
								ix = player.playerNum == 1 ? 683 : 170;
							else
								ix = player.playerNum == 1 ? 170 : 683;
						}
						
						player.initialer = new Initialer(player.playerNum, ix, camera.y + iy, true);
						add(player.initialer);
					}
				}
			}
			
			
			
			if (gameOver())
			{
				showHighScores();
			}
			
		
		}
		
		public function get playerCount():int
		{
			return _playerCount;
		}
		
		public function set playerCount(val:int):void
		{
			_playerCount = val;
		}
		
		public function get gameMode():int
		{
			return _gameMode;
		}
		
		public function getPlayer(num:int):Player
		{
			return players[num] as Player;
		}
		
		public function setPlayer(playerNum:int, player:Player):void
		{
			players[playerNum] = player;
		}
		
		protected function gameOver():Boolean
		{	
			if (gameMode == MODE_SINGLE)
				return (players[1] as Player).lives < 0;
			else
				return (players[1] as Player).lives < 0 && (players[2] as Player).lives < 0;
				
		}
		
		
		
		private function showHighScores():void
		{
			var doneInitials:Boolean = false;
			if (gameMode == MODE_SINGLE)
			{
				doneInitials = !players[1].initialer || (players[1].initialer && players[1].initialer.enteredString != null);
			} else {
				doneInitials = (!players[1].initialer || (players[1].initialer && players[1].initialer.enteredString != null)) &&
								!players[2].initialer || (players[2].initialer && players[2].initialer.enteredString != null);
			}
			
			if (doneInitials && !shownScores)
			{
				for each (var player:Player in players)
				{
					if (player.initialer)
					{
						insertHighScore(new HighScore(player.initialer.enteredString, player.score));
					}
				}

				saveHighScores();
				// TODO Uncomment this once the save/load actually works.
				// highScores = getHighScores(); // They may have changed since last time.
				
				shownScores = true;
				for (var i:int = 0; i < Math.min(highScores.length, MAX_HIGH_SCORES); i++)
				{
					highScores[i].x = 260;
					highScores[i].y = camera.y + 150 + i * 50;
					add(highScores[i]);
				}
			}
		}
		
		private function placementInScoreTable(playerScore:int):int
		{
			for (var i:int = 0; i < highScores.length; i++)
			{
				if (playerScore > highScores[i].score)
					return i + 1;
			}
			
			return highScores.length + 1;
		}
		
		private function insertHighScore(newScore:HighScore):void
		{
			var insertIndex:int = -1;
			
			for (var i:int = 0; i < highScores.length; i++)
			{
				if (newScore.score > highScores[i].score)
				{
					insertIndex = i;
					break;
				}
			}
			
			if (insertIndex != -1)
			{
				for (var j:int = highScores.length - 1; j > insertIndex; j--)
				{
					highScores[j] = highScores[j - 1];
				}
				highScores[insertIndex] = newScore;
			}
		}
		
		private function getHighScores():Array
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
		
		private function saveHighScores():void
		{
			// TODO
		}
		
	}

}