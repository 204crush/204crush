package matter;

@:native("Matter.Render")
extern class Render {
	public static function create(options:Dynamic):Render;
	public static function run(render:Render):Void;
	
	public static function lookAt(render:Render, options:Dynamic):Void;
}
