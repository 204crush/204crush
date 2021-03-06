package particles;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject;
import pixi.core.math.Point;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import util.Asset;
import util.Pool;

/**
 * ...
 * @author 
 */
@:expose("ParticleManager")
class ParticleManager 
{
	//Effects
	public static var squares:SquareParticles;
	
	public static var particles:Container;
	
	public function new() 
	{
		throw "Particle manager is static.";
	}
	
	public static function init():Void
	{
		particles = new Container();
		
		//Effects
		squares = new SquareParticles();
		particles.addChild(squares);
		
	}
	
	public static function rand(min:Int, max:Int):Int
	{
		return Math.floor( min + Math.random() * (max - min));
	}
	
}
