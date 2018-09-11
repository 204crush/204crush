package controls;

import haxe.Timer;
import js.Browser;
import js.html.EventTarget;
import js.html.KeyboardEvent;
import logic.GridLogic;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.interaction.InteractionData;
import pixi.plugins.spine.core.EventData;

/**
 * ...
 * @author Henri Sarasvirta
 */
class GridControl extends Container 
{
	public static var SPACING:Int = 0;
	public static var BLOCK_HEIGHT:Int = 130;
	public static var BLOCK_WIDTH:Int = 130;
	
	private var logic:GridLogic;
	
	private var grid:Array<Array<Block>>;
	private var blocks:Array<Block>;
	
	private var blockContainer:Container;
	
	private var moves:Int = 0;
	
	private var enabled:Bool = false;
	
	private var lastRemoved:Array<Node>;
	private var lastSwipeDirection:Direction;
	
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
		this.blocks = [];
		this.grid = [];
		for ( x in 0...GridLogic.GRID_WIDTH)
		{
			this.grid[x] = [];
			for ( y in 0...GridLogic.GRID_HEIGHT)
			{
				var b:Block = new Block();
				b.x = x * BLOCK_WIDTH + Math.max(0, (x - 1)) * SPACING + BLOCK_WIDTH / 2;
				b.y = y * BLOCK_HEIGHT + Math.max(0, (y - 1)) * SPACING + BLOCK_HEIGHT / 2;
				this.grid[x][y] = b;
				b.node = logic.grid[x][y];
				this.blocks.push(b);
				this.blockContainer.addChild(b);
			}
		}
		
		this.addChild(this.blockContainer);
		
		this.syncNodes();
		enabled = true;
	}
	
	private function syncNodes():Void
	{
		for ( b in blocks)
		{
			b.sync();
		}
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
		doSwipe(direction);
	}
	
	private function doSwipe(direction:Direction):Void
	{
		if (direction != null && enabled)
		{
			this.lastSwipeDirection = direction;
			this.logic.swipe(direction);
			this.syncNodes();
			lastRemoved = this.logic.remove();
			Timer.delay(nextStep, 350);
		}
		/*
			while (removed.length > 0)
			{
				this.logic.clearRemoved(removed);
				this.logic.swipe(direction);
				removed = this.logic.remove();
			}
			
			//Spawn
			this.logic.spawnRandom();
			
			this.logic.printGrid();
			this.syncNodes();
			moves++;
			trace(moves);
		}*/
		
	}
	
	private function nextStep():Void
	{
		if ( lastRemoved.length > 0)
		{
			this.logic.clearRemoved(lastRemoved);
			this.logic.swipe(lastSwipeDirection);
			this.syncNodes();
			lastRemoved = this.logic.remove();
			Timer.delay(nextStep, 350);
		}
		else
		{
			this.logic.spawnRandom();
			this.syncNodes();
			this.enabled = true;
		}
	}
}