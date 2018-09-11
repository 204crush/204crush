package util;

import pixi.core.math.Point;

/**
 * ...
 * @author 
 */
class MathUtil 
{

	public function new() 
	{
		
	}
	
	/**
	 * Calculates line intersection point between given lines P1 - P2 and P3 - P4.
	 * Algorithm based on http://en.wikipedia.org/wiki/Line-line_intersection
	 * @param	p1
	 * @param	p2
	 * @param	p3
	 * @param	p4
	 * @return
	 */
	public static function findLineIntersection(p1:Point, p2:Point, p3:Point, p4:Point):Point
	{
		var x12:Float = p1.x - p2.x;
		var x34:Float = p3.x - p4.x;
		var y12:Float = p1.y - p2.y;
		var y34:Float = p3.y - p4.y;
		
		var c:Float = x12 * y34 - y12 * x34;
		if (Math.abs(c) < 0.01 )
			return null;
		else
		{
			var a:Float = p1.x * p2.y - p1.y * p2.x;
			var b:Float = p3.x * p4.y - p3.y * p4.x;
			
			var x:Float = (a * x34 - b * x12) / c;
			var y:Float = (a * y34 - b * y12) / c;
			
			return new Point(x, y);
		}
	}
	
	public static function normalize(point:Point):Point
	{
		var np:Point = new Point(point.x, point.y);
		var l:Float = Math.sqrt(np.x * np.x + np.y * np.y);
		if (l == 0) l = 1;
		np.x /= l;
		np.y /= l;
		return np;
	}
	
	public static function pointLength(point:Point):Float
	{
		return Math.sqrt(point.x * point.x + point.y * point.y);
	}
	
	public static function calculateArea(polygon:Array<Point>):Float
	{
		var sum:Float = 0;
		for (i in 0...polygon.length)
		{
			sum += polygon[i].x * polygon[(i + 1) % polygon.length].y - polygon[i].y * polygon[(i + 1) % polygon.length].x;
		}
		return Math.abs(sum / 2);
	}
	
	
	/**
	 * Cubic interpolation based on https://github.com/osuushi/Smooth.js
	 * @param	k
	 * @return
	 */
	private static function clipInput(k:Int, arr:Array<Float>):Float
	{
		if (k < 0)
			k = 0;
		if (k > arr.length - 1)
			k = arr.length - 1;
		return arr[k];
	}
	private static function getTangent(k:Int, factor:Float, array:Array<Float>):Float{
		return factor * (clipInput(k + 1, array) - clipInput(k - 1,array)) / 2;
	}
	public static function cubicInterpolation(array:Array<Float>, t:Float, ?tangentFactor:Float)
	{
		if (tangentFactor == null) tangentFactor = 1;
		
		var k:Int = Math.floor(t);
		var m:Array<Float> = [getTangent(k, tangentFactor, array), getTangent(k + 1, tangentFactor, array)];
		var p:Array<Float> = [clipInput(k,array), clipInput(k+1,array)];
		t -= k;
		var t2:Float = t * t;
		var t3:Float = t * t2;
		return (2 * t3 - 3 * t2 + 1) * p[0] + (t3 - 2 * t2 + t) * m[0] + ( -2 * t3 + 3 * t2) * p[1] + (t3 - t2) * m[1];
	}
	
	public static function shuffle(array:Dynamic, key:Int):Dynamic
	{
		var index:Dynamic, result:Dynamic = [];
		var copy:Dynamic = array.slice(0);
		while (copy.length > 0)
		{
			if (!Math.isNaN(key)) index = key % copy.length;
			else index = Math.floor(Math.random() * copy.length);
			result.push(copy[index]);
			copy.splice(index, 1);
		}
		return result;
	}

}