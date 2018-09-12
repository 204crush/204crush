package controls;

import pixi.core.display.Container;
import pixi.core.text.Text;
import pixi.core.text.TextStyleObject;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Score extends Container 
{
	private var scoreField:Text;
	private var scoreTarget:Float = 0;
	private var curScore:Float = 0;
	
	public function new() 
	{
		super();
		
		this.initializeControls();
		
		Main.instance.tickListeners.push(ontick);
	}
	
	public function prepare():Void
	{
		this.curScore = 0;
		this.scoreTarget = 0;
		this.scoreField.text = "0";
	}
	
	private function initializeControls():Void
	{
		var ts:TextStyleObject = {};
		ts.dropShadow = true;
		ts.dropShadowColor = "#4d2424";
		ts.dropShadowBlur = 10;
		ts.fontFamily = "ar_christyregular";
		ts.fontSize = 90;	
		//ts.fill = 0xBA00FF;
		ts.fill = 0xFFFFFF;
		this.scoreField = new Text("12512", ts);
		this.addChild(this.scoreField);
	}
	
	private function ontick(delta:Float):Void
	{
		curScore += Math.round( scoreTarget - curScore ) / 15;
		if (curScore - 1 > scoreTarget)
		{
			curScore = scoreTarget;
		}
		this.scoreField.text = Std.string(Math.floor(curScore));
		this.scoreField.x = Math.round( -this.scoreField.width/2);
	}
	
	public function setScore(value:Int):Void
	{
		this.scoreTarget = value;
	}
	
}