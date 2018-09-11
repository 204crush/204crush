package controls;

import js.Browser;
import js.html.KeyboardEvent;
import logic.GridLogic;
import pixi.core.display.Container;

/**
 * ...
 * @author Henri Sarasvirta
 */
class GridControl extends Container 
{
	private var logic:GridLogic;
	
	public function new() 
	{
		super();
		this.logic = new GridLogic();
		this.logic.spawnRandom();
		this.logic.printGrid();
		this.initializeControls();
		
		Browser.window.addEventListener("keydown", keyDown);
	}
	
	private function initializeControls():Void
	{
		
	}
	
	private function keyDown(event:KeyboardEvent):Void
	{
		var direction:Direction = null;
		if (event.keyCode == 38) //up
		{
			direction = Direction.up;
		}
		else if (event.keyCode == 37)//left
		{
			direction = Direction.left;
		}
		else if (event.keyCode == 40)//down
		{
			direction = Direction.down;
		}
		else if (event.keyCode == 39)//right
		{
			direction = Direction.right;
		}
		
		if (direction != null)
		{
			this.logic.swipe(direction);
			var removed:Array<Node> = this.logic.remove();
			while (removed.length > 0)
			{
				this.logic.clearRemoved(removed);
				this.logic.swipe(direction);
				removed = this.logic.remove();
			}
			
			//Spawn
			this.logic.spawnRandom();
			
			this.logic.printGrid();
		}
	}
}