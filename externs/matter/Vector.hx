package matter;

@:native("Matter.Vector")
extern class Vector {
	var x : Float;
	var y : Float;
	static function add(vectorA:Vector, vectorB:Vector):Vector;
	static function angle(vectorA:Vector, vectorB:Vector):Float;
	static function cross(vectorA:Vector, vectorB:Vector):Float;
	static function div(vector:Vector, scalar:Float):Vector;
	static function dot(vectorA:Vector, vectorB:Vector):Float;
	static function magnitude(vector:Vector):Float;
	static function magnitudeSquared(vector:Vector):Float;
	static function mult(vector:Vector, scalar:Float):Vector;
	static function neg(vector:Vector):Vector;
	static function normalise(vector:Vector):Vector;
	static function perp(vector:Vector, ?negate:Bool):Vector;
	static function rotate(vector:Vector, angle:Float):Vector;
	static function rotateAbout(vector:Vector, angle:Float, point:Vector):Vector;
	static function sub(vectorA:Vector, vectorB:Vector):Vector;
}
