package logic;
import js.html.IterationCompositeOperation;

enum Direction
{
	left;
	right;
	up;
	down;
}

enum Orientation
{
	horizontal;
	vertical;
}

/**
 * ...
 * @author Henri Sarasvirta
 */
class GridLogic 
{
	public static var GRID_WIDTH:Int = 5;
	public static var GRID_HEIGHT:Int = 5;
	
	public static var MAX_VALUE:Int = 4;
	
	public static var RANDOM_SPAWN_AMOUNT:Range= {min: 1, max:3};
	
	private var grid:Array<Array<Node>>;
	private var nodes:Array<Node>;
	
	public function new() 
	{
		grid = [];
		nodes = [];
		for (i in 0...GRID_WIDTH)
		{
			grid[i] = [];
			for (j in 0...GRID_HEIGHT)
			{
				var n:Node = {
					value: -1,
					x: i,
					y: j
				};
				grid[i][j] = n;
				nodes.push(n);
			}
		}
	}
	
	/**
	 * Spawn next values.
	 */
	public function spawnRandom():Void
	{
		var possible:Array<Node> = this.nodes.filter(function(n:Node):Bool{return n.value == -1; });
		
		var amount:Int = Math.floor(
			Math.min( 
				possible.length,
				Math.random() * (RANDOM_SPAWN_AMOUNT.max - RANDOM_SPAWN_AMOUNT.min) + RANDOM_SPAWN_AMOUNT.min
			));
		for (i in 0...amount)
		{
			var rnd:Int = Math.floor(Math.random() * possible.length);
			var n:Node = possible[rnd];
			possible.remove(n);
			randomizeValue(n);
		}
	}
	
	private function randomizeValue(node:Node):Void
	{
		if (node.value != -1) throw "Randomizing node with existing value.";
		node.value = Math.floor(Math.random() * MAX_VALUE);
	}
	
	/**
	 * Swipes to given direction.
	 * This should be called after each remove and when user does an action.
	 * @param	direction
	 */
	public function swipe(direction:Direction):Void
	{
		if (direction == Direction.right)
			bubbleRight();
		else if (direction == Direction.left)
			bubbleLeft();
		else if (direction == Direction.down)
			bubbleDown();
		else if (direction == Direction.up)
			bubbleUp();
		
		
	}
	
	private function bubbleRight():Void
	{
		for ( y in 0...GRID_HEIGHT)
		{
			//Bubble sort the line
			for ( j in 0...GRID_WIDTH)
			{
				var x:Int = GRID_WIDTH - j - 1;
				var n:Node = grid[x][y];
				var xn:Int = x;
				while (n.value == -1)
				{
					//Bubble
					xn--;
					if (xn < 0) break;
					else swap(n, grid[xn][y]);
				}
			}
		}
	}
	
	private function bubbleLeft():Void
	{
		for ( y in 0...GRID_HEIGHT)
		{
			//Bubble sort the line
			for ( x in 0...GRID_WIDTH)
			{
				var n:Node = grid[x][y];
				var xn:Int = x;
				while (n.value == -1)
				{
					//Bubble
					xn++;
					if (xn >= GRID_WIDTH) break;
					else swap(n, grid[xn][y]);
				}
			}
		}
	}
	
	private function bubbleUp():Void
	{
		for ( x in 0...GRID_WIDTH)
		{
			//Bubble sort the line
			for ( y in 0...GRID_HEIGHT)
			{
				var n:Node = grid[x][y];
				var yn:Int = y;
				while (n.value == -1)
				{
					//Bubble
					yn++;
					if (yn >= GRID_HEIGHT) break;
					else swap(n, grid[x][yn]);
				}
			}
		}
	}
	
	private function bubbleDown():Void
	{
		for ( x in 0...GRID_WIDTH)
		{
			//Bubble sort the line
			for ( j in 0...GRID_HEIGHT)
			{
				var y:Int = GRID_HEIGHT - j - 1;
				var n:Node = grid[x][y];
				var yn:Int = y;
				while (n.value == -1)
				{
					//Bubble
					yn--;
					if (yn < 0) break;
					else swap(n, grid[x][yn]);
				}
			}
		}
	}
	
	private function swap(n1:Node, n2:Node):Void
	{
		var t:Int = n1.value;
		n1.value = n2.value;
		n2.value = t;
	}
	
	
	/**
	 * Removes found groups.
	 * @return
	 */
	public function remove():Array<Node>
	{
		var found:Array<Line> = [];
		//Find out the lines.
		for (i in 0...GRID_WIDTH)
		{
			sweepTestVertical(found, i);
		}
		for (i in 0...GRID_HEIGHT)
		{
			sweepTestHorizontal(found, i);
		}
		
		//Make sure each is counted only once & populate removed.
		var removed:Array<Node> = [];
		for ( line in found)
		{
			for (n in line.nodes)
			{
				if (removed.indexOf(n) == -1) removed.push(n);
			}
		}
		if (removed.length > 0)
			trace("REMVOED: " + removed.length);
		return removed;
	}
	
	public function clearRemoved(removed:Array<Node>):Void
	{
		for (n in removed)
		{
			n.value = -1;
		}
	}
	
	private function sweepTestHorizontal(found:Array<Line>, y:Int):Void
	{
		var current:Array<Node> = [ grid[0][y] ];
		for ( i in 1...GRID_WIDTH)
		{
			var cmp:Node = grid[i][y];
			if (cmp.value == current[0].value && cmp.value >= 0)
			{
				current.push(cmp);
			}
			else
			{
				if (current.length >= 3)
					found.push( { orientation: Orientation.horizontal, nodes: current});
				current = [cmp];
			}
		}
		if (current.length >= 3)
			found.push( { orientation: Orientation.horizontal, nodes: current});
	}
	
	private function sweepTestVertical(found:Array<Line>, x:Int):Void
	{
		var current:Array<Node> = [ grid[x][0] ];
		for ( i in 1...GRID_HEIGHT)
		{
			var cmp:Node = grid[x][i];
			if (cmp.value == current[0].value && cmp.value >= 0)
			{
				current.push(cmp);
			}
			else
			{
				if (current.length >= 3)
					found.push( { orientation: Orientation.vertical, nodes: current});
				current = [cmp];
			}
		}
		if (current.length >= 3)
			found.push( { orientation: Orientation.vertical, nodes: current});
	}
	
	/**
	 * Is the game finished. 
	 * @return True if all the nodes are full.
	 */
	public function isFinished():Bool
	{
		var allFilled:Bool = true;
		for (n in nodes)
		{
			if (n.value == -1)
			{
				allFilled = false;
				break;
			}
		}
		return allFilled;
	}
	
	/**
	 * Debug functions
	 */
	
	public function printGrid()
	{
		var s:String = "finished: " + isFinished() +"\n";
		for (y in 0...GRID_HEIGHT)
		{
			for (x in 0...GRID_WIDTH)
			{
				var n:Node = grid[x][y];
				s += n.value >= 0 ? Std.string(n.value) : " ";
			}
			s += "\n";
		}
		trace(s);
	}
}

typedef Line = {
	public var nodes:Array<Node>;
	public var orientation:Orientation;
}


typedef Node = 
{
	public var value:Int;
	public var x:Int;
	public var y:Int;
	
}

typedef Range = {
	public var min:Int;
	public var max:Int;
}