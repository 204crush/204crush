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
	
	private var origsize:Rectangle;
	
	public function new() 
	{
		super();
		this.initializeControls();
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
		this.swipe.y = 580;
		
		this.match = Asset.getImage("tutorial_match.png", false);
		this.match.anchor.set(0.5, 0);
		this.match.x = 760;
		this.match.y = 900;
		
		this.text = Asset.getImage("text_tutorial.png", false);
		this.text.anchor.set(0.5, 0);
		this.text.x = 1184;
		this.text.y = 760;
		
		this.start_small = Asset.getImage("button_board_small.png", false);
		this.start_small.anchor.set(0.5, 0);
		this.start_small.x = 774;
		this.start_small.y = 1224;
		this.start_small.interactive = true;
		
		this.start_medium = Asset.getImage("button_board_medium.png", false);
		this.start_medium.anchor.set(0.5, 0);
		this.start_medium.x = 1024;
		this.start_medium.y = 1224;
		this.start_medium.interactive = true;
		
		this.start_big = Asset.getImage("button_board_big.png", false);
		this.start_big.anchor.set(0.5, 0);
		this.start_big.x = 1274;
		this.start_big.y = 1224;
		this.start_big.interactive = true;
		
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
		this.addChild(this.start_small);
		this.addChild(this.start_medium);
		this.addChild(this.start_big);
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