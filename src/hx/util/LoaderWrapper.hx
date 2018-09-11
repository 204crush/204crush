package util;
import haxe.Timer;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import js.Browser;
import js.Lib;
import pixi.loaders.Loader;
import pixi.loaders.Resource;
import sounds.Sounds;

/**
 * Wraps the loading of assets, fonts & sounds into one utility class.
 * @author 
 */
@:expose("LW")
class LoaderWrapper
{
	public static var complete:Bool = false;
	
	private static var loader:Loader;
	private static var loadCount:Int=0;
	private static var totalCount:Int = 0;
	private static var fontLoadStarted:Bool=false;
	
	private static var imagesComplete:Bool = false;
	private static var onComplete:Void->Void;
	private static var batches:Array<Array<String>>;
	
	public function new() 
	{
		throw "LoaderWrapper is static only.";
	}
	
	private static function beforeSheetLoad():Dynamic
	{
		return function(r:Resource, next:Dynamic){
			if (r.name.indexOf("json_image") >= 0 && r.url.indexOf("?")==-1)
			{
				r.url += "?_=" + Base64.encode(Bytes.ofString(Config.VERSION));
			}
			next();
		};
	}
	
	public static function LOAD_ASSETS(assets:Array<String>, onComplete:Void->Void):Void
	{
		//if (loader != null) throw "Multiple calls to LOAD_ASSETS are not allowed.";
		LoaderWrapper.onComplete = onComplete;
		
		//Load fonts first.
		complete = false;
		//Start loading images at the same time.
		if (loader == null)
		{
			loader = new Loader();
			loader.before(beforeSheetLoad());
			Asset.init( loader);
		}
		
		//Split the loading into batches so low end devices can go through json parsing without issues even if huge sheet is used.
		totalCount = 0;
		batches = [];
		var batchSize:Int = 1;
		for (i in 0...assets.length)
		{
			var batchNumber:Int = Math.floor(i / batchSize);
			if (batches[batchNumber] == null) batches[batchNumber] = [];
			var name:String = assets[i];
			
			batches[batchNumber].push(name);
			if (batchNumber == 0)
			{
				addLoad(name);
			}
			//Json downloading includes json + image.
			if (name.indexOf("img")>=0 && name.substr(name.length - 4, 4) == "json")
				totalCount += 2;
			//Bitmap fonts include fnt + image
			else if (name.indexOf(".fnt") >= 0)
			{
				totalCount += 2;
			}
			else 
				totalCount++;
		}
		batches.shift();
		loadCount = 0;
		updateText();
		loader.addListener("progress", function(e:Loader):Void {
			loadCount++;
			updateText();
		});
		loader.addListener("complete", function(e:Loader):Void {
			if (batches.length == 0)
			{
				imagesComplete = true;
				assetLoaded();
			}
			else
			{
				var batch = batches.shift();
				for (name in batch)
				{
					addLoad(name);
				}
				loader.load();
			}
		});
		loader.load();
	}
	
	private static function addLoad(name:String):Void
	{
		var n:String = name;
		var index:Int = n.indexOf("@");
		if (index >= 0)
		{
			n = n.substr(0, index) + n.substr(n.lastIndexOf("."));
		}
		loader.add(n, name+"?_=" + Base64.encode(Bytes.ofString(Config.VERSION)));
	}
	
	private static function assetLoaded():Void
	{
		if ( imagesComplete && !complete)
		{
			complete = true;
			onComplete();
		}
	}
	
	private static function updateText():Void
	{
	//	var sound:Float = Math.floor(Sounds.soundsLoaded / Sounds.totalSounds) * 100;
		var other:Float = Math.floor(loadCount / totalCount) * 100;
		Browser.document.getElementById("preload").innerHTML = "Loading: please wait a moment. ";
	}
	
	public static function handleSound():Void
	{
		Sounds.loadChange = updateSoundText;
	}
	
	private static function updateSoundText(amount:Int):Void
	{
		updateText();
	}
}