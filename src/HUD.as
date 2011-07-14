package  
{
	
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.graphics.Text;
	
	import flash.geom.Point;
	
	
	/**
	 * ...
	 * @author Aaron
	 */
	public class HUD extends GameEntity
	{
		[Embed(source = '../assets/images/hud_ui.png')]
		private const HUD_UI:Class;
		
		private var player:Player;
		
		private var weaponBox:Spritemap;
		private var hullVal:Text;
		private var shield:Spritemap;
		private var shieldVal:Text;
		private var points:Text;
		private var lives:Spritemap;
		
		public function HUD(player:Player, gameMode:int) 
		{
			this.player = player;
			
			initSprite();
			setHitbox(sprite.width, sprite.height);
			
			if (player.playerNum == 1) // right side
				x = FP.screen.width - width;
			
				
			y = FP.world.camera.y + FP.screen.height - (height + 20);
			
			hullVal = new Text('100%', x + 15, y);
			shieldVal = new Text('100%', x + 15, y);
			shieldVal.color = 0x536fff;
			
			points = new Text('00000', 0, 0, 200, 50);
			points.size = 32;
			points.color = 0xff9000;
			
			if (player.playerNum == 1)
			{
				// right side
				//weaponBox.x = x - 40;
				lives.x = x - 30;
			} else {
				//weaponBox.x = x + 62;	
				lives.x = x + 52;
			}
			
			if (gameMode == Gamespace.MODE_VS)
			{
				if (player.playerNum == 1)
					points.x = x + width - points.width - 20;
				else
					points.x = 5;
			} else {
				points.x = (FP.screen.width / 2) - (points.width / 2);
			}
			
			layer = LAYER_PLAYERS + 2;
		}
		
		private function initSprite():void
		{
			sprite = new Spritemap(HUD_UI, 64, 64);
			sprite.add('p1 hull', [0]);
			sprite.play('p1 hull');
			graphic = sprite;
			
			shield = new Spritemap(HUD_UI, 64, 64);
			shield.add('p1 shield', [1]);
			shield.play('p1 shield');
			shield.color = 0x1a40ff;
			
			weaponBox = new Spritemap(HUD_UI, 64, 64);
			weaponBox.add('weapon', [2]);
			weaponBox.play('weapon');
			
			lives = new Spritemap(Player.PLANE, 64, 64);
			lives.add('normal', [3]);
			lives.play('normal');
			lives.scale = 0.4;
			lives.alpha = 0.8;
		}
		
		override public function update():void
		{
			super.update();
			
			
			
			var pctHealth:int = (player.health / player.maxHealth) * 100;
			if (pctHealth > 75)
				sprite.color = 0x22d000;
			else if (pctHealth <= 75 && pctHealth > 50)
				sprite.color = 0xe5f300;
			else if (pctHealth <= 50 && pctHealth > 25)
				sprite.color = 0xe97e00;
			else if (pctHealth <= 25)
				sprite.color = 0xe8060c;
			
			hullVal.text = Math.ceil(pctHealth) + '%';
			hullVal.y = y + height + 5;
			hullVal.color = sprite.color;
			
			shield.alpha = player.shields / player.maxShields;
			shieldVal.text = Math.ceil(player.shields / player.maxShields * 100) + '%';
			shieldVal.y = y + height;
			
			
			
			var game:Gamespace = FP.world as Gamespace;
			if (game.gameMode == Gamespace.MODE_COOP)
			{
				var total:int = game.getPlayer(1).score + game.getPlayer(2).score;
				points.text = '' + total;
			} else {
				points.text = '' + player.score;
			}
			
			while(points.text.length < 6) // zero-pad the score
			   points.text = "0" + points.text;
			
			points.y = y - (FP.screen.height - height) + 25;
			weaponBox.y = y + 10;
			lives.y = y + 50;
		}
		
		override public function render():void
		{
			var target:BitmapData = renderTarget ? renderTarget : FP.buffer;
			
			shield.render(target, new Point(x, y), FP.world.camera);
			
			if (player.health / player.maxHealth > 0.1 || Main.ticks % 24 < 12)
				super.render();
			
			var origin:Point = new Point(0, 0);
			hullVal.render(target, new Point(0, -85), FP.world.camera);
			shieldVal.render(target, origin, FP.world.camera);
			//weaponBox.render(target, origin, FP.world.camera);
			
			points.render(target, origin, FP.world.camera);
			
			for (var l:int = 0; l < player.lives; l++)
				lives.render(target, new Point(0, l * -30), FP.world.camera);
		}
		
	}

}