package util;
import pixi.core.math.Point;

/**
 * ...
 * @author 
 */
class PolygonSplitter 
{
	
	public function new() 
	{
		
	}
	
	public static function getLineSide(line:Line, point:Point):Int
	{
		var d:Float = (point.x - line.p1.x) * (line.p2.y - line.p1.y) - (point.y - line.p1.y) * (line.p2.x - line.p1.x);
		return (d > 0.1 ? 1 : (d < -0.1 ? -1 : 0));
	}
	
	public static function pointDistance(p1:Point, p2:Point):Float
	{
		var dx:Float = p1.x - p2.x;
		var dy:Float = p1.y - p2.y;
		return Math.sqrt(dx * dx +dy * dy);
	}
	
	public static function lineDistance(line:Line, p:Point):Float
	{
		return (p.x-line.p1.x)*(line.p2.x-line.p1.x)+(p.y-line.p1.y)*(line.p2.y-line.p1.y);
	}
	
	public static function splitPolygon(poly:Array<Point>, line:Line, intercepts:Array<Point>):Array<Array<Point>>
	{
		var left:Array<Point> = [];
		var right:Array<Point> = [];
		
		for (i in 0...poly.length)
		{
			var p1:Point = poly[i];
			var p2:Point = poly[(i + 1) % poly.length];
			//var pline:Line = {p1:p1, p2:p2};
			
			var p1Side:Int = getLineSide(line, p1);
			var p2Side:Int = getLineSide(line, p2);
			//Both are on same side, add to same list
			if (p1Side == p2Side)
			{
				if (p1Side == -1)
				{
					left.push(p1);
					left.push(p2);
				}
				else if (p1Side == 1)
				{
					right.push(p1);
					right.push(p2);
				}
				else //Both points are on the line. Add to both lists
				{
					left.push(p1);
					left.push(p2);
					
					right.push(p1);
					right.push(p2);
				}
			}
			else //Calculate where line is crossed and create new vertices
			{
				var intersect:Point = MathUtil.findLineIntersection(p1, p2, line.p1, line.p2);
				
				intercepts.push(intersect);
				
				if (intersect == null)
				{
					//Shouldnt happen
				}
				else
				{
					if (p1Side == -1)
					{
						left.push(p1);
						left.push(intersect);
						right.push(intersect);
						right.push(p2);
					}
					else if (p1Side == 1)
					{
						right.push(p1);
						right.push(intersect);
						left.push(intersect);
						left.push(p2);
					}
				}
			}
		}
		
		//Make sure no point exists twice
		var t:Array<Point> = [];
		for (p in left) if (t.indexOf(p) ==-1) t.push(p);
		left = t;
		
		t = [];
		for (p in right) if (t.indexOf(p) ==-1) t.push(p);
		right = t;
		
		return [left, right];
	}
	
}

typedef Line = {
	@:optional public var p1:Point;
	@:optional public var p2:Point;
	
}