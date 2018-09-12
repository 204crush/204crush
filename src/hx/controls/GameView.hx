package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import haxe.Timer;
import js.Lib;
import js.html.ScreenOrientation;
import logic.GridLogic;
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
	private var praises:PraiseManager;
	
	private var bg:Sprite;
	private var control:GridControl;
	private var size:Rectangle;
	private var _score:Int = 0;
	
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
		this.control.addListener(GridControl.ON_BLOCK_REMOVE, onBlockRemove);
		
		this.score = new Score();
		this.score.x = 640;
		this.score.y = 110;
		
		this.praises = new PraiseManager();
		this.praises.x = control.x + Math.floor(( GridControl.BLOCK_WIDTH * GridLogic.GRID_WIDTH ) / 2);
		this.praises.y = control.y + Math.floor(( GridControl.BLOCK_WIDTH * GridLogic.GRID_WIDTH ) / 2);
		
		this.addChild(this.bg);
		this.addChild(this.control);
		this.addChild(this.score);
		this.addChild(this.praises);
	}
	
	public function prepare():Void
	{
		_score = 0;
		this.score.prepare();
		this.control.prepare();
	}
	
	public function start():Void
	{
		this.control.enabled = true;
	}
	
	private function onBlockRemove(count:Int):Void
	{
		_score += count;
		this.score.setScore(_score);
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
