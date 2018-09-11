package matter;
import matter.Matter.IWorldOptions;

@:native("Matter.World")
extern class World {
	static function add(world:World, /*body:haxe.extern.EitherType<Composite, haxe.extern.EitherType<Array<Body>, haxe.extern.EitherType<Body, haxe.extern.EitherType<Array<Composite>, haxe.extern.EitherType<Constraint, Array<Constraint>>>>>>*/body:Dynamic):World;
	static function addBody(world:World, body:Body):World;
	static function addComposite(world:World, composite:Composite):World;
	static function addConstraint(world:World, constraint:Constraint):World;
	static function clear(world:World, keepStatic:Bool):Void;
	static function create(options:IWorldOptions):World;
	var gravity : Dynamic;
	var bounds : Bounds;
}
