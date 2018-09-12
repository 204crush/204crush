package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import logic.GridLogic;
import logic.GridLogic.Node;
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
	private var sprites:Array<Sprite> = [];
	private var curind:Int = 0;

	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		for ( i in 0...100)
		{
			var s:Sprite = Asset.getImage("gfx_whitestar.png", true);
			this.addChild(s);
			sprites.push(s);
			s.anchor.x = s.anchor.y = 0.5;
		//	s.blendMode = Pixi.BLEND_MODES.ADD;
			s.width = s.height = GridControl.BLOCK_HEIGHT - 10 * 6 / GridLogic.GRID_HEIGHT;
			s.visible = false;
		}
	}
	
	public function animateVertical(node:Node, line:Line):Void
	{
		for (i in 0...GridLogic.GRID_HEIGHT)
		{
			var tx:Float = node.x * GridControl.BLOCK_WIDTH + Math.max(0, node.x - 1) * GridControl.SPACING + GridControl.BLOCK_WIDTH / 2;
			var ty:Float = i * GridControl.BLOCK_HEIGHT + Math.max(0, node.y - 1) * GridControl.SPACING + GridControl.BLOCK_HEIGHT / 2;
			var s:Sprite = sprites[curind%sprites.length];
			curind++;
			s.visible = true;
			if(line.value != -1)
				s.tint = [0x0000ff, 0x00ff00, 0xffff00, 0x9e7cca][line.value];
			s.x = tx;
			s.y = ty;
			s.alpha = 0;
			s.scale.x = s.scale.y = 1;
			s.rotation = Math.random() * Math.PI * 5;
			var dist:Int =Math.floor( 10 + Math.abs(i - node.y)*80);
			Tween.get(s.scale).wait(dist).to({x:2.0, y:2.0}, 650, Ease.quadOut);
			Tween.get(s).wait(dist).to({alpha:1, rotation:Math.PI + s.rotation}, 150, Ease.quadOut).to({alpha:0}, 500, Ease.quadOut);
		}
	}
	
	public function animateHorizontal(node:Node, line:Line):Void
	{
		for (i in 0...GridLogic.GRID_WIDTH)
		{
			var tx:Float = i * GridControl.BLOCK_WIDTH + Math.max(0, node.x - 1) * GridControl.SPACING + GridControl.BLOCK_WIDTH / 2;
			var ty:Float = node.y * GridControl.BLOCK_HEIGHT + Math.max(0, node.y - 1) * GridControl.SPACING + GridControl.BLOCK_HEIGHT / 2;
			var s:Sprite = sprites[curind%sprites.length];
			curind++;
			s.visible = true;
			if(line.value != -1)
				s.tint = [0x0000ff, 0x00ff00, 0xffff00, 0xffffff][line.value];
			s.x = tx;
			s.y = ty;
			s.alpha = 0;
			s.scale.x = s.scale.y = 1;
			s.rotation = Math.random() * Math.PI * 5;
			var dist:Int =Math.floor( 10 + Math.abs(i - node.y)*80);
			Tween.get(s.scale).wait(dist).to({x:2.0, y:2.0}, 650, Ease.quadOut);
			Tween.get(s).wait(dist).to({alpha:1, rotation:Math.PI + s.rotation}, 150, Ease.quadOut).to({alpha:0}, 500, Ease.quadOut);
		}
	}
	
	public function animateNodes(nodes:Array<Node>, line:Line):Void
	{
		for (node in nodes)
		{
			var tx:Float = node.x * GridControl.BLOCK_WIDTH + Math.max(0, node.x - 1) * GridControl.SPACING + GridControl.BLOCK_WIDTH / 2;
			var ty:Float = node.y * GridControl.BLOCK_HEIGHT + Math.max(0, node.y - 1) * GridControl.SPACING + GridControl.BLOCK_HEIGHT / 2;
			var s:Sprite = sprites[curind%sprites.length];
			curind++;
			s.visible = true;
			if(line.value != -1)
				s.tint = [0x0000ff, 0x00ff00, 0xffff00, 0xffffff][line.value];
			s.x = tx;
			s.y = ty;
			s.alpha = 0;
			s.scale.x = s.scale.y = 1;
			s.rotation = Math.random() * Math.PI * 5;
			var dist:Int =Math.floor( 10 + Math.random()*250);
			Tween.get(s.scale).wait(dist).to({x:2.0, y:2.0}, 650, Ease.quadOut);
			Tween.get(s).wait(dist).to({alpha:1, rotation:Math.PI + s.rotation}, 150, Ease.quadOut).to({alpha:0}, 500, Ease.quadOut);
		}
	}
	
}