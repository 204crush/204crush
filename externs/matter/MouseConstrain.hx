package matter;

@:native("Matter.MouseConstrain")
extern class MouseConstraint {
	function create(engine:Engine, options:IMouseConstraintDefinition):MouseConstraint;
	var constraint : Constraint;
	var dragBody : Body;
	var dragPoint : Vector;
	var mouse : Mouse;
	var type : String;
}