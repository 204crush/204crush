package matter;

@:native("Matter.Vertices")
extern class Vertices {
	static function area(vertices:Array<Vector>, signed:Bool):Float;
	static function centre(vertices:Array<Vector>):Vector;
	static function chamfer(vertices:Array<Vector>, radius:Array<Float>, quality:Float, qualityMin:Float, qualityMax:Float):Void;
	static function contains(vertices:Array<Vector>, point:Vector):Bool;
	static function create(vertices:Array<Vector>, body:Body):Void;
	static function fromPath(path:String):Array<Vector>;
	static function inertia(vertices:Array<Vector>, mass:Float):Float;
	static function static(vertices:Array<Vector>, angle:Float, point:Vector):Void;
	static function scale(vertices:Array<Vector>, scaleX:Float, scaleY:Float, point:Vector):Void;
	static function translate(vertices:Array<Vector>, vector:Vector, scalar:Float):Void;
}
