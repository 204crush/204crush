package controls;

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
	}
	
}