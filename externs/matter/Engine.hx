package matter;
import js.html.HtmlElement;
import matter.Matter.IEngineOptions;
import matter.Matter.IEngineTimingOptions;


@:native("Matter.Engine")
extern class Engine {
	static function clear(engine:Engine):Void;
	static function create(?element:haxe.extern.EitherType<HtmlElement,IEngineOptions>, ?options:IEngineOptions):Engine;
	static function merge(engineA:Engine, engineB:Engine):Void;
	static function render(engineA:Engine, engineB:Engine):Void;
	static function run(engine:Engine):Void;
	static function update(engine:Engine, ?delta:Float, ?correction:Float):Void;
	var constraintIterations : Float;
	var enabled : Bool;
	var enableSleeping : Bool;
	var positionIterations : Float;
	var timing : IEngineTimingOptions;
	var velocityIterations : Float;
	var world : World;
}
