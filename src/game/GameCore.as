package game
{
	import flash.globalization.*;
	import flash.accessibility.Accessibility;
	import flash.system.*;
	import flash.utils.*;
	import game.enemies.Skewer;
	import game.enemies.SquareDetection;
	import game.inventory.Inventory;
	import gui.HudBar;
	import gui.Map;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Jayson
	 */
	public class GameCore extends FlxState 
	{
		//Main objects
		[Embed(source = '../../assets/musics/Space Atmosphere2.mp3')] public static var titleMusic:Class;
		
		public var player: MainCharacter;
		public var level: FlxTilemap;
		public var objectsMap: FlxTilemap;
		public var backgroundMap: FlxTilemap;
		public var gameCamera: FlxCamera;
		//public var controlHandler: FlxControlHandler;
		public var background: FlxSprite;
		private var _paused: Boolean;
		private var txtXVelocity: FlxText;
		private var txtYVelocity: FlxText;
		private var txtAir: FlxText;
		private var txtFuel: FlxText;
		private var txtVelocity: FlxText;
		private var txtDistance: FlxText;
		private var txtDangerSuit: FlxText;
		private var txtLeak: FlxText;
		
		private var suitDamageBar: HudBar;
		
		private var airBar: FlxSprite;
		private var airBarBase: FlxSprite;
		private var fuelBar: FlxSprite;
		private var fuelBarBase: FlxSprite;
		
		//Main Layers
		public var backgroundLayer: FlxGroup;
		public var gameLayer: FlxGroup;
		public var airTanksList: FlxGroup;
		public var fuelTanksList: FlxGroup;
		public var inventoryItemsList: FlxGroup;
		public var boxesList: FlxGroup;
		public var interfaceLayer: FlxGroup;
		public var enemiesList: FlxGroup;
		public var checkPointsList: FlxGroup;
		
		private var inventory: Inventory;
		private var directionV: FlxText;
		private var directionH: FlxText;
		private var vectorVelocity: Number;
		
		public var map: Map;
		
		private const DEATH_VELOCITY: Number = 300;
		private const WARNING_VELOCITY: Number = 150;
		
		private var hudFormatter: NumberFormatter;
		private var redBackground: FlxSprite;
		private var fadingOut:Boolean;
		
		public function GameCore() 
		{
			backgroundLayer = new FlxGroup();
			gameLayer = new FlxGroup();
			boxesList = new FlxGroup();
			interfaceLayer = new FlxGroup();
			inventoryItemsList = new FlxGroup();
			level = new FlxTilemap();
			objectsMap = new FlxTilemap();
			backgroundMap = new FlxTilemap();
			checkPointsList = new FlxGroup();
			enemiesList = new FlxGroup();
			inventory = new Inventory();
			airTanksList = new FlxGroup();
			fuelTanksList = new FlxGroup();
			
			redBackground = new FlxSprite();
			redBackground.scrollFactor.x = 0;
			redBackground.scrollFactor.y = 0;
			
			hudFormatter = new NumberFormatter(LocaleID.DEFAULT);
			hudFormatter.fractionalDigits = 3;
			hudFormatter.leadingZero = true;
			hudFormatter.trailingZeros = true;
		}
		
		override public function create():void
		{
			FlxG.worldBounds = new FlxRect(0, 0, level.width, level.height);
			
			setupLevel();
			
			add(backgroundLayer);
			add(gameLayer);
			add(interfaceLayer);
			
			gameLayer.add(level);
			gameLayer.add(inventoryItemsList);
			gameLayer.add(boxesList);
			gameLayer.add(airTanksList);
			gameLayer.add(fuelTanksList);
			//gameLayer.add(checkPoints);
			//gameLayer.add(enemies);
			
			backgroundLayer.add(backgroundMap);
			
			player = new MainCharacter(this, inventory);
			
			setupCamera();
			
			LevelGenerator.generateLevel(this);
			objectsMap.destroy();
			
			gameLayer.add(player);
			
			txtVelocity = new FlxText(10, 10, 200);
			txtVelocity.scrollFactor.x = 0;
			txtVelocity.scrollFactor.y = 0;
			interfaceLayer.add(txtVelocity);
			txtVelocity.text = "Velocidades:";
			
			txtXVelocity = new FlxText(10, 20, 200);
			txtXVelocity.scrollFactor.x = 0;
			txtXVelocity.scrollFactor.y = 0;
			interfaceLayer.add(txtXVelocity);
			txtXVelocity.text = Math.abs(player.velocity.x).toString();
			
			txtAir = new FlxText(10, 60, 200);
			txtAir.scrollFactor.x = 0;
			txtAir.scrollFactor.y = 0;
			interfaceLayer.add(txtAir);
			txtAir.text = player.airTime.toString();
			
			txtFuel = new FlxText(10, 70, 200);
			txtFuel.scrollFactor.x = 0;
			txtFuel.scrollFactor.y = 0;
			interfaceLayer.add(txtFuel);
			txtFuel.text = player.fuel.toString();
			
			airBarBase = new FlxSprite(txtAir.x + 79, txtAir.y + 1);
			airBarBase.makeGraphic(202, 7, 0x7fffffff);
			airBarBase.scrollFactor.x = 0;
			airBarBase.scrollFactor.y = 0;
			interfaceLayer.add(airBarBase);
			
			airBar = new FlxSprite(txtAir.x + 80, txtAir.y + 2);
			airBar.makeGraphic(200, 5, 0xff0000ff);
			airBar.scrollFactor.x = 0;
			airBar.scrollFactor.y = 0;
			interfaceLayer.add(airBar);
			
			fuelBarBase = new FlxSprite(txtFuel.x + 79, txtFuel.y + 1);
			fuelBarBase.makeGraphic(202, 7, 0x7fffffff);
			fuelBarBase.scrollFactor.x = 0;
			fuelBarBase.scrollFactor.y = 0;
			interfaceLayer.add(fuelBarBase);
			
			fuelBar = new FlxSprite(txtFuel.x + 80, txtFuel.y + 2);
			fuelBar.makeGraphic(200, 5, 0xff00ff00);
			fuelBar.scrollFactor.x = 0;
			fuelBar.scrollFactor.y = 0;
			interfaceLayer.add(fuelBar);
			
			//txtYVelocity = new FlxText(10, 20, 200);
			//txtYVelocity.scrollFactor.x = 0;
			//txtYVelocity.scrollFactor.y = 0;
			//interfaceLayer.add(txtYVelocity);
			//txtYVelocity.text = Math.abs(player.velocity.y).toString();
			//txtYVelocity.text = player.life.toString();
			
			directionH = new FlxText(10, 30, 200);
			directionH.scrollFactor.x = 0;
			directionH.scrollFactor.y = 0;
			interfaceLayer.add(directionH);
			
			directionV = new FlxText(10, 40, 200);
			directionV.scrollFactor.x = 0;
			directionV.scrollFactor.y = 0;
			interfaceLayer.add(directionV);
			
			txtDistance = new FlxText(70, 90, 200);
			txtDistance.scrollFactor.x = 0;
			txtDistance.scrollFactor.y = 0;
			interfaceLayer.add(txtDistance);
			
			txtDangerSuit = new FlxText(10, map.y + map.height + 5, 200);
			txtDangerSuit.scrollFactor.x = 0;
			txtDangerSuit.scrollFactor.y = 0;
			interfaceLayer.add(txtDangerSuit);
			
			txtLeak = new FlxText(10, txtDangerSuit.y + txtDangerSuit.height + 5, 200);
			txtLeak.scrollFactor.x = 0;
			txtLeak.scrollFactor.y = 0;
			interfaceLayer.add(txtLeak);
			txtLeak.text = "Vazamento";
			txtLeak.visible = false;
			
			suitDamageBar = new HudBar(0xffff0000, player, "suitDamage", 100, 1, 10, txtDangerSuit.y + 10);
			interfaceLayer.add(suitDamageBar);
			
			redBackground.makeGraphic(FlxG.width, FlxG.height, 0xffff0000);
			interfaceLayer.add(redBackground);
			redBackground.alpha = 0;
			
			FlxG.playMusic(titleMusic);
		}
		
		protected function setupLevel():void
		{
		}
		
		private function setupCamera():void {
			gameCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height, 1);
			
			gameCamera.follow(player, FlxCamera.STYLE_PLATFORMER);
			gameCamera.setBounds(0, 0, level.width, level.height);
			FlxG.addCamera(gameCamera);
		}
		
		override public function update():void {
			//if (Constants.isDebugBuild)
			//{
				//updateDebugMode();
			//}
			
			if (!isPaused)
			{
				if (FlxG.keys.X)
					FlxG.elapsed /= 8;
				
				super.update();
				
				vectorVelocity = Math.round(Math.sqrt(Math.pow(player.velocity.x, 2) + Math.pow(player.velocity.y, 2)));
				if (vectorVelocity > DEATH_VELOCITY)
					txtXVelocity.color = 0xffff0000;
				else if (vectorVelocity > WARNING_VELOCITY)
					txtXVelocity.color = 0xffffff00;
				else
					txtXVelocity.color = 0xffffffff;
				
				FlxG.collide(player, level, playerLevelColision);
				FlxG.collide(player, boxesList);
				FlxG.collide(boxesList, level);
				
				//txtXVelocity.text = Math.abs(player.velocity.x).toString();
				txtXVelocity.text = vectorVelocity.toString();
				
				if (player.velocity.x > 0) {
					directionH.text = "-> ";
				} else if (player.velocity.x < 0) {
					directionH.text = "<- ";
				} else
					directionH.text = "";
				
				directionH.text = directionH.text + Math.round(Math.abs(player.velocity.x)).toString();
				
				if (player.velocity.y > 0) {
					directionV.text = "V ";
				} else if (player.velocity.y < 0) {
					directionV.text = "A ";
				} else
					directionV.text = "";
				
				directionV.text = directionV.text + Math.round(Math.abs(player.velocity.y)).toString();
				
				txtAir.text = "Ar:";
				if ((player.airTime / player.AIRTIME * 200) >= 1)  {
					airBar.makeGraphic(player.airTime / player.AIRTIME * 200, 5, 0xff0000ff);
					airBar.visible = true;
					
					if ((player.airTime / player.AIRTIME) < 0.25)
						airBarBase.color = 0x7fffff00;
					else
						airBarBase.color = 0x7fffffff;
				}
				else {
					airBar.visible = false;
					airBarBase.color = 0x7fff0000;
				}
				
				txtFuel.text = "Combustível:";
				if ((player.fuel / player.FUEL * 200) >= 1) {
					fuelBar.makeGraphic(player.fuel / player.FUEL * 200, 5, 0xff00ff00);
					fuelBar.visible = true;
					
					if ((player.fuel / player.FUEL) < 0.25)
						fuelBarBase.color = 0x7fffff00;
					else
						fuelBarBase.color = 0x7fffffff;
				}
				else {
					fuelBar.visible = false;
					fuelBarBase.color = 0x7fff0000;
				}
				
				
				txtDistance.text = "Distância: " + Utils.formatWithZerosString(hudFormatter.formatNumber(new Number(Math.round(Math.sqrt(Math.pow(map.pos.x, 2) + Math.pow(map.pos.y, 2))) / 40)), 3, hudFormatter);
				
				txtDangerSuit.text = "Danos à roupa: " + Math.round(player.suitDamage).toString();
				
				if (player.suitDamage >= 100)
					txtLeak.visible = true;
					
				if (player.acceleration.x > 0 && !player.isTouching(FlxObject.RIGHT)) {
					player.impulse = true;
					player.acceleration.x = 0;
					player.velocity.x = 0;
				}
				if (player.acceleration.x < 0 && !player.isTouching(FlxObject.LEFT)) {
					player.impulse = true;
					player.acceleration.x = 0;
					player.velocity.x = 0;
				}
				if (player.acceleration.y > 0 && !player.isTouching(FlxObject.DOWN)) {
					player.impulse = true;
					player.acceleration.y = 0;
					player.velocity.y = 0;
				}
				if (player.acceleration.y < 0 && !player.isTouching(FlxObject.UP)) {
					player.impulse = true;
					player.acceleration.y = 0;
					player.velocity.y = 0;
				}
				
				if (FlxG.keys.justPressed("P") || FlxG.keys.justPressed("ESCAPE"))
					pause();
			}
			else
			{
				inventory.update();
				
				if (FlxG.keys.justPressed("P") || FlxG.keys.justPressed("ESCAPE"))
					unpause();
			}
		}
		
		private function playerLevelColision(obj1: FlxObject, obj2: FlxObject):void {
			if (player.isTouching(FlxObject.WALL) || player.isTouching(FlxObject.CEILING) || player.isTouching(FlxObject.FLOOR))
				if (vectorVelocity > DEATH_VELOCITY)
						player.kill();
				else if (vectorVelocity > WARNING_VELOCITY) {
					var dangerVelocityRange: Number = DEATH_VELOCITY - WARNING_VELOCITY;
					var dangerImpactRatio: Number = (vectorVelocity - dangerVelocityRange) / dangerVelocityRange;
					
					player.suitDamage += dangerImpactRatio * 100;
				}
			
			if (player.velocity.x > 0) {
				player.velocity.x -= 100;
				if (player.velocity.x < 0)
					player.velocity.x = 0;
			}
			else if (player.velocity.x < 0) {
				player.velocity.x += 100;
				if (player.velocity.x > 0)
					player.velocity.x = 0;
			}
			
			if (player.velocity.y > 0) {
				player.velocity.y -= 100;
				if (player.velocity.y < 0)
				player.velocity.y = 0;
			} else if (player.velocity.y < 0) {
				player.velocity.y += 100;
				if (player.velocity.y > 0)
				player.velocity.y = 0;
			}
			
			if (player.isTouching(FlxObject.RIGHT))
				player.acceleration.x = 100;
			
			if (player.isTouching(FlxObject.LEFT))
				player.acceleration.x = -100;
			
			if (player.isTouching(FlxObject.UP))
				player.acceleration.y = -100;
			
			if (player.isTouching(FlxObject.DOWN))
				player.acceleration.y = 100;
		}
		
		public function pause():void {
			_paused = true;
			
			FlxG.mouse.show();
			interfaceLayer.add(inventory);
			
			//FlxG.play(Assets.sfxPause);
			//if (Utils.playingGameMusic1)
				//FlxG.music.volume -= 0.8;
			//else
				//FlxG.music.volume -= 0.3;
		}
		
		public function unpause():void {
			_paused = false;
			FlxG.mouse.hide();
			interfaceLayer.remove(inventory);
			//FlxG.play(Assets.sfxPauseEnd);
			//if (Utils.playingGameMusic1)
				//FlxG.music.volume += 0.8;
			//else
				//FlxG.music.volume += 0.3;
		}
		
		public function updateDebugMode():void
		{
		}
		
		public function get isPaused():Boolean 
		{
			return _paused;
		}
		
		public function resetHud():void {
			//txtXVelocity.text = "0";
			//txtYVelocity.text = "3";
		}
		
		public function blinkRed(redBlinkingSpeed:Number):void {
			if (redBackground.alpha >= 1)
				fadingOut = true;
			else if (redBackground.alpha <= 0)
				fadingOut = false;
			
			if (fadingOut)
				redBackground.alpha -= redBlinkingSpeed;
			else if (!fadingOut)
				redBackground.alpha += redBlinkingSpeed;
		}
		
		public function resetBlinkRed():void {
			redBackground.alpha = 0;
		}
		
		public function set life(value:Number):void {
			txtYVelocity.text = value.toString();
		}
		
	}
}