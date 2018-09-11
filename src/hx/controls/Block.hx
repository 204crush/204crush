package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import js.html.SimpleGestureEvent;
import logic.GridLogic.Node;
import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Block extends Container 
{
	public var node:Node;
	private var sprite:Sprite;

	private var active:Bool = false;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.sprite = Asset.getImage("temp.png", true);
		this.sprite.anchor.x = this.sprite.anchor.y = 0.5;
		this.scale.x = this.scale.y = 0;
		//TEMP SCALE
		sprite.width = sprite.height = 120;
		this.addChild(this.sprite);
	}
	
	public function sync()
	{
		var value:Int = node.value;
		if (active && node.value == -1)
		{
			//Destroyed. Sleep.
			this.active = false;
			Tween.removeTweens(this.scale);
			Tween.get(this.scale).to({x:0, y:0}, 250, Ease.quadIn);
		}
		else if (!active && node.value >= 0)
		{
			this.sprite.tint = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0xff00ff, 0x00ffff, 0x0, 0xffffff][value];
			//New spawn
			this.active = true;
			this.x = node.x * GridControl.BLOCK_WIDTH + Math.max(0, node.x-1)*GridControl.SPACING + GridControl.BLOCK_WIDTH/2;
			this.y = node.y * GridControl.BLOCK_HEIGHT + Math.max(0, node.y - 1) * GridControl.SPACING + GridControl.BLOCK_HEIGHT / 2;
			Tween.removeTweens(this.scale);
			Tween.get(this.scale).to({x:1, y:1}, 250, Ease.getBackOut(0.35));
		}
		else if(active)
		{
			this.sprite.tint = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0xff00ff, 0x00ffff, 0x0, 0xffffff][value];
			//Move
			Tween.removeTweens(this);
			Tween.get(this).to({
				x:node.x * GridControl.BLOCK_WIDTH + Math.max(0, node.x-1)*GridControl.SPACING + GridControl.BLOCK_WIDTH/2,
				y:node.y * GridControl.BLOCK_HEIGHT + Math.max(0, node.y - 1) * GridControl.SPACING + GridControl.BLOCK_HEIGHT / 2
			}, 300, Ease.bounceOut);
		}
		
	}
}