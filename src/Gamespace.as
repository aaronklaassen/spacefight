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
		
		private var freeCamera:Boolean;
		
		private var gameEndTime:Number;
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
			
			nextFGspawn = 5; // increase this to add some delay before the first one
			betweenSpawns = 10;
			recentSpawnRects = new Array();
			
			playerCount = numPlayers;
			_gameMode = mode;
			
			players = new Array();
			for (var p:int = 1; p <= numPlayers; p++)
			{
				var pl:Player = new Player(p, 1, false, mode);
				
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
			
			
			//var m:Missiles = new Missiles();
			//var m:LittleLaser = new LittleLaser();
			//var m:LightningGun = new LightningGun();
			var m:AutoLaser = new AutoLaser();
			m.x = 400;
			m.y = 300;
			add(m);
			
			
			//var m2:Missiles = new Missiles();
			//var m2:LittleLaser = new LittleLaser();
			//m2.x = 500;
			//m2.y = 300;
			//add(m2);
			//
			//var m3:LightningGun = new LightningGun();
			//m3.x = 600;
			//m3.y = 300;
			//add(m3);
			
			
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
			
			var e3:Enemy = new Enemy(1);
			e3.x = 300;
			e3.y = 150;
			e3.ySpeed = 0;
			add(e3);
			
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
			
			
			if (gameOver())
			{
				if (!gameEndTime)
					gameEndTime = Main.gametime;
					
				var score1:int = (players[1] as Player).score;
				var score2:int = gameMode == MODE_SINGLE ? 0 : (players[2] as Player).score;
				if (gameEndTime + 5 <= Main.gametime)
				{
					FP.world = new EndGame(gameMode, score1, score2);
				} else {
					/*
					var overText:Text = new Text('Game Over!', FP.camera.x, FP.camera.y, 200, 50);
					overText.size = 30;
					overText.color = 0xFF0000;
					add(overText);
					*/
				}
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
		
		private function gameOver():Boolean
		{
			if (gameMode == MODE_SINGLE)
				return (players[1] as Player).lives < 0;
			else
				return (players[1] as Player).lives < 0 && (players[2] as Player).lives < 0;
				
		}
		
	}

}