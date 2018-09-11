package matter;
import js.html.HtmlElement;
import matter.Matter.IEngineOptions;
import matter.Matter.IEngineTimingOptions;


@:native("Matter.Sleeping")
extern class Sleeping {
	static function set(body:Body, isSleeping:Bool):Void;
}
