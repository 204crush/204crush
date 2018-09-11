package matter;

@:native("Matter.Query")
extern class Query {
	static function ray(bodies:Array<Body>, startPoint:Vector, endPoint:Vector, ?rayWidth:Float):Array<Dynamic>;
	static function region(bodies:Array<Body>, bounds:Bounds, ?outside:Bool):Array<Body>;
}
