package particles;
import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import pixi.core.Pixi;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;

import util.Asset;
import util.Pool;

/**
 * ...
 * @author 
 */
class BgStars extends BaseParticleEffect
{
	private var pool:Pool<BgStarParticle>;
	
	private var area:Rectangle = new Rectangle(0, 0, 2048, 2048);
	
	public function new()
	{
		super();
		var c:Int = 0;
		this.pool = new Pool<BgStarParticle>(50, function():BgStarParticle{
			var p:BgStarParticle = {
				sprite:Asset.getImage("UI_little circle.png", true),
				lifetime:0,
				maxlife:0,
				sx:0,
				sy:0
			};
			this.addChild(p.sprite);
			p.sprite.scale.x = p.sprite.scale.y = 0.1;
			p.sprite.anchor.x = p.sprite.anchor.y = 0.5+Math.random();
			p.sprite.blendMode = Pixi.BLEND_MODES.ADD;
			randomizeParticle(p);
			return p;
		});
		
		Main.instance.tickListeners.push(update);
	}
	
	private function randomizeParticle(p:BgStarParticle):Void
	{
		p.sprite.scale.x = p.sprite.scale.y = Math.random() * 0.06 + 0.025;
		p.lifetime = (Math.random() + 0.5)*80+30;
		p.maxlife = p.lifetime;
		p.sprite.x = Math.random() * area.width + area.x;
		p.sprite.y = Math.random() * area.height + area.y;
		p.sx = (Math.random() - 0.5)*2;
		p.sy = (Math.random() - 1.5)*2;
		
	}
	
	override public function update(d:Float):Void 
	{
		super.update(d);
		for (p in pool.all)
		{
			p.lifetime-= d;
			if (p.lifetime < 0)
				randomizeParticle(p);
			p.sprite.x += p.sx*d;
			p.sprite.y += p.sy*d;
			p.sprite.rotation = (p.lifetime+p.maxlife)*p.sprite.scale.x*0.1;
			//Update particle
			var phase:Float = (p.maxlife-p.lifetime) / p.maxlife;
			p.sprite.alpha = (phase < 0.34 ? phase / 0.34 : 1-(phase - 0.34) / (1 - 0.34))*0.5;
		}
	}
	
	override public function clear():Void 
	{
		super.clear();
	}

}

typedef BgStarParticle = 
{
	public var sprite:Sprite;
	public var lifetime:Float;
	public var maxlife:Float;
	public var sy:Float;
	public var sx:Float;
}