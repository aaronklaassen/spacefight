package  
{
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Text;
	
	
	/**
	 * ...
	 * @author Aaron
	 */
	public class Menu extends World
	{
		[Embed(source = '../assets/images/title_screen.jpg')]
		private const TITLE_SCREEN:Class;
		
		[Embed(source = '../assets/sounds/menu_select.mp3')]
		private const BUTTON_SND:Class;
		
		protected var buttons:Array;
		protected var selectedIndex:int;
		private var buttonSound:Sfx;
		
		public function Menu() 
		{			
			addGraphic(new Backdrop(TITLE_SCREEN, false, false), 1000, 0, 0);
			
			buttons = new Array(new Text('1 Player', 0, 0, 200, 30),
								new Text('Co-Op', 0, 0, 200, 30),
								new Text('Versus', 0, 0, 200, 30));
			
			var middleX:int = 775;
			var topY:int = 250;
			
			for (var i:int = 0; i < buttons.length; i++)
			{
				var button:Text = buttons[i] as Text;
				button.size = 32;
				button.x = middleX - button.width / 2;
				button.y = topY + i * 50;
				addGraphic(button);
			}
			
			selectedIndex = 0;
			
			buttonSound = new Sfx(BUTTON_SND);
		}
		
		override public function update():void
		{
			if (Input.released(Key.DOWN))
			{
				selectedIndex = (selectedIndex + 1) % buttons.length;
				buttonSound.play();
			}
			
			if (Input.released(Key.UP))
			{			
				selectedIndex--;
				if (selectedIndex < 0)
					selectedIndex = buttons.length - 1;
					
				buttonSound.play();
			}
			
			if (Input.released(Key.ENTER))
			{
				buttonSound.play();
				
				var players:int;
				var mode:int;
				
				if (selectedIndex == 0)
				{
					players = 1;
					mode = Gamespace.MODE_SINGLE;
				} else if (selectedIndex == 1) {
					players = 2;
					mode = Gamespace.MODE_COOP;
				} else if (selectedIndex == 2) {
					players = 2;
					mode = Gamespace.MODE_VS;
				}
				
				FP.world = new Gamespace(players, mode);
				
			}
			
			for each (var b:Text in buttons)
			{
				b.color = 0xFFFFFF;
			}
			
			buttons[selectedIndex].color = 0x00FF00;
		}
		
	}

}