package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import haxe.Timer;
import js.Lib;
import particles.ParticleManager;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import sounds.Sounds;
import util.MathUtil;
import util.Pool;

/**
 * ...
 * @author Henri Sarasvirta
 */
@:expose("GV")
class GameView extends Container
{
	private var control:GridControl;
	private var size:Rectangle;
	
	public function new() 
	{
		super();
		
		this.initializeControls();
		
		//Testing purposes
		this.control = new GridControl();
	}
	
	public function start():Void
	{
		this.control = new GridControl();
		
	}
	
	private function initializeControls():Void
	{
	}
	
	public function resize(size:Rectangle):Void
	{
		this.size = size;
		
	}
}
