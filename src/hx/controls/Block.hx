package controls;

import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;
import haxe.Timer;
import js.Lib;
import js.html.SimpleGestureEvent;
import logic.GridLogic;
import logic.GridLogic.Node;
import particles.ParticleManager;
import pixi.core.Pixi;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.extras.AnimatedSprite;
import util.Asset;

/**
 * ...
 * @author Henri Sarasvirta
 */
class Block extends Container 
{
	//Animation frames.
	private static var moveLeft:Array<Array<Texture>>= [];
	private static var moveRight:Array<Array<Texture>>= [];
	private static var moveTop:Array<Array<Texture>>= [];
	private static var moveDown:Array<Array<Texture>>= [];
	private static var death:Array<Array<Texture>>= [];
	private static var defaultAnim:Array<Array<Texture>>= [];
	private static var idle:Array<Array<Texture>>= [];
	
	
	public var node:Node;
	private var sprite:AnimatedSprite;
	private var bright:Sprite;

	
	private var active:Bool = false;
	
	
	private var prevValue:Int;
	
	private var idleTimer:Timer;
	
	public function new() 
	{
		super();
		this.initializeControls();
	}
	
	private function initializeControls():Void
	{
		
		var colors:Array<String> = ["blue", "green", "orange", "purple"];
		if (moveLeft.length == 0)
		{
			for ( color in colors)
			{
				var moveLeft = Asset.getTextures( Asset.getResource("img/block_" + color + ".json").data, new EReg("left/.*", ""));
				var moveRight = Asset.getTextures( Asset.getResource("img/block_" + color + ".json").data, new EReg("right/.*", ""));
				var moveTop = Asset.getTextures( Asset.getResource("img/block_" + color + ".json").data, new EReg("up/.*", ""));
				var moveDown = Asset.getTextures( Asset.getResource("img/block_" + color + ".json").data, new EReg("down/.*", ""));
				var death = Asset.getTextures( Asset.getResource("img/block_" + color + ".json").data, new EReg("death/.*", ""));
				var defaultAnim = Asset.getTextures( Asset.getResource("img/block_" + color + ".json").data, new EReg("default/.*", ""));
				var idle = Asset.getTextures( Asset.getResource("img/block_" + color + ".json").data, new EReg("idle/.*", ""));
				
				Block.moveLeft.push(moveLeft);
				Block.moveRight.push(moveRight);
				Block.moveTop.push(moveTop);
				Block.moveDown.push(moveDown);
				Block.death.push(death);
				Block.defaultAnim.push(defaultAnim);
				Block.idle.push(idle);
			}
		}
		
		
		this.bright = Asset.getImage("block_bright.png", true);
		
		
		this.sprite = new AnimatedSprite( moveLeft[0]);
		this.sprite.loop = true;
		this.sprite.gotoAndPlay(0);
		this.sprite.animationSpeed = 10 / 60;
		this.sprite.anchor.x = this.sprite.anchor.y = 0.5;
		this.sprite.x = -6;
		this.sprite.y = -6;
		this.scale.x = this.scale.y = 0;
		
		this.bright.anchor = sprite.anchor;
		this.bright.position = sprite.position;
		this.bright.alpha = 0;
		
		//TEMP SCALE
		sprite.width = sprite.height = GridControl.BLOCK_HEIGHT - 10 * 6 / GridLogic.GRID_HEIGHT;
		bright.width = bright.height = sprite.width;
		this.bright.blendMode = Pixi.BLEND_MODES.ADD;
		this.bright.alpha = 0.0;
		
		this.addChild(this.sprite);
		this.addChild(this.bright);
		this.interactive = true;
		this.addListener("click", onAnnoyClick);
	}
	
	private function restartIdleTimer():Void
	{
		if (this.idleTimer != null)
			this.idleTimer.stop();
		
		this.idleTimer = new Timer(250+Math.floor(Math.random()*5000));
		this.idleTimer.run = onIdleTick;
	}
	
	private function onIdleTick():Void
	{
		this.idleTimer.stop();
		if (this.prevValue >= 0 && prevValue < idle.length)
		{
			this.sprite.textures = idle[prevValue];
			this.sprite.loop = false;
			this.sprite.play();
			this.sprite.onComplete = function(){
				this.sprite.onComplete = null;
				this.sprite.textures = defaultAnim[prevValue];
				restartIdleTimer();
			};
		}
	}
	
	private function onAnnoyClick():Void
	{
		var os:Float = this.sprite.scale.x;
	//	Tween.get(this.sprite.scale).to({x: os * 1.25}, 390, Ease.quadInOut).to({x:os}, 40, Ease.quadInOut);
	//	Tween.get(this.sprite.scale).to({y: os * 1.25}, 450, Ease.quadInOut).to({y:os}, 80, Ease.quadInOut);
	}
	
	public function sync(middleStep:Bool)
	{
		var value:Int = node.value;
		if (active && node.value == -1)
		{
			//Destroyed. Sleep.
			
			this.active = false;
			sprite.textures = death[prevValue];
			this.sprite.play();
			this.bright.visible = true;
			this.bright.alpha = 0.0;
			Tween.get(this.bright).wait(200,true).to({alpha:0.5}, 150).to({alpha:0}, 50);
			Tween.removeTweens(this.scale);
			Tween.get(this.scale).wait(200,true).call(function(){
				ParticleManager.squares.spawn(ParticleManager.squares.toLocal(new Point(),this),[0x0000ff, 0x00ff00, 0xffff00, 0xffffff][prevValue]);
			}).to({x:0, y:0}, 250, Ease.quadIn);
		}
		else if (!active && node.value >= 0)
		{
			prevValue = node.value;
			this.sprite.textures = defaultAnim[value];
			
			this.sprite.play();
//			this.sprite.texture = textures[value];
			//New spawn
			this.active = true;
			this.x = node.x * GridControl.BLOCK_WIDTH + Math.max(0, node.x-1)*GridControl.SPACING + GridControl.BLOCK_WIDTH/2;
			this.y = node.y * GridControl.BLOCK_HEIGHT + Math.max(0, node.y - 1) * GridControl.SPACING + GridControl.BLOCK_HEIGHT / 2;
			Tween.removeTweens(this.scale);
			Tween.get(this.scale).to({x:1, y:1}, 250, Ease.getBackOut(0.35)).call(restartIdleTimer);
		}
		else if(active)
		{
			//this.sprite.texture = textures[value];
			this.sprite.textures = defaultAnim[value];
			
			//Move
			var tx:Float = node.x * GridControl.BLOCK_WIDTH + Math.max(0, node.x - 1) * GridControl.SPACING + GridControl.BLOCK_WIDTH / 2;
			var ty:Float = node.y * GridControl.BLOCK_HEIGHT + Math.max(0, node.y - 1) * GridControl.SPACING + GridControl.BLOCK_HEIGHT / 2;
			
			if (tx > this.x)
				this.sprite.textures = moveLeft[value];
			else if (tx < this.x)
				this.sprite.textures = moveRight[value];
			else if (ty > this.y)
				this.sprite.textures = moveTop[value];
			else if (ty < this.y)
				this.sprite.textures = moveDown[value];
			this.sprite.play();
			var dx:Float = Math.abs(tx - this.x);
			var dy:Float = Math.abs(ty - this.y);
			
			Tween.removeTweens(this);
			Tween.get(this).wait((middleStep?250:10)).to({
				x:tx,
				y:ty
			}, 350, Ease.bounceOut).call(function(){
				this.sprite.textures = defaultAnim[value];
				restartIdleTimer();
			});
		}
	}
}