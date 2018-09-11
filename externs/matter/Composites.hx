package matter;

@:native("Matter.Composites")
extern class Composites {
	static function car(xx:Float, yy:Float, width:Float, height:Float, wheelSize:Float):Composite;
	static function chain(composite:Composite, xOffsetA:Float, yOffsetA:Float, xOffsetB:Float, yOffsetB:Float, options:Dynamic):Composite;
	static function mesh(composite:Composite, columns:Float, rows:Float, crossBrace:Bool, options:Dynamic):Composite;
	function newtonsCradle(xx:Float, yy:Float, _number:Float, size:Float, length:Float):Composite;
	static function pyramid(xx:Float, yy:Float, columns:Float, rows:Float, columnGap:Float, rowGap:Float, callback:haxe.Constraints.Function):Composite;
	static function softBody(xx:Float, yy:Float, columns:Float, rows:Float, columnGap:Float, rowGap:Float, crossBrace:Bool, particleRadius:Float, particleOptions:Dynamic, constraintOptions:Dynamic):Composite;
	static function stack(xx:Float, yy:Float, columns:Float, rows:Float, columnGap:Float, rowGap:Float, callback:haxe.Constraints.Function):Composite;
}
