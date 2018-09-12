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
	
	public function resize(size:Rectangle)
	{
		var s:Float = Math.max(size.width / bg.width, size.height / bg.height);
		this.scale.x = this.scale.y = s;
		
		//center the select.
		this.x = Math.round(( size.width - bg.width * s) / 2);
		this.y = Math.round(( size.height - bg.height * s) / 2 );
		
	}
	
}