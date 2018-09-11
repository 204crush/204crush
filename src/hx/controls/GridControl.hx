package controls;

import js.Browser;
import js.html.EventTarget;
import js.html.KeyboardEvent;
import js.html.TouchEvent;
import logic.GridLogic;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.interaction.InteractionData;
import pixi.plugins.spine.core.EventData;
import util.MathUtil;

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
	
	private var swipeStart:Point = new Point(0.0, 0.0);
	private var swipeStop:Point = new Point(0.0, 0.0);
	private var swipeDirection:Point = new Point(0.0, 0.0);
	
	public function new() 
	{
		super();
		this.logic = new GridLogic();
		this.logic.spawnRandom();
		this.logic.printGrid();
		this.initializeControls();
		
		Browser.window.addEventListener("keydown", keyDown);
		Browser.window.addEventListener("touchstart", function(eventData:TouchEvent) 
		{
			// Set start point for touch
			swipeStart.set(eventData.touches[0].clientX, eventData.touches[0].clientY);
		});
		
		Browser.window.addEventListener("touchmove", function(eventData:TouchEvent) 
		{
			// Set stop point for touch
			swipeStop.set(eventData.touches[0].clientX, eventData.touches[0].clientY);
		});
		
		Browser.window.addEventListener("touchend", function() 
		{
			// Calculate length of the different axis
			var diffX:Float = Math.abs(swipeStart.x - swipeStop.x);
			var diffY:Float = Math.abs(swipeStart.y - swipeStop.y);
			
			if (diffX > diffY ) 
			{
				// Set move in X-Axis
				swipeDirection.set(swipeStart.x > swipeStop.x ? -1 : 1, 0);
			} else
			{
				// Set move in Y-Axis
				swipeDirection.set(0, swipeStart.y > swipeStop.y ? -1 : 1);
			}
			
			//Fire KeyDown logic
			//keyDown;
		});
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
				this.blocks.push(b);
				this.blockContainer.addChild(b);
			}
		}
		
		this.addChild(this.blockContainer);
		
		this.syncNodes();
	}
	
	private function syncNodes():Void
	{
		for ( n in logic.nodes)
		{
			var b:Block = grid[n.x][n.y];
			b.setType(n.value);
		}
	}
	
	private function keyDown(event:KeyboardEvent):Void
	{
		var direction:Direction = null;
		if (event.keyCode == 38 || swipeDirection.y < 0) //up
		{
			direction = Direction.up;
		}
		else if (event.keyCode == 37 || swipeDirection.x < 0)//left
		{
			direction = Direction.left;
		}
		else if (event.keyCode == 40 || swipeDirection.y > 0)//down
		{
			direction = Direction.down;
		}
		else if (event.keyCode == 39 || swipeDirection.x > 0)//right
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
			this.syncNodes();
			moves++;
			trace(moves);
		}
		
		// Reset swipe direction logic
		swipeStart.set(0, 0);
		swipeStop.set(0, 0);
		swipeDirection.set(0, 0);
	}
}