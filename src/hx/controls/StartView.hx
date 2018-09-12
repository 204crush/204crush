package controls;

import createjs.easeljs.graphics.Rect;
import createjs.soundjs.AbstractSoundInstance;
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
class StartView extends Container
{
	private var bg:Sprite;
	private var bg_sky:Sprite;
	private var bg_no_sky:Sprite;
	private var logo:Sprite;
	private var swipe:Sprite;
	private var text:Sprite;
	private var match:Sprite;
	public var start_small:Sprite;
	public var start_medium:Sprite;
	public var start_big:Sprite;
	public var bg_boardselection:Sprite;
	
	private var origsize:Rectangle;
	
	private var soundObj:AbstractSoundInstance;
	
	
	public function new() 
	{
		super();
		this.initializeControls();
		soundObj = Sounds.playEffect(Sounds.START, 0, 0.3);
		this.soundObj.addEventListener("complete", function() {Sounds.playEffect(Sounds.BACKGROUND, 0.3); } );
	}
	
	private function initializeControls():Void
	{
		this.logo = Asset.getImage("logo.png", false);
		this.logo.anchor.set(0.5, 0);
		this.logo.x = 1024;
		this.logo.y = 200;
		
		this.swipe = Asset.getImage("tutorial_swipe.png", false);
		this.swipe.anchor.set(0.5, 0);
		this.swipe.x = 760;
		this.swipe.y = 680-50;
		
		this.match = Asset.getImage("tutorial_match.png", false);
		this.match.anchor.set(0.5, 0);
		this.match.x = 760;
		this.match.y = 1000-50;
		
		this.text = Asset.getImage("text_tutorial.png", false);
		this.text.anchor.set(0.5, 0);
		this.text.x = 1184;
		this.text.y = 860-50;
		
		this.start_small = Asset.getImage("button_board_small.png", false);
		this.start_small.anchor.set(0.5, 0);
		this.start_small.x = 764;
		this.start_small.y = 1324-25;
		this.start_small.interactive = true;
		
		this.start_medium = Asset.getImage("button_board_medium.png", false);
		this.start_medium.anchor.set(0.5, 0);
		this.start_medium.x = 1024;
		this.start_medium.y = 1324-25;
		this.start_medium.interactive = true;
		
		this.start_big = Asset.getImage("button_board_big.png", false);
		this.start_big.anchor.set(0.5, 0);
		this.start_big.x = 1284;
		this.start_big.y = 1324-25;
		this.start_big.interactive = true;
		
		this.bg_boardselection = Asset.getImage("bg_boardselection.png", false);
		this.bg_boardselection.anchor.set(0.5, 0);
		this.bg_boardselection.x = 1024;
		this.bg_boardselection.y = 1224;
		this.bg_boardselection.interactive = true;
		
		this.bg = Asset.getImage("bg.png", false);
		this.bg.anchor.set(0, 0.15);
		this.bg_sky = Asset.getImage("bg_sky.png", false);
		this.bg_no_sky = Asset.getImage("bg_no_sky.png", false);
		
		this.addChild(this.bg);
		//this.addChild(this.bg_sky);
		//this.addChild(this.bg_no_sky);
		
		this.addChild(this.logo);
		this.addChild(this.swipe);
		this.addChild(this.match);
		this.addChild(this.text);
		this.addChild(this.bg_boardselection);
		this.addChild(this.start_small);
		this.addChild(this.start_medium);
		this.addChild(this.start_big);
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
	
	private var minRectGame:Rectangle = new Rectangle(272, 170, 1528, 1352);
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