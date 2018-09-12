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
	public var start:Sprite;
	
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
		
		this.start = Asset.getImage("button_start.png", false);
		this.start.anchor.set(0.5, 0);
		this.start.x = 1024;
		this.start.y = 1224;
		this.start.interactive = true;
		
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
		this.addChild(this.start);
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