package matter;


@:native("Matter.Events")
extern class Events {
	/*
	@:overload(function(obj:Engine, name:AfterUpdate, callback:Dynamic -> Void):Void { })
	@:overload(function(obj:Engine, name:BeforeRender, callback:Dynamic -> Void):Void { })
	@:overload(function(obj:Engine, name:BeforeTick, callback:Dynamic -> Void):Void { })
	@:overload(function(obj:Engine, name:BeforeUpdate, callback:Dynamic -> Void):Void { })
	@:overload(function(obj:Engine, name:CollisionActive, callback:Dynamic -> Void):Void { })
	@:overload(function(obj:Engine, name:CollisionEnd, callback:Dynamic -> Void):Void { })
	@:overload(function(obj:Engine, name:CollisionStart, callback:Dynamic -> Void):Void { })
	@:overload(function(obj:Engine, name:Mousedown, callback:Dynamic -> Void):Void { })
	@:overload(function(obj:Engine, name:Mousemove, callback:Dynamic -> Void):Void { })
	@:overload(function(obj:Engine, name:Mouseup, callback:Dynamic -> Void):Void { })
	@:overload(function(obj:Engine, name:Tick, callback:Dynamic -> Void):Void { })
	@:overload(function(obj:Engine, name:String, callback:Dynamic -> Void):Void { })
	*/
	static function on(obj:Engine, eventName:String, callback:Dynamic -> Void):Void;
	static function off(obj:Dynamic, eventName:String, ?callback:Dynamic -> Void):Void;
	static function trigger(object:Dynamic, eventNames:String, event:Dynamic -> Void):Void;
}
