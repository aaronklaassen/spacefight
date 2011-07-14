package  
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Aaron
	 */
	public class LightningGun extends Weapon
	{
		[Embed(source = '../assets/images/lightning_icon.png')]
		private const LIGHTNING_ICON:Class;
	
		private static const MAX_JUMP_DIST:int = 350;
		private var target:GameEntity;
		
		public function LightningGun(own:GameEntity = null) 
		{
			super(own);
			
			icon = new Spritemap(LIGHTNING_ICON, 32, 32);
			icon.add('floating', [0, 1], 4, true);
			graphic = icon;
			
			_cooldown = 0.5;
			damage = 50;
			
		}
		
		override public function fire():void
		{
			if (isCool())
			{
				
				var jumpCount:int = 0;
				var maxJumps:int = 2 * level + 1;
				var alreadyHit:Vector.<GameEntity> = new Vector.<GameEntity>;
				
				// target is closest along line
				target = FP.world.collideLine('enemy',
											  owner.x + owner.halfWidth, owner.y,
											  owner.x + owner.halfWidth, Math.max(FP.world.camera.y, owner.y - 800)
											 ) as GameEntity;
											 
				var end:Point;
				if (target)
					end = new Point(target.x + target.halfWidth, target.y + target.halfHeight)
				else
					end = new Point(owner.x + owner.halfWidth, owner.y - 800);
					
				var bolt:LightningBolt = new LightningBolt(new Point(owner.x + owner.halfWidth, owner.y + owner.halfHeight), end);
				FP.world.add(bolt);
					
				//target = FP.world.nearestToEntity('enemy', this, true) as GameEntity;
				if (target)
				{
					target.takeDamage(damage, owner);
					alreadyHit.push(target);
					
					var potentials:Vector.<GameEntity> = new Vector.<GameEntity>;
					FP.world.collideRectInto('enemy', x - MAX_JUMP_DIST, y - MAX_JUMP_DIST, MAX_JUMP_DIST * 2, MAX_JUMP_DIST * 2, potentials);
					
					// sort potentials by distance so we jump from closest to farthest.
					potentials.sort(cmpDist);
					for each (var newTarget:GameEntity in potentials)
					{
						
						if (jumpCount >= maxJumps)
							continue;
							
						if (//jumpCount <= maxJumps &&
							alreadyHit.indexOf(newTarget) == -1 && target.distanceFrom(newTarget) <= MAX_JUMP_DIST)
						{
							
							alreadyHit.push(newTarget);
							jumpCount++;
							
							//trace(jumpCount + '/' + maxJumps);
							
							var start:Point = new Point(target.x + target.halfWidth, target.y + target.halfHeight);
							end = new Point(newTarget.x + newTarget.halfWidth, newTarget.y + newTarget.halfHeight);
							
							bolt = new LightningBolt(start, end);
							FP.world.add(bolt);
							
							newTarget.takeDamage(Math.max(20, damage - jumpCount * 10), owner);
							
							target = newTarget;
						}
					}
					//trace('------');
				}
				lastFiringTime = Main.gametime;
			}
		}
		
		
		private function cmpDist(e1:GameEntity, e2:GameEntity):Number
		{
			var dist1:Number = target.distanceFrom(e1);
			var dist2:Number = target.distanceFrom(e2);
			
			return dist1 - dist2;
		}
		
	}

}