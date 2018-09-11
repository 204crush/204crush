package controls;

import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Block extends Container 
{
	private var sprite:Sprite;

	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.sprite = Asset.getImage("temp.png", true);
		this.sprite.anchor.x = this.sprite.anchor.y = 0.5;
		
		//TEMP SCALE
		sprite.width = sprite.height = 120;
		this.addChild(this.sprite);
	}
	
	public function setType(value:Int)
	{
		if (value == -1)
			this.sprite.visible = false;
		else
		{
			this.sprite.visible = true;
			this.sprite.tint = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0xff00ff, 0x00ffff, 0x0, 0xffffff][value];
		}
	}
	
}