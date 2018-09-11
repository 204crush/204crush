package controls;
import pixi.core.Pixi;
import pixi.core.Pixi.BlendModes;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.textures.Texture;
import pixi.mesh.Rope;
import util.Asset;

/**
 * ...
 * @author Joel Setterberg
 */
class TouchTrail extends Container
{
	//historySize determines how long the trail will be.
	public static var HISTORY_SIZE:Int = 20;
	//ropeSize determines how smooth the trail will be.
	public static var ROPE_SIZE:Int = 100;
	
	private var historyX = [];
	private var historyY = [];
	private var points = [];
	
	public function new() 
	{
		super();
		//Get the texture for rope.
		var trailTexture:Texture = Asset.getTexture("trail.png", false);
		
		//Create the rope
		var rope = new Rope(trailTexture, points);
		//Set the blendmode
		rope.blendMode = Pixi.BLEND_MODES.ADD;

		//Create history array.
		for( i in 0...HISTORY_SIZE )
		{
			historyX.push(0);
			historyY.push(0);
		}
		
		//Create rope points.
		for( i in 0...ROPE_SIZE )
		{
			points.push(new Point(0,0));
		}
		
		/**
		 * Cubic interpolation based on https://github.com/osuushi/Smooth.js
		 * @param	k
		 * @return
		 */
		function clipInput(k, arr:Array<Int>):Int
		{
			if (k < 0)
				k = 0;
			if (k > arr.length - 1)
				k = arr.length - 1;
			return arr[k];
		}

		function getTangent(k, factor, array)
		{
			return factor * (clipInput(k + 1, array) - clipInput(k - 1,array)) / 2;
		}

		function cubicInterpolation(array, t, tangentFactor)
		{
			if (tangentFactor == null) tangentFactor = 1;
			
			var k = Math.floor(t);
			var m = [getTangent(k, tangentFactor, array), getTangent(k + 1, tangentFactor, array)];
			var p = [clipInput(k,array), clipInput(k+1,array)];
			t -= k;
			var t2 = t * t;
			var t3 = t * t2;
			return (2 * t3 - 3 * t2 + 1) * p[0] + (t3 - 2 * t2 + t) * m[0] + ( -2 * t3 + 3 * t2) * p[1] + (t3 - t2) * m[1];
		}
	}
}
/*
	// Listen for animate update
	app.ticker.add(function(delta) {
		//Read mouse points, this could be done also in mousemove/touchmove update. For simplicity it is done here for now.
		//When implemeting this properly, make sure to implement touchmove as interaction plugins mouse might not update on certain devices.
		var mouseposition = app.renderer.plugins.interaction.mouse.global;
		
		//Update the mouse values to history
		historyX.pop();
		historyX.unshift(mouseposition.x);
		historyY.pop();
		historyY.unshift(mouseposition.y);
		//Update the points to correspond with history.
		for( var i = 0; i < ropeSize; i++)
		{
			var p = points[i];
			
			//Smooth the curve with cubic interpolation to prevent sharp edges.
			var ix = cubicInterpolation( historyX, i / ropeSize * historySize);
			var iy = cubicInterpolation( historyY, i / ropeSize * historySize);
			
			p.x = ix;
			p.y = iy;
			
		}
	});
*/