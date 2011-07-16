package  
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Aaron
	 */
	public class BonusPoints extends Item
	{
		[Embed(source = '../assets/images/gem250.png')]
		private const GEM250:Class;
		
		[Embed(source = '../assets/images/gem500.png')]
		private const GEM500:Class;
		
		[Embed(source = '../assets/images/gem1000.png')]
		private const GEM1000:Class;
		
		private var pointValue:int;
		
		public function BonusPoints(points:int) 
		{
			super();
			
			pointValue = points;
			
			if (pointValue == 250)
				icon = new Spritemap(GEM250, 32, 32);
			else if (pointValue == 500)
				icon = new Spritemap(GEM500, 32, 32);
			else if (pointValue == 1000)
				icon = new Spritemap(GEM1000, 32, 32);
			
			
			icon.add('floating', [0], 4, true);
			graphic = icon;
			
			setHitbox(32, 32);
		}
		

		override public function pickup():void
		{
			(owner as Player).score += pointValue;
			FP.world.remove(this);
			
		}
		
	}

}