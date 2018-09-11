package matter;
import matter.Matter.IConstraintDefinition;
import matter.Matter.IConstraintRenderRefinition;


@:native("Matter.Constraint")
extern class Constraint {
	static function create(options:IConstraintDefinition):Constraint;
	var bodyA : Body;
	var bodyB : Body;
	var id : Float;
	var label : String;
	var length : Float;
	var pointA : Vector;
	var pointB : Vector;
	var render : IConstraintRenderRefinition;
	var stiffness : Float;
	var angularStiffness : Float;
	var type : String;
	var damping : Float;
}