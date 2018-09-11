package matter;
import matter.Matter.IBodyDefinition;

@:native("Matter.Bodies")
extern class Bodies {
	static function circle(x:Float, y:Float, radius:Float, ?options:IBodyDefinition, ?maxSides:Float):Body;
	static function polygon(x:Float, y:Float, sides:Float, radius:Float, ?options:IBodyDefinition):Body;
	static function rectangle(x:Float, y:Float, width:Float, height:Float, ?options:IBodyDefinition):Body;
	static function trapezoid(x:Float, y:Float, width:Float, height:Float, slope:Float, ?options:IBodyDefinition):Body;
	static function fromVertices(x:Float, y:Float, ?vectors:Array<Vector>, ?options:IBodyDefinition, ?flagInternal:Bool, ?removeCollinear:Float, ?minimumArea:Float):Body;
}
