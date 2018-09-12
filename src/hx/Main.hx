package;
import controls.EndView;
import controls.GameView;
import controls.StartView;
import createjs.soundjs.Sound;
import createjs.tweenjs.Tween;
import haxe.Timer;
import logic.GridLogic;
import particles.ParticleManager;

import js.Browser;
import js.html.CanvasElement;
import js.html.DivElement;
import js.Lib;
import js.html.Element;
import js.html.TouchEvent;
import js.jquery.JQuery;
import pixi.core.display.Container;
import pixi.core.math.shapes.Rectangle;
import pixi.core.Pixi;
import pixi.core.renderers.Detector;
import pixi.core.renderers.SystemRenderer;
import pixi.core.sprites.Sprite;
import pixi.core.ticker.Ticker;
import sounds.Sounds;
import util.Asset;
import util.BrowserDetect;
import util.LoaderWrapper;

/**
* Main class of the game UI.
* @author Moido Games
*/
@:expose("Game")
class Main
{
	/**
	 * Instance to gameui for easy access of framework
	 */
	public static var instance:Main;
	
	/**
	 * List of functions to be called whenever render triggers.
	 */
	public var tickListeners:Array < Float->Void > = [];
	
	/**
	* Private properties of the class.
	*/
	private var resizeTimer:Timer;
	private var container:DivElement;
	private var mainCanvas:CanvasElement;
	private var mainContainer:Container;
	public var viewport:Container;
	
	private var ticker:Ticker;
	
	public var game:GameView;
	private var start:StartView;
	private var end:EndView;
	
	/**
	 * Renderer for the game.
	 */
	public var renderer(default,null):SystemRenderer;
	
	/**
	* Entry point of the application.
	*/
	static public function main():Void
	{
		trace("Main");
		new JQuery().ready(function() { 
			instance = new Main();
		} );
	}
	
	/**
	* Creates an new instance of the class.
	*/
	public function new():Void
	{
		trace("new game");
		//Clear ticker from createjs/tweenjs as custom one is used and this would collide with tweens.
		//This was added due to tweenjs Ticker bug. Ticker was on even though it was stopped.
		//Check on next version of tweenjs if this has been resolved.
		untyped createjs.Ticker = null;
		
		//Wrap pixijs loader around fw loader.
		LoaderWrapper.LOAD_ASSETS( Config.ASSETS, onAssetsLoaded);
		Sounds.initSounds();
	}
	
	/**
	 * Assets loaded handler
	 */
	private function onAssetsLoaded():Void
	{
		GridLogic.INIT();
		
		Browser.document.getElementById("preload").remove();
		this.initializeRenderer();
		this.initializeControls();
		Browser.window.addEventListener("resize", this.onResize, false);
		Browser.window.addEventListener("orientationchange", this.onResize, false);
	}
	
	/**
	* After a resize event, throttle it and then resize the required elements.
	* @param event The recieved resize event.
	*/
	private function onResize(event:Dynamic):Void
	{
		if (this.resizeTimer != null) this.resizeTimer.stop();
		this.resizeTimer = Timer.delay(function()
		{
			this.mainContainer.visible = true;
			var size:Rectangle = this.getGameSize();
			this.renderer.resize(size.width, size.height);
			this.start.resize(size);
			this.game.resize(size);
			this.end.resize(size);
			
		},
		50);
	}
	
	/**
	* Gets the correct size of the game. IPhone may offset height and the size is fixed for WP7 devices.
	* This does not use frameworks viewmanager size on purpose. As the game is designed to play on ticket 
	* pages as well as normal ticket.
	* @return The size of the game.
	*/
	public function getGameSize():Rectangle
	{
		return new Rectangle(0, 0, Browser.window.innerWidth, Browser.window.innerHeight);
	}
	
	private function initializeRenderer():Void
	{
		var size:Rectangle = this.getGameSize();
		
		var options:RenderingOptions = { };
		options.autoResize = false;
		options.antialias = true;
		options.backgroundColor = 0x4ce564;
		options.clearBeforeRender = true;
		options.preserveDrawingBuffer = false;
		options.roundPixels = false;
		
		this.renderer = Detector.autoDetectRenderer(size.width, size.height, options);
		
		Browser.document.getElementById("game").appendChild(renderer.view);
	}
	
	/**
	* Initializes the main controls used in the game UI.
	* @param container The container where to add the canvas.
	*/
	private function initializeControls():Void
	{
		ParticleManager.init();
		
		this.mainContainer = new Container();
		
		this.game = new GameView();
		this.game.visible = false;
		this.start = new StartView();
		this.start.visible = true;
		this.end = new EndView();
		this.end.visible = false;
		
		this.mainContainer.addChild(this.start);
		this.mainContainer.addChild(this.game);
		this.mainContainer.addChild(this.end);
		this.mainContainer.addChild(ParticleManager.particles);
		//ParticleManager.init();
		
		this.onResize(null);
		this.ticker = new Ticker();
		this.ticker.start();
		this.ticker.add(onTickerTick);
		
		this.start.start_small.addListener("click", onStartClick_Small);
		this.start.start_small.addListener("tap", onStartClick_Small);
		this.start.start_medium.addListener("click", onStartClick_Medium);
		this.start.start_medium.addListener("tap", onStartClick_Medium);
		this.start.start_big.addListener("click", onStartClick_Big);
		this.start.start_big.addListener("tap", onStartClick_Big);
		
		this.end.again.addListener("click", onAgainClick);
		this.end.again.addListener("tap", onAgainClick);
		
		this.end.back.addListener("click", onBackClick);
		this.end.back.addListener("tap", onBackClick);
		
		this.game.addListener(GameView.GAME_ENDED, onGameEnd);
		
		this.mainContainer.visible = false;
	}
	
	private function onStartClick_Small():Void
	{
		GridLogic.GRID_HEIGHT = 6;
		GridLogic.GRID_WIDTH = 6;
		onStartClick();
	}
	
	private function onStartClick_Medium():Void
	{
		GridLogic.GRID_HEIGHT = 7;
		GridLogic.GRID_WIDTH = 7;
		onStartClick();
	}
	
	private function onStartClick_Big():Void
	{
		GridLogic.GRID_HEIGHT = 8;
		GridLogic.GRID_WIDTH = 8;
		onStartClick();
	}
	
	private function onStartClick():Void
	{
		this.start.interactiveChildren = false;
		this.start.visible = false;
		this.end._score.setScore(0);
		game.prepare();
		this.game.visible = true;
		Timer.delay(function(){
			this.game.start();
		},500);
	}
	
	private function onAgainClick():Void
	{
		this.end.interactiveChildren = false;
		this.end.visible = false;
		onStartClick();
	}
	
	
	private function onBackClick():Void
	{
		this.end.interactiveChildren = false;
		this.end.visible = false;
		this.start.visible = true;
		this.start.interactiveChildren = true;
	}
	
	private function onGameEnd():Void
	{
		this.end.interactiveChildren = true;
		this.end._score.setScore(GameView._score);
		this.game.interactiveChildren = false;
		this.game.visible = false;
		this.end.visible = true;
	}
	
	public function replay():Void
	{
		this.start.interactiveChildren = true;
	}
	
	/**
	* Updates the stage on Ticker tick.
	* @param event The recieved tick event.
	*/
	private function onTickerTick():Void
	{
		var delta:Float = ticker.deltaTime;
		Tween.tick(ticker.elapsedMS,false);
		for (t in tickListeners) t(delta);
		
		this.renderer.render(this.mainContainer);
	}
	
}
