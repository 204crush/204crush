package controls;

import pixi.core.sprites.Sprite;
import haxe.Timer;
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
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class GridControl extends Container 
{
	public static var ON_BLOCK_REMOVE:String = "onBlockRemove";
	
	public static var SPACING:Int = 0;
	public static var BLOCK_HEIGHT:Int = 130;
	public static var BLOCK_WIDTH:Int = 130;
	public static var DEAD_ZONE:Int = 50;
	
	private var logic:GridLogic;
	
	private var grid:Array<Array<Block>>;
	private var blocks:Array<Block>;
	
	private var blockContainer:Container;
	
	private var moves:Int = 0;
	
	private var swipeStart:Point = new Point(0.0, 0.0);
	private var swipeStop:Point = new Point(0.0, 0.0);
	private var swipeDirection:Point = new Point(0.0, 0.0);

	public var enabled:Bool = false;
	
	private var lastRemoved:Array<Node>;
	private var lastLines:Array<Line>;
	private var lastSwipeDirection:Direction;
	private var chains:Int = 0;
	
	public function new() 
	{
		super();
		
		BLOCK_HEIGHT =Math.floor( 130 * 6 / GridLogic.GRID_HEIGHT);
		BLOCK_WIDTH =Math.floor( 130 * 6 / GridLogic.GRID_HEIGHT);
		
		this.initializeControls();
		
		Browser.window.addEventListener("keydown", keyDown);
		Browser.window.document.addEventListener("touchstart", touchDown);
		Browser.window.document.addEventListener("touchmove", touchUpdate);
		Browser.window.document.addEventListener("touchend", touchUp);
		
		
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
				//b.node = logic.grid[x][y];
				this.blocks.push(b);
				this.blockContainer.addChild(b);
			}
		}
		
		this.addChild(this.blockContainer);
		
		
		enabled = true;
	}
	
	public function prepare():Void
	{
		this.logic = new GridLogic();
		this.logic.spawnRandom();
		this.logic.spawnRandom();
		this.logic.spawnRandom();
		this.logic.printGrid();
		
		BLOCK_HEIGHT = Math.floor(6/GridLogic.GRID_HEIGHT * 130);
		BLOCK_WIDTH = Math.floor(6/GridLogic.GRID_WIDTH * 130);
		
		for ( x in 0...GridLogic.GRID_WIDTH)
		{
			for ( y in 0...GridLogic.GRID_HEIGHT)
			{
				var b:Block = grid[x][y];
				b.node = logic.grid[x][y];
			}
		}
		
		this.enabled = false;
		this.syncNodes(false);
	}
	
	private function syncNodes(middleStep:Bool):Void
	{
		for ( b in blocks)
		{
			b.sync(middleStep);
		}
		if (lastLines != null)
		{
			for (line in lastLines)
			{
				//Simple cases
				if (line.nodes.length == 5)
				{
					//Calculate center point.
					logic.applyLineClear( line.nodes[2].x, line.nodes[2].y, Orientation.vertical);
					logic.applyLineClear( line.nodes[2].x, line.nodes[2].y, Orientation.horizontal);
					trace("CLEAR 5");
				}
				else if (line.nodes.length == 4)
				{
					logic.applyLineClear( line.nodes[0].x, line.nodes[0].y, line.orientation);
					trace("CLEAR 4");
				}
				
				//Check if L or X is formed.
				for ( line2 in lastLines)
				{
					
				}
			}
		}
	}
	
	private function touchDown(eventData:TouchEvent) 
	{
		// Set start point for touch
		swipeStart.set(eventData.touches[0].pageX, eventData.touches[0].pageY);
	}
	
	private function touchUpdate(eventData:TouchEvent) 
	{
		// Set stop point for touch
		swipeStop.set(eventData.touches[0].pageX, eventData.touches[0].pageY);
		
	}
	
	private function touchUp(eventData:TouchEvent) 
	{
		// Calculate length of the different axis
		var diffX:Float = Math.abs(swipeStart.x - swipeStop.x);
		var diffY:Float = Math.abs(swipeStart.y - swipeStop.y);
		
		if ((diffX < DEAD_ZONE && diffY < DEAD_ZONE) || (diffX > DEAD_ZONE && diffY > DEAD_ZONE))
		{
			return;
		}
		
		if (diffX > diffY ) 
		{
			// Set move in X-Axis
			swipeStart.x > swipeStop.x ? doSwipe(Direction.left) : doSwipe(Direction.right);
			
		} else if ( diffX < diffY)
		{
			// Set move in Y-Axis
			swipeStart.y > swipeStop.y ? doSwipe(Direction.up) : doSwipe(Direction.down);
		}
		swipeStart.set(0, 0);
		swipeStop.set(0, 0);
		swipeDirection.set(0, 0);
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
		if (direction != null && enabled )
		{
			chains = 0;
			enabled = false;
			this.lastSwipeDirection = direction;
			this.logic.swipe(direction);
			this.syncNodes(false);
			lastLines = [];
			lastRemoved = this.logic.remove(lastLines);
			Timer.delay(nextStep, 550);
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
		
		// Reset swipe direction logic
	}
	
	private function nextStep():Void
	{
		if ( lastRemoved.length > 0)
		{
			chains++;
			if(chains > 1)
				PraiseManager.showMessage("Blooooooddd... " + chains + "X!",400);

			this.logic.clearRemoved(lastRemoved);
			this.logic.swipe(lastSwipeDirection);
			this.syncNodes(true);
			var removed:Int = lastRemoved.length;
			lastLines = [];
			lastRemoved = this.logic.remove(lastLines);
			if (lastRemoved.length == 0) enabled = true;
			Timer.delay(nextStep, 600);
			this.emit(ON_BLOCK_REMOVE, removed*15);
		}
		else
		{
			this.logic.spawnRandom();
			this.syncNodes(false);
			this.enabled = true;
			
			if (this.logic.isFinished())
			{
				PraiseManager.showMessage("GAME OVER :(", 500);
			}
		}
	}
}