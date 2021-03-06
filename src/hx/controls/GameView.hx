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
	public static var GAME_ENDED:String = "onGameEnded";
	
	private var score:Score;
	private var praises:PraiseManager;
	
	private var bg:Sprite;
	private var bgSky:Sprite;
	private var logo:Sprite;
	private var scoreBG:Sprite;
	private var control:GridControl;
	private var size:Rectangle;
	public static var _score:Int = 0;
	private var lineAnimator:LineAnimator;
	
	private var logoPos:Point = new Point(0,0);
	private var scorePos:Point = new Point(0,0);
	
	public function new() 
	{
		super();
		
		this.initializeControls();
		
	}
	
	private function initializeControls():Void
	{
		this.bg = Asset.getImage("bg_no_sky.png", false);
		this.bgSky = Asset.getImage("bg_sky.png", false);
		this.logo = Asset.getImage("logo.png", false);
		this.logo.anchor.set(0.5);
		this.logo.scale.set(0.5);
		this.scoreBG = Asset.getImage("bg_score.png", false);
		this.scoreBG.anchor.set(0.5,0);
		
		this.control = new GridControl();
		this.control.x = 640;
		this.control.y = 220;
		this.control.onGameEnd = onGameEnd;
		this.control.addListener(GridControl.ON_BLOCK_REMOVE, onBlockRemove);
		
		this.score = new Score();
		this.score.x = 640;
		this.score.y = 90;
		this.score.scale.set(0.75);
		
		this.praises = new PraiseManager();
		this.praises.x = control.x + Math.floor(( GridControl.BLOCK_WIDTH * GridLogic.GRID_WIDTH ) / 2);
		this.praises.y = control.y + Math.floor(( GridControl.BLOCK_WIDTH * GridLogic.GRID_WIDTH ) /2 );
		
		this.lineAnimator = new LineAnimator();
		
		this.addChild(this.bgSky);
		this.addChild(this.bg);
		this.addChild(this.control);
		this.addChild(this.scoreBG);
		this.addChild(this.score);
		this.addChild(this.praises);
		this.addChild(this.lineAnimator);
		this.addChild(this.logo);
	}
	
	private function onGameEnd():Void
	{
		this.emit(GAME_ENDED);
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
		var tr:Rectangle = this.getTargetRect();
		//this.width = tr.width;
		//this.height = tr.height;
		this.scale.x = this.scale.y = Math.min( tr.width / 2048, tr.height / 2048);
		this.x = tr.x;
		this.y = tr.y;
		
		if ( size.width > size.height ) //Landscape
		{
			logoPos.set(450, 512);
			scorePos.set(1624, 512);
		} else // Portrait
		{
			this.y += 100;
			bgSky.y = -100 / this.scale.y;
			logoPos.set(1024-100, 0);
			scorePos.set(1024+100, 0);
		}
		
		this.score.x = scorePos.x;
		this.score.y = scorePos.y + 30;
		this.scoreBG.x = scorePos.x;
		this.scoreBG.y = scorePos.y;
		this.logo.x = logoPos.x;
		this.logo.y = logoPos.y;
	}
	
	private var minRectGame:Rectangle = new Rectangle(272, 50, 1528, 1050);
	private var minRectPortraitGame:Rectangle = new Rectangle(568,0, 920, 1580);
	private function getTargetRect():Rectangle
	{
		
		var ret:Rectangle = new Rectangle(0,0,0,0);
		var iswide:Bool = size.width > size.height;
		var mr:Rectangle =  iswide ? minRectGame : minRectPortraitGame;
		
		var s:Float = Math.min(size.width / mr.width, size.height / mr.height);
		ret.width = bg.width * s;
		ret.height = bg.height * s;
		
		ret.x = Math.round((size.width - bg.width * s)/2);
		ret.y = Math.floor( Math.max( -mr.y * s, Math.floor(( size.height - this.bg.height * s+50*s)))); 
		if (size.width < size.height)
		{
			//Limit bottom on mobile.
			ret.y =Math.floor( Math.max( ret.y, (-1970*s+size.height)));
		}
		
		return ret;
	}
}
