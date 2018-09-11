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
	public static var GRID_WIDTH:Int = 6;
	public static var GRID_HEIGHT:Int = 6;
	
	public static var MAX_VALUE:Int = 4;
	
	public static var RANDOM_SPAWN_AMOUNT:Range= {min: 1, max:3};
	
	public var grid:Array<Array<Node>>;
	public var nodes:Array<Node>;
	
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
			for ( j in 1...GRID_WIDTH)
			{
				var x:Int = j;
				var n:Node = grid[x][y];
				if (n.value == -1)
				{
					for (i in 0...j)
					{
						var xn:Int = j - i - 1;
						swap(n, grid[xn][y]);
					}
				}
			}
		}
	}
	
	private function bubbleLeft():Void
	{
		for ( y in 0...GRID_HEIGHT)
		{
			//Bubble sort the line
			for ( j in 1...GRID_WIDTH)
			{
				var x:Int = GRID_WIDTH - j -1;
				var n:Node = grid[x][y];
				if (n.value == -1)
				{
					for (i in x+1...GRID_WIDTH)
					{
						swap(n, grid[i][y]);
					}
				}
			}
		}
	}
	
	private function bubbleDown():Void
	{
		for ( x in 0...GRID_WIDTH)
		{
			//Bubble sort the line
			for ( j in 1...GRID_HEIGHT)
			{
				var y:Int = j;
				var n:Node = grid[x][y];
				if (n.value == -1)
				{
					for (i in 0...j)
					{
						var yn:Int = j - i - 1;
						swap(n, grid[x][yn]);
					}
				}
			}
		}
	}
	
	private function bubbleUp():Void
	{
		for ( x in 0...GRID_WIDTH)
		{
			//Bubble sort the line
			for ( j in 1...GRID_HEIGHT)
			{
				var y:Int = GRID_HEIGHT - j -1;
				var n:Node = grid[x][y];
				if (n.value == -1)
				{
					for (i in y+1...GRID_HEIGHT)
					{
						swap(n, grid[x][i]);
					}
				}
			}
		}
	}
	
	private function swap(n1:Node, n2:Node):Void
	{
		var n1x:Int = n1.x;
		var n1y:Int = n1.y;
		var n2x:Int = n2.x;
		var n2y:Int = n2.y;
		
		grid[n1x][n1y] = n2;
		grid[n2x][n2y] = n1;
		
		n1.x = n2x;
		n1.y = n2y;
		
		n2.x = n1x;
		n2.y = n1y;
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
		
		var removed:Array<Node> = [];
		for (n in nodes)
		{
			var match:Array<Node> = testSquareMatch(n);
			if (match != null)
			{
				for (rn in match)
				{
					if (removed.indexOf(rn) == -1) removed.push(rn);
				}
			}
		}
		
		//Make sure each is counted only once & populate removed.
		
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
	
	private function testSquareMatch(node:Node):Array<Node>
	{
		//Trivial ignores.
		if (node.value == -1) return null;
		if (node.x >= GRID_WIDTH - 2) return null;
		if (node.y >= GRID_HEIGHT - 2) return null;
		
		var ret:Array<Node> = [];
		if(grid[node.x + 1][node.y + 1].value == node.value &&
		       grid[node.x ][node.y + 1].value == node.value &&
			   grid[node.x + 1][node.y ].value == node.value)
	   {
		   ret.push(node);
		   ret.push( grid[node.x + 1][node.y + 1]);
		   ret.push( grid[node.x ][node.y + 1]);
		   ret.push( grid[node.x + 1][node.y ]);
	   }
	   return ret;
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