package particles;
import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import pixi.core.Pixi;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;

import util.Asset;
import util.Pool;

/**
 * ...
 * @author 
 */
class SquareParticles extends BaseParticleEffect
{
	private var pool:Pool<SquareParticle>;
	
	private var area:Rectangle = new Rectangle(0, 0, 2048, 2048);
	
	public function new()
	{
		super();
		var c:Int = 0;
		this.pool = new Pool<SquareParticle>(450, function():SquareParticle{
			var p:SquareParticle = {
				sprite:Asset.getImage("star.png", true),
				lifetime:0,
				maxlife:0,
				sx:0,
				sy:0
			};
			this.addChild(p.sprite);
			p.sprite.scale.x = p.sprite.scale.y = 0.5;
			p.sprite.anchor.x = p.sprite.anchor.y = 0.5+Math.random();
			p.sprite.blendMode = Pixi.BLEND_MODES.ADD;
			p.sprite.visible = false;
			randomizeParticle(p,0x0);
			return p;
		});
	}
	
	public function spawn(point:Point,color:Int):Void
	{
		area.x = point.x - 65/2;
		area.y = point.y - 65/2;
		area.height = 130/2;
		area.width = 130/2;
		
		
		for (i in 0...50)
		{
			var p:SquareParticle = pool.getNext();
			
			randomizeParticle(p,color);
		}
	}
	
	private function randomizeParticle(p:SquareParticle,color:Int):Void
	{
		p.sprite.scale.x = p.sprite.scale.y = Math.random() * 0.06 + 0.025;
		p.lifetime = (Math.random() + 0.5)*80+30;
		p.maxlife = p.lifetime;
		p.sprite.x = Math.random() * area.width + area.x;
		p.sprite.y = Math.random() * area.height + area.y;
		p.sprite.visible = true;
		p.sx = (Math.random() - 0.5)*2;
		p.sy = (Math.random() - 1.5)*2;
		p.sprite.alpha = 1;
		p.sprite.rotation = 0;
		p.sprite.tint = color;
		Tween.get(p.sprite).to({alpha:0, rotation:Math.random() *Math.PI*5}, 600 + Math.floor(Math.random() * 400), Ease.quadOut);
		Tween.get(p.sprite.scale).to({x:0.5,y:0.5}, 600+Math.floor(Math.random()*400),Ease.quadOut);
	}
	
	override public function clear():Void 
	{
		super.clear();
	}

}

typedef SquareParticle = 
{
	public var sprite:Sprite;
	public var lifetime:Float;
	public var maxlife:Float;
	public var sy:Float;
	public var sx:Float;
}