package util;
import js.Lib;
import js.html.Image;
import pixi.core.sprites.Sprite;
import pixi.core.textures.BaseTexture;
import pixi.core.textures.Texture;
import pixi.loaders.Loader;


/**
 * Wraps the pixi.js asset handling for easier access of both local files & from spritesheets.
 * @author Henri Sarasvirta, Moido Games
 */
@:expose("util.Asset")
class Asset
{
	private static var _init:Bool = false;
	private static var _loader:Loader;
	private static var _prepared:Array<BaseTexture> = [];
	
	public function new() 
	{
		throw "Asset is static only.";
	}
	
	/**
	 * Initialize the Asset class. Should be called only once. Any additional call is ignored.
	 * @param	gameui
	 */
	public static function init(loader:Loader):Void
	{
		Asset._loader = loader;
	}
	
	public static function getResource(name:String):Dynamic
	{
		if (!Reflect.hasField(_loader.resources, name))
		{
			trace("Resource " + name + " not found!");
		}
		return Reflect.field(_loader.resources, name);
	}
	
	/**
	 * Returns raw image with given name. The image is fetched from spritesheet or from gameUI. If no such image exists, null is returned.
	 * @param	name Name of the image (without extension)
	 * @return Image or null if it doesn't exist.
	 */
	public static function getRawImage(name:String):Image
	{
		/*for ( sheet in sheets)
		{
			if (sheet.getAnimation(name) != null)
				return SpriteSheetUtils.extractFrame(sheet, name);
		}*/
		//TODO - check if this can be used with pixi.js
		//TODO - implement sheet extract
		return getResource(name).data;// gameUI.getLoadedImage(name);
	}
	
	/**
	 * Returns either Sprite or Bitmap depending on where the image is found. Sprite if part of spritesheet, bitmap if standalone image.
	 * @param	name Name of the image (without extension)
	 * @param fromSheet Tells if the image is from sheet. Then base path is not used.
	 * @return Image or null if it doesn't exist.
	 */
	public static function getTexture(name:String, ?fromSheet:Bool):Texture
	{
		if(!fromSheet)
			name = "img/" + name;
		var tex:Texture = null;
		try
		{
			tex = Texture.fromFrame(name);
		}
		catch (e:Dynamic) {
			tex = Texture.fromImage(name);
		}
		if (tex == null)
		{
			trace("Warning: Asset " + name + " not found.");
		}
		if (tex != null && _prepared.indexOf(tex.baseTexture) == -1)
		{
			_prepared.push(tex.baseTexture);
		//	if(!Config.MINIMAL_GPU)
				Main.instance.renderer.plugins.prepare.upload(tex.baseTexture);
		}
	//	if (tex == null) EInstant.logDebug("Texture " + name + " is null");
		return tex;
	}
	/**
	 * Returns either Sprite or Bitmap depending on where the image is found. Sprite if part of spritesheet, bitmap if standalone image.
	 * @param	name Name of the image (without extension)
	 * @param fromSheet Tells if the image is from sheet. Then base path is not used.
	 * @return Image or null if it doesn't exist.
	 */
	public static function getImage(name:String, ?fromSheet:Bool):Sprite
	{
		if(!fromSheet)
			name = "img/" + name;
		
		var sprite:Sprite = null;
		try
		{
			sprite = Sprite.fromFrame(name);
		}
		catch (e:Dynamic) {
			var t:Texture = Texture.fromImage(name);
			var sprite:Sprite = new Sprite(t);
		}
		if (sprite == null)
		{
			trace("Warning: Asset " + name + " not found.");
		}
		if (sprite != null && _prepared.indexOf(sprite.texture.baseTexture) == -1)
		{
			_prepared.push(sprite.texture.baseTexture);
		//	if(!Config.MINIMAL_GPU)
				Main.instance.renderer.plugins.prepare.upload(sprite.texture.baseTexture);
		}
	//	if (sprite == null) EInstant.logDebug("Image " + name + " is null");
		return sprite;
	}
	
	/**
	 * Returns all textures and animations from given spritesheet.
	 * The directory path should be ID/ANIMATION/sequence.png
	 * @param	json
	 * @return
	 */
	public static function getTexturesAndAnimations(json:Dynamic, id:String):Dynamic
	{
		var tex:Array<Texture> = [];
		var anim:Dynamic = { };
		var ret:Dynamic = { textures:tex, animations:anim };
		var count:Int = 0;
		for ( frame in Reflect.fields(json.frames))
		{
			var data:Dynamic = Reflect.field( json.frames, frame );
			var split:Array<String> = frame.split("/");
			if (split[0] != id)
				continue;
			
			var animName:String = split[1];
			var spriteName:String = split[2];
			var texture:Texture = Texture.fromFrame(frame);
			tex.push(texture);
			if (texture != null && _prepared.indexOf(texture.baseTexture) == -1)
			{
				_prepared.push(texture.baseTexture);
		//		if(!Config.MINIMAL_GPU)
					Main.instance.renderer.plugins.prepare.upload(texture.baseTexture);
			}
			if ( Reflect.hasField(anim, animName))
			{
				//Animation exists. Move the end frame forward.
				Reflect.field(anim, animName)[1] = count;
			}
			else
			{
				//New animation. Single frame in the beginning.
				Reflect.setField(anim, animName, [ count, count ]);
			}
			
			count++;
		}
	//	if (ret.textures.length == 0) EInstant.logDebug("Texture/Anim " + id + " is empty");
		return ret;
	}
	
	public static function getTextures(json:Dynamic,id:EReg):Array<Texture>
	{
		var tex:Array<Texture> = [];
		for ( frame in Reflect.fields(json.frames))
		{
			var data:Dynamic = Reflect.field( json.frames, frame );
			
			if (id.match(frame))
			{
				var texture:Texture = Texture.fromFrame(frame);
				tex.push(texture);
				if (_prepared.indexOf(texture.baseTexture)==-1)
				{
					_prepared.push(texture.baseTexture);
		//			if(!Config.MINIMAL_GPU)
						Main.instance.renderer.plugins.prepare.upload(texture.baseTexture);
				}
			}
		}
	//	if (tex.length == 0) EInstant.logDebug("Textures " + id + " is empty");
		return tex;
	}
}