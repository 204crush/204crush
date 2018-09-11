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
		this.sprite = Asset.getImage("block1/block.png", true);
		this.sprite.anchor.x = this.sprite.anchor.y = 0.5;
		this.addChild(this.sprite);
	}
	
}