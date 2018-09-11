package util;
import js.html.Uint8Array;
import js.html.Uint8ClampedArray;
import pixi.core.display.DisplayObject;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;

/**
 * ...
 * @author 
 */
class ImageUtil 
{
	private static var target:Sprite = new Sprite();

	public function new() 
	{
		
	}
	
	public static function getPixelData(texture:Texture):ImagePixelData
	{
		target.texture = texture;
		var data:Uint8ClampedArray = GameUI.instance.renderer.plugins.extract.pixels( target );
		return {width:cast Math.floor(target.texture.width), height: cast Math.floor(target.texture.height), data:data};
	}
}
typedef ImagePixelData = {
	@:optional public var width:Int;
	@:optional public var height:Int;
	@:optional public var data:Uint8ClampedArray;
	
};