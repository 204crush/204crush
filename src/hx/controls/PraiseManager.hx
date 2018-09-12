package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import haxe.Timer;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.text.Text;
import pixi.core.text.TextStyleObject;

/**
 * ...
 * @author Henri Sarasvirta
 */
@:expose("PraiseManager")
class PraiseManager extends Container 
{
	private static var instance:PraiseManager;
	private var texts:Array<Text>;
	private var current:Int = 0;
	
	public function new() 
	{
		super();
		instance = this;
		initializeControls();
	}
	
	private function initializeControls():Void
	{
		var ts:TextStyleObject = {};
		
		ts.dropShadow = true;
		ts.dropShadowColor = "#4d2424";
		ts.dropShadowBlur = 10;
		ts.fontFamily = "ar_christyregular";
		
		//ts.fontStyle = "pigment_demoregular";
		ts.fontSize = 90;	
		ts.fill = 0xFF1e00;
		ts.fill = 0xBA00FF;
		texts = [];
		for (i in 0...6)
		{
			var text = new Text("4 chain!", ts);
			texts.push(text);
			text.visible = false;
			this.addChild(text);
		}
	}
	
	public static function showMessage(message:String,delay:Int):Void
	{
		Timer.delay(function(){instance.showPraise(message); }, delay);
	}
	
	public function showPraise(message:String):Void
	{
		current++;
		current = current % texts.length;
		
		var text:Text = texts[current];
		
		text.text = message;
		text.scale.x = text.scale.y = 1;
		text.pivot.x = text.width / 2;
		text.pivot.y = text.height / 2;
		
		text.visible = true;
		text.alpha = 1;
		
		Tween.get(text.pivot).to({y:250}, 1500, Ease.quadOut);
		
		Tween.get(text.scale).to({x:1.0, y:1.0}, 1500, Ease.quadOut);
		Tween.get(text).wait(1000,true).to({alpha:0}, 500, Ease.quadOut);
		
	}
}