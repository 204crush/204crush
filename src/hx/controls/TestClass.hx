package controls;

import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pixi.filters.displacement.DisplacementFilter;
import pixi.interaction.InteractionData;
import util.Asset;

/**
 * ...
 * @author ...
 */
class TestClass extends Container 
{

	private var bg:Sprite;
	private var displacementSprite:Sprite;
	private var displacementFilter:DisplacementFilter;
	
	public function new() 
	{
		super();
		this.interactive = true;
		this.on("mousemove", onPointerMove);
		this.on("touchmove", onPointerMove);
		
		this.bg = Asset.getImage("bg.jpg", false);
		this.addChild(this.bg);
		
		this.displacementSprite = Asset.getImage('displace.png', false);
		this.displacementFilter = new DisplacementFilter(displacementSprite);
		this.addChild(displacementSprite);

		this.filters = [displacementFilter];
		
		displacementSprite.anchor.set(0.5);	
	}

	function onPointerMove(eventData)
	{
		displacementSprite.position.copy(eventData.data.getLocalPosition(this, eventData.data.global));
		
	}
	
	public function start():Void
	{
		
	}
}