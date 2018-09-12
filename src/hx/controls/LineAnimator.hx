package controls;

import createjs.tweenjs.Tween;
import pixi.core.Pixi;
import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class LineAnimator extends Container 
{
	private var vertical1:Sprite;
	private var vertical2:Sprite;
	
	private var horizontal1:Sprite;
	private var horizontal2:Sprite;
	

	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		this.vertical1 = Asset.getImage("whitefadestrip_ragged.png", true);
		this.vertical2 = Asset.getImage("whitefadestrip_ragged.png", true);
		
		this.horizontal1 = Asset.getImage("whitefadestrip_ragged.png", true);
		this.horizontal2 = Asset.getImage("whitefadestrip_ragged.png", true);
		
	//	this.vertical1.blendMode = this.vertical2.blendMode = this.horizontal1.blendMode = this.horizontal2.blendMode = Pixi.BLEND_MODES.ADD;
		
///////		this.addChild(this.vertical1);
	//	this.addChild(this.vertical2);
		
		this.addChild(this.horizontal1);
		this.addChild(this.horizontal2);
		
		horizontal1.anchor.y = horizontal2.anchor.y = 0.5;
		horizontal2.scale.y = -1;
		
		horizontal2.alpha = 1;
		horizontal1.alpha = 1;
		Tween.get(horizontal2, {loop:true}).to({alpha:0.5}, 150).to({alpha:1}, 150);
		Tween.get(horizontal1, {loop:true}).to({alpha:0.7}, 250).to({alpha:1}, 250);
		
		this.vertical1.anchor.x = 0.5;
		this.vertical2.anchor.x = 0.5;
		
		this.vertical1.anchor.y = this.vertical2.anchor.y = 1;
	}
	
	public function animateVertical(b:Block):Void
	{
		
	}
	
	public function animateHorizontal(b:Block):Void
	{
		
	}
	
}