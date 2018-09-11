package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import haxe.Timer;
import js.Lib;
import js.html.ScreenOrientation;
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
	private var score:Score;
	
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
		
		this.score = new Score();
		
		this.addChild(this.bg);
		this.addChild(this.control);
		this.addChild(this.score);
	}
	
	public function prepare():Void
	{
		this.control.prepare();
	}
	
	public function start():Void
	{
		this.control.enabled = true;
	}
	
	public function resize(size:Rectangle):Void
	{
		this.size = size;
		
		var s:Float = Math.max(size.width / bg.width, size.height / bg.height);
		this.scale.x = this.scale.y = s;
		
		//center the select.
		this.x = Math.round(( size.width - bg.width * s) / 2);
		this.y = Math.round(( size.height - bg.height * s) / 2 );
		
		if (size.width > size.height)
		{
			this.y = 0;
		}
	}
}
