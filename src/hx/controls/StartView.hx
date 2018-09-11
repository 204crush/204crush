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
		
		this.start.y = 720;
		this.start.x = 110;
		this.start.interactive = true;
		
		this.addChild(this.logo);
		this.logo.addChild(this.start);
		
		
	}
	
	
	public function resize(size:Rectangle)
	{
		
	}
	
}