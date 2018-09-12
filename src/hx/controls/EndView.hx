package controls;

import createjs.tweenjs.Tween;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import sounds.Sounds;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class EndView extends Container
{
	private var bg:Sprite;
	private var bg_sky:Sprite;
	private var bg_no_sky:Sprite;
	private var logo:Sprite;
	private var score:Sprite;
	private var credits:Sprite;
	public var _score:Score;
	
	public var again:Sprite;
	public var back:Sprite;
	
	private var origsize:Rectangle;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this._score = new Score();
		this._score.x = 1024;
		this._score.y = 790;
		
		this.logo = Asset.getImage("logo.png", false);
		this.logo.anchor.set(0.5, 0);
		this.logo.x = 1024;
		this.logo.y = 200;
		
		this.score = Asset.getImage("bg_finalscore.png", false);
		this.score.anchor.set(0.5, 0);
		this.score.x = 1024;
		this.score.y = 720;
		
		this.credits = Asset.getImage("text_credits.png", false);
		this.credits.anchor.set(0.5, 0);
		this.credits.x = 1024;
		this.credits.y = 980;
		
		this.again = Asset.getImage("button_again.png", false);
		this.again.anchor.set(0.5, 0);
		this.again.x = 1274;
		this.again.y = 1324;
		this.again.interactive = true;
		
		this.back = Asset.getImage("button_endgame.png", false);
		this.back.anchor.set(0.5, 0);
		this.back.x = 844;
		this.back.y = 1324;
		this.back.interactive = true;
		
		this.bg = Asset.getImage("bg.png", false);
		this.bg.anchor.set(0, 0.15);
		this.bg_sky = Asset.getImage("bg_sky.png", false);
		this.bg_no_sky = Asset.getImage("bg_no_sky.png", false);
		
		
		this.addChild(this.bg);
		//this.addChild(this.bg_sky);
		//this.addChild(this.bg_no_sky);
		this.addChild(this.logo);
		this.addChild(this.score);
		this.addChild(this.credits);
		this.addChild(this.again);
		this.addChild(this.back);
		this.addChild(this._score);
	}
	
	private var size:Rectangle;
	public function resize(size:Rectangle):Void
	{
		this.size = size;
		var tr:Rectangle = this.getTargetRect();
		//this.width = tr.width;
		//this.height = tr.height;
		this.scale.x = this.scale.y = Math.min( tr.width / 2048, tr.height / 2048);
		
		this.x = tr.x;
		this.y = tr.y;
		
	}
	
	private var minRectGame:Rectangle = new Rectangle(272, 170, 1528, 1152);
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