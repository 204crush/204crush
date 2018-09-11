package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import haxe.Timer;
import js.Lib;
import particles.ParticleManager;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import sounds.Sounds;
import util.Asset;
import util.MathUtil;
import util.Pool;

/**
 * ...
 * @author Henri Sarasvirta
 */
@:expose("GV")
class GameView extends Container
{
	private var bg:Sprite;
	private var control:GridControl;
	private var size:Rectangle;
	
	public function new() 
	{
		super();
		
		this.initializeControls();
		
	}
	
	private function initializeControls():Void
	{
		this.bg = Asset.getImage("bg.jpg", false);
		this.control = new GridControl();
		this.control.x = 640;
		this.control.y = 220;
		
		this.addChild(this.bg);
		this.addChild(this.control);
	}
	
	public function start():Void
	{
		
	}
	
	public function resize(size:Rectangle):Void
	{
		this.size = size;
		
		var s:Float = Math.max(size.width / bg.width, size.height / bg.height);
		this.scale.x = this.scale.y = s;
		
		//center the select.
		this.x = Math.round(( size.width - bg.width * s) / 2);
		this.y = Math.round(( size.height - bg.height * s) / 2 );
		
	}
}
