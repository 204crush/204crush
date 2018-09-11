package matter;

typedef IEngineOptions = {
	@:optional
	var positionIterations:Int;
	@:optional
	var velocityIterations:Int;
	@:optional
	var constraintIterations:Int;
	@:optional
	var enableSleeping:Bool;
	@:optional
	var events:Array<Dynamic>;
	@:optional
	var timing:IEngineTimingOptions;
	@:optional
	var broadphase:Dynamic;
};
typedef IEngineTimingOptions = {
	var correction : Float;
	var delta : Float;
	var timeScale : Float;
	var timestamp : Float;
	var velocityIterations : Float;
};

typedef IRunnerOptions = { };

typedef IWorldOptions = { };

typedef IBodyDefinition = {
	@:optional
	var angle : Float;
	@:optional
	var angularSpeed : Float;
	@:optional
	var angularVelocity : Float;
	@:optional
	var area : Float;
	@:optional
	var axes : Array<Vector>;
	@:optional
	var bounds : Bounds;
	@:optional
	var chamfer : Float;
	@:optional
	var collisionFilter:Dynamic;
	@:optional
	var density : Float;
	@:optional
	var force : Vector;
	@:optional
	var friction : Float;
	@:optional
	var frictionAir : Float;
	@:optional
	var frictionStatic : Float;
	@:optional
	var groupId : Float;
	@:optional
	var id : Float;
	@:optional
	var inertia : Float;
	@:optional
	var inverseInertia : Float;
	@:optional
	var inverseMass : Float;
	@:optional
	var isSensor:Bool;
	@:optional
	var isSleeping : Bool;
	@:optional
	var isStatic : Bool;
	@:optional
	var label : String;
	@:optional
	var mass : Float;
	@:optional
	var motion : Float;
	@:optional
	var position : Vector;
	@:optional
	var render : IBodyRenderOptions;
	@:optional
	var restitution : Float;
	@:optional
	var sleepThreshold : Float;
	@:optional
	var slop : Float;
	@:optional
	var speed : Float;
	@:optional
	var timeScale : Float;
	@:optional
	var torque : Float;
	@:optional
	var type : String;
	@:optional
	var velocity : Vector;
	@:optional
	var vertices : Array<Vector>;
};

typedef IBodyRenderOptions = {
	var fillStyle : String;
	var lineWidth : Float;
	var sprite : IBodyRenderOptionsSprite;
	var strokeStyle : String;
	var visible : Bool;
};
typedef IBodyRenderOptionsSprite = {
	var texture : String;
	var xScale : Float;
	var yScale : Float;
};

typedef IMouseConstraintDefinition = {
	@:optional
	var constraint : Constraint;
	@:optional
	var dragBody : Body;
	@:optional
	var dragPoint : Vector;
	@:optional
	var mouse : Mouse;
	@:optional
	var type : String;
};

typedef IConstraintRenderRefinition = {
	var lineWidth : Float;
	var strokeStyle : String;
	var visible : Bool;
};

typedef IConstraintDefinition = {
	@:optional
	var bodyA : Body;
	@:optional
	var bodyB : Body;
	@:optional
	var id : Float;
	@:optional
	var label : String;
	@:optional
	var length : Float;
	@:optional
	var pointA : Vector;
	@:optional
	var pointB : Vector;
	@:optional
	var render : IConstraintRenderRefinition;
	@:optional
	var stiffness : Float;
	@:optional
	var angularStiffness : Float;
	@:optional
	var type : String;
	@:optional
	var damping : Float;
};

typedef ICompositeDefinition = {
	@:optional
	var bodies : Array<Body>;
	@:optional
	var composites : Array<Composite>;
	@:optional
	var constraints : Array<Constraint>;
	@:optional
	var id : Float;
	@:optional
	var isModified : Bool;
	@:optional
	var label : String;
	@:optional
	var parent : Composite;
	@:optional
	var type : String;
};