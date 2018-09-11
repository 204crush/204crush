package matter;
import matter.Matter.ICompositeDefinition;

@:native("Matter.Composite")
extern class Composite {
	static function add(composite:Composite, object:haxe.extern.EitherType<Body, haxe.extern.EitherType<Composite, Constraint>>):Composite;
	static function addBody(composite:Composite, body:Body):Composite;
	static function addComposite(compositeA:Composite, compositeB:Composite):Composite;
	static function addConstraint(composite:Composite, constraint:Constraint):Composite;
	static function allBodies(composite:haxe.extern.EitherType<Composite, World>):Array<Body>;
	static function allComposites(composite:Composite):Array<Composite>;
	static function allConstraints(composite:Composite):Array<Composite>;
	static function clear(world:haxe.extern.EitherType<Composite, World>, keepStatic:Bool, ?deep:Bool):Void;
	static function create(options:ICompositeDefinition):Composite;
	static function get(composite:Composite, id:Float, type:String):haxe.extern.EitherType<Body, haxe.extern.EitherType<Composite, Constraint>>;
	static function move(compositeA:Composite, objects:Array<haxe.extern.EitherType<Body, haxe.extern.EitherType<Composite, Constraint>>>, compositeB:Composite):Composite;
	static function rebase(composite:Composite):Composite;
	static function remove(composite:haxe.extern.EitherType<Composite, World>, object:haxe.extern.EitherType<Body, haxe.extern.EitherType<Composite, Constraint>>, ?deep:Bool):Composite;
	static function removeBody(composite:Composite, body:Body, ?deep:Bool):Composite;
	static function removeBodyAt(composite:Composite, position:Float):Composite;
	static function removeComposite(compositeA:Composite, compositeB:Composite, ?deep:Bool):Composite;
	static function removeCompositeAt(composite:Composite, position:Float):Composite;
	static function removeConstraint(composite:Composite, constraint:Constraint, ?deep:Bool):Composite;
	static function removeConstraintAt(composite:Composite, position:Float):Composite;
	static function setModified(composite:Composite, isModified:Bool, ?updateParents:Bool):Void;
	static function bounds(world:haxe.extern.EitherType<Composite, World>):Bounds;
	var bodies : Array<Body>;
	var composites : Array<Composite>;
	var constraints : Array<Constraint>;
	var id : Float;
	var isModified : Bool;
	var label : String;
	var parent : Composite;
	var type : String;
}
