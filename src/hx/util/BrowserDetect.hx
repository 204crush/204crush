package util;
import js.Browser;
import js.Lib;

/**
 * Detects browser
 * @author ported from http://www.quirksmode.org/js/detect.html to haxe by Henri Sarasvirta, Moido Games oy
 */
class BrowserDetect
{
	public static var browser:String;
	public static var version:String;
	public static var OS:String;
	
	private static var versionSearchString:String;
	
	public static var dataBrowser:Array<Dynamic> = [
		{
			string: Browser.navigator.userAgent,
			subString: "Windows Phone 10.0",
			identity: "WindowsPhone10Edge"
		},
		{
			string: Browser.navigator.userAgent,
			subString: "Chrome",
			identity: "Chrome"
		},
		{ 	string: Browser.navigator.userAgent,
			subString: "OmniWeb",
			versionSearch: "OmniWeb/",
			identity: "OmniWeb"
		},
		{
			string: Browser.navigator.vendor,
			subString: "Apple",
			identity: "Safari",
			versionSearch: "Version"
		},
		{
			string: Browser.navigator.vendor,
			subString: "iCab",
			identity: "iCab"
		},
		{
			string: Browser.navigator.vendor,
			subString: "KDE",
			identity: "Konqueror"
		},
		{
			string: Browser.navigator.userAgent,
			subString: "Firefox",
			identity: "Firefox"
		},
		{
			string: Browser.navigator.vendor,
			subString: "Camino",
			identity: "Camino"
		},
		{		// for newer Netscapes (6+)
			string: Browser.navigator.userAgent,
			subString: "Netscape",
			identity: "Netscape"
		},
		{
			string: Browser.navigator.userAgent,
			subString: "MSIE",
			identity: "Explorer",
			versionSearch: "MSIE"
		},
		{
			string: Browser.navigator.userAgent,
			subString: "Trident",
			identity: "Explorer11",
			versionSearch: "MSIE"
		},
		{
			string: Browser.navigator.userAgent,
			subString: "Gecko",
			identity: "Mozilla",
			versionSearch: "rv"
		},
		{ 		// for older Netscapes (4-)
			string: Browser.navigator.userAgent,
			subString: "Mozilla",
			identity: "Netscape",
			versionSearch: "Mozilla"
		},
		{
			prop: Browser.navigator.vendor,
			identity: "Opera",
			versionSearch: "Version"
		}
	];
	public static var dataOS:Array<Dynamic> = [
		{
			string: Browser.navigator.platform,
			subString: "Win",
			identity: "Windows"
		},
		{
			string: Browser.navigator.platform,
			subString: "Mac",
			identity: "Mac"
		},
		{
			   string: Browser.navigator.userAgent,
			   subString: "iPhone",
			   identity: "iPhone/iPod"
	    },
		{
			string: Browser.navigator.platform,
			subString: "Linux",
			identity: "Linux"
		}
	];
	
	public function new() 
	{
		
	}
	
	public static function init():Void
	{
		browser = searchString(dataBrowser);
		var versionUserAgentResult = Std.string( searchVersion(Browser.navigator.userAgent));
		if (versionUserAgentResult == null)
		{
			var versionAppResult = Std.string( searchVersion(Browser.navigator.appVersion));
			if (versionAppResult == null)
				version = "An unkonwn version";
			else
				version = versionAppResult;
		}
		else
			version = versionUserAgentResult;
			
		var dataOsFind:String = searchString(dataOS);
		OS = dataOsFind == null ? "an unkonwn OS" : dataOsFind;
	}
	
	public static function searchString(data:Array<Dynamic>):String
	{
		for ( i in 0 ... data.length)
		{
			var dataString:String = data[i].string;
			var dataProp:String = data[i].prop;
			var versionResult = data[i].versionSearch;
			versionSearchString = versionResult == null ? data[i].identity : versionResult;
			if (dataString!=null) {
				if (dataString.indexOf(data[i].subString) != -1)
					return data[i].identity;
			}
			else if (dataProp != null)
				return data[i].identity;
		}
		return null;
	}
	
	public static function searchVersion(dataString:String):Float
	{
		var index:Int = dataString.indexOf(versionSearchString);
		if (index == -1) return null;
		return Std.parseFloat(dataString.substring(index+versionSearchString.length+1));
	}
	
	public static function getAndroidVersion():String {
		var ua:String = Browser.navigator.userAgent.toLowerCase(); 
		var reg:EReg = new EReg("android\\s([0-9\\.]*)","");
		var match = reg.match(ua);
		return match ? reg.matched(1) : "0";
	}
}