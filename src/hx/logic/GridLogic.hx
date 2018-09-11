package logic;

enum Direction
{
	left;
	right;
	up;
	down;
}

/**
 * ...
 * @author Henri Sarasvirta
 */
class GridLogic 
{
	public static var GRID_WIDTH:Int = 5;
	public static var GRID_HEIGHT:Int = 5;
	
	public static var MAX_VALUE:Int = 6;
	
	public static var RANDOM_SPAWN_AMOUNT:Range;
	public static var 
	
	private var grid:Array<Array<Node>>;
	
	
	public function new() 
	{
		
	}
	
	public function swipe(direction:Direction):Void
	{
		
	}
	
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