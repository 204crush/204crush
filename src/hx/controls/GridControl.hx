package controls;

import js.Browser;
import js.html.KeyboardEvent;
import logic.GridLogic;
import pixi.core.display.Container;

/**
 * ...
 * @author Henri Sarasvirta
 */
class GridControl extends Container 
{
	public static var SPACING:Int = 2;
	public static var BLOCK_HEIGHT:Int = 100;
	public static var BLOCK_WIDTH:Int = 100;
	
	private var logic:GridLogic;
	
	private var grid:Array<Array<Block>>;
	private var blocks:Array<Block>;
	
	private var blockContainer:Container;
	
	
	public function new() 
	{
		super();
		this.logic = new GridLogic();
		this.logic.spawnRandom();
		this.logic.printGrid();
		this.initializeControls();
		
		Browser.window.addEventListener("keydown", keyDown);
	}
	
	private function initializeControls():Void
	{
		this.blockContainer = new Container();
		
		for ( x in 0...GridLogic.GRID_WIDTH)
		{
			for ( y in 0...GridLogic.GRID_HEIGHT)
			{
				var b:Block = new Block();
				b.x = x * BLOCK_WIDTH + Math.max(0, (x - 1)) * SPACING + BLOCK_WIDTH / 2;
				b.y = y * BLOCK_HEIGHT + Math.max(0, (y - 1)) * SPACING + BLOCK_HEIGHT / 2;
				
				this.blockContainer.addChild(b);
			}
		}
		
		this.addChild(this.blockContainer);
	}
	
	private function keyDown(event:KeyboardEvent):Void
	{
		var direction:Direction = null;
		if (event.keyCode == 38) //up
		{
			direction = Direction.up;
		}
		else if (event.keyCode == 37)//left
		{
			direction = Direction.left;
		}
		else if (event.keyCode == 40)//down
		{
			direction = Direction.down;
		}
		else if (event.keyCode == 39)//right
		{
			direction = Direction.right;
		}
		
		if (direction != null)
		{
			this.logic.swipe(direction);
			var removed:Array<Node> = this.logic.remove();
			while (removed.length > 0)
			{
				this.logic.clearRemoved(removed);
				this.logic.swipe(direction);
				removed = this.logic.remove();
			}
			
			//Spawn
			this.logic.spawnRandom();
			
			this.logic.printGrid();
		}
	}
}