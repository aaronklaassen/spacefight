package  
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Aaron
	 */
	public class Weapon extends Item
	{
		public static const MAX_LEVEL:int = 3;
		
		protected var lastFiringTime:Number;
		protected var _cooldown:Number;
		protected var projSpawnPoints:Array;
		protected var projectileSpeed:int;
		
		public var name:String;
		protected var damage:int; // per projectile
		
		protected var firingSound:Sfx;
		
		public function Weapon(own:GameEntity = null) 
		{
			super(own);
			lastFiringTime = 0;
			_cooldown = 0;
			level = 1;
			projSpawnPoints = new Array();
			projectileSpeed = 0;
			setHitbox(60, 60);
		}
		
		public function get powerLevel():int
		{
			return level;
		}
		
		public function isCool():Boolean
		{
			return lastFiringTime + cooldown <= Main.gametime;
		}
		
		public function get cooldown():Number
		{
			return _cooldown;
		}
		
		public override function pickup():void
		{
			
			(owner as Player).addWeapon(this);
			// HUD weapon box location:
			/*
			if ((owner as Player).playerNum == 1)
				x = 924;
			else
				x = 67;
			y = FP.world.camera.y + 696;
			*/
			setSpawnPoints();
		}
		
		public function upgrade():void
		{
			level = Math.min(MAX_LEVEL, level + 1);
		}
		
		protected function setSpawnPoints():void { }
		
		public function fire():void { }
	}

}