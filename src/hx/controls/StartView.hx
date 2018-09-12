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
	private var logo:Sprite;
	public var start:Sprite;
	
	private var origsize:Rectangle;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.logo = Asset.getImage("logo.png", true);
		this.start = Asset.getImage("start_button.png", true);
		
		this.bg = Asset.getImage("bg.jpg", false);
		
		this.start.y = 720;
		this.start.x = 110;
		this.start.interactive = true;
		
		
		this.addChild(this.bg);
//		this.addChild(this.logo);
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