package filters.bg;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import haxe.Resource;
import js.Lib;
import pixi.core.Pixi;
import pixi.core.display.Container;
import pixi.core.math.Matrix;
import pixi.core.math.shapes.Rectangle;
import pixi.core.renderers.webgl.filters.Filter;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.extras.TilingSprite;
import util.Asset;

/**
 * ...
 * @author 
 */
class BgFilter extends Filter
{
	public var uniforms:Dynamic;
	
	private var time:Float = 0;
	
	public function new() 
	{
		var tex:Texture = Asset.getTexture("noise.jpg", false);
		tex.baseTexture.mipmap = false;
		tex.baseTexture.wrapMode = Pixi.WRAP_MODES.REPEAT;
		
		var frag:String = Resource.getString("bg.frag");
		super(null, frag, uniforms);
		uniforms.noise = tex;
		untyped this.padding = 0;
	}
	
	public function resize(size:Rectangle):Void
	{
		this.uniforms.aspect = size.height / size.width;
	}
	
	override public function apply(filterManager:Dynamic, input:Dynamic, output:Dynamic, ?clear:Bool):Void 
	{
		time+= 1 / 260;
		if (time > 100) time = 0;
		this.uniforms.time = time;
		this.uniforms.off = [-Main.instance.game.charpos.x/2000, -Main.instance.game.charpos.y/2000];
		super.apply(filterManager, input, output, clear);
	}
	
	public function wrong():Void
	{
		this.uniforms.flash += 2;
		Tween.removeTweens(this.uniforms);
		Tween.get(this.uniforms).to( { flash:0 }, 1050, Ease.quadIn);
	}
}