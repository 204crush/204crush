package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import js.html.SimpleGestureEvent;
import logic.GridLogic;
import logic.GridLogic.Node;
import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
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
	
	private var textures:Array<Texture>;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		textures = [
			Asset.getTexture("blockie_blue.png", true),
			Asset.getTexture("blockie_green.png", true),
			Asset.getTexture("blockie_orange.png", true),
			Asset.getTexture("blockie_purple.png", true),
			//Asset.getTexture("block_blue/blockie_blue.png", true),
		];
		
		this.sprite = Asset.getImage("temp.png", true);
		this.sprite.anchor.x = this.sprite.anchor.y = 0.5;
		this.sprite.x = -6;
		this.sprite.y = -6;
		this.scale.x = this.scale.y = 0;
		
		//TEMP SCALE
		sprite.width = sprite.height = GridControl.BLOCK_HEIGHT-10*6/GridLogic.GRID_HEIGHT;
		this.addChild(this.sprite);
		
		this.interactive = true;
		this.addListener("click", onAnnoyClick);
	}
	private function onAnnoyClick():Void
	{
		var os:Float = this.sprite.scale.x;
	//	Tween.get(this.sprite.scale).to({x: os * 1.25}, 390, Ease.quadInOut).to({x:os}, 40, Ease.quadInOut);
	//	Tween.get(this.sprite.scale).to({y: os * 1.25}, 450, Ease.quadInOut).to({y:os}, 80, Ease.quadInOut);
	}
	
	public function sync(middleStep:Bool)
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
			this.sprite.texture = textures[value];
			//New spawn
			this.active = true;
			this.x = node.x * GridControl.BLOCK_WIDTH + Math.max(0, node.x-1)*GridControl.SPACING + GridControl.BLOCK_WIDTH/2;
			this.y = node.y * GridControl.BLOCK_HEIGHT + Math.max(0, node.y - 1) * GridControl.SPACING + GridControl.BLOCK_HEIGHT / 2;
			Tween.removeTweens(this.scale);
			Tween.get(this.scale).to({x:1, y:1}, 250, Ease.getBackOut(0.35));
		}
		else if(active)
		{
			this.sprite.texture = textures[value];
			//Move
			Tween.removeTweens(this);
			Tween.get(this).wait(middleStep?250:10).to({
				x:node.x * GridControl.BLOCK_WIDTH + Math.max(0, node.x-1)*GridControl.SPACING + GridControl.BLOCK_WIDTH/2,
				y:node.y * GridControl.BLOCK_HEIGHT + Math.max(0, node.y - 1) * GridControl.SPACING + GridControl.BLOCK_HEIGHT / 2
			}, 300, Ease.bounceOut);
		}
		
	}
}