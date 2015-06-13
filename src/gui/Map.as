package gui 
{
	import flash.text.engine.FontDescription;
	import game.GameCore;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Jayson
	 */
	public class Map extends FlxSprite 
	{
		private var _bussola: FlxSprite;
		private var _player: FlxSprite;
		private var gameCore: GameCore;
		
		private var center: FlxPoint = new FlxPoint();
		public var pos: FlxPoint = new FlxPoint();
		
		private const WIDTH: Number = 50;
		private const HEIGHT: Number = 50;
		private const BUSSOLA_COLOR: Number = 0x7f00ff00;
		private const TILE_SIZE: Number = 1;
		private const TILE_COLOR: Number = 0xff00ff00;
		
		private var bussolaArray: Array;
		private var posArray: Array;
		
		
		public function Map(X: Number, Y: Number, gameCore: GameCore, posArray: Array) 
		{
			super(X, Y);
			
			this.gameCore = gameCore;
			
			_bussola = new FlxSprite();
			bussola.makeGraphic(5, 5, BUSSOLA_COLOR);
			bussola.scrollFactor.x = 0;
			bussola.scrollFactor.y = 0;
			
			this.posArray = posArray;
			
			var point: FlxSprite;
			bussolaArray = new Array();
			
			for each (var pos: FlxPoint in posArray) 
			{
				point = new FlxSprite();
				point.scrollFactor.x = 0;
				point.scrollFactor.y = 0;
				point.makeGraphic(1, 1, 0x7f0000ff);
				gameCore.interfaceLayer.add(point);
				this.bussolaArray.push(point);
			}
			
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			makeGraphic(WIDTH, HEIGHT, 0x00000000);
			
			_player = new FlxSprite(x + width / 2, y + height / 2);
			_player.makeGraphic(3, 3, 0xffffffff);
			_player.x -= _player.width / 2;
			_player.y -= _player.height / 2;
			_player.scrollFactor.x = 0;
			_player.scrollFactor.y = 0;
		}
		
		override public function update():void {
			super.update();
			
			center.x = gameCore.level.width / 2
			center.y = gameCore.level.height / 2;
			
			pos.x = center.x - gameCore.player.x
			pos.y = center.y - gameCore.player.y;
			
			if (gameCore.player.x < gameCore.level.width && gameCore.player.x > 0)
				bussola.x = (pos.x / gameCore.level.width) * WIDTH * 2 + x + (WIDTH / 2) - (bussola.width / 2);
			else if (gameCore.player.x <= 0) {
				bussola.x = x + width - (bussola.width / 2);
				bussola.makeGraphic(5, 5, 0x7fff0000);
			}
			else {
				bussola.x = x - (bussola.width / 2);
				bussola.makeGraphic(5, 5, 0x7fff0000);
			}
			
			if (gameCore.player.y < gameCore.level.height && gameCore.player.y > 0)
				bussola.y = (pos.y / gameCore.level.height) * HEIGHT * 2 + y + (HEIGHT / 2) - (bussola.height / 2);
			else if (gameCore.player.y <= 0) {
				bussola.makeGraphic(5, 5, 0x7fff0000);
				bussola.y = y + height - (bussola.height / 2);
			}
			else {
				bussola.makeGraphic(5, 5, 0x7fff0000);
				bussola.y = y - (bussola.height / 2);
			}
			
			if (gameCore.player.x < gameCore.level.width && gameCore.player.x > 0
				&& gameCore.player.y < gameCore.level.height && gameCore.player.y > 0)
					bussola.makeGraphic(5, 5, BUSSOLA_COLOR);
					
			for (var i:int = 0; i < bussolaArray.length; i++) {
				updatePoint(bussolaArray[i], posArray[i]);
			}
		}
		
		private function updatePoint(point:FlxSprite, tilePos:FlxPoint):void {
			var pos: FlxPoint = new FlxPoint();
			
			pos.x = tilePos.x - gameCore.player.x
			pos.y = tilePos.y - gameCore.player.y;
			
			if (gameCore.player.x < gameCore.level.width && gameCore.player.x > 0)
				point.x = (pos.x / gameCore.level.width) * WIDTH * 2 + x + (width / 2) - (point.width / 2);
			else if (gameCore.player.x <= 0) {
				point.x = x + width - (point.width / 2);
				point.makeGraphic(TILE_SIZE, TILE_SIZE, TILE_COLOR);
			}
			else {
				point.x = x - (point.width / 2);
				point.makeGraphic(TILE_SIZE, TILE_SIZE, TILE_COLOR);
			}
			
			if (gameCore.player.y < gameCore.level.height && gameCore.player.y > 0)
				point.y = (pos.y / gameCore.level.height) * HEIGHT * 2 + y + (height / 2) - (point.height / 2);
			else if (gameCore.player.y <= 0) {
				point.makeGraphic(TILE_SIZE, TILE_SIZE, TILE_COLOR);
				point.y = y + height - (point.height / 2);
			}
			else {
				point.makeGraphic(TILE_SIZE, TILE_SIZE, TILE_COLOR);
				point.y = y - (point.height / 2);
			}
			
			if (gameCore.player.x < gameCore.level.width && gameCore.player.x > 0
				&& gameCore.player.y < gameCore.level.height && gameCore.player.y > 0)
					point.makeGraphic(TILE_SIZE, TILE_SIZE, TILE_COLOR);
		}
		
		public function get bussola():FlxSprite 
		{
			return _bussola;
		}
		
		public function get player():FlxSprite 
		{
			return _player;
		}
		
	}

}