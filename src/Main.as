package 
{
	import flash.events.*;
	import org.flixel.*;
	import game.*;
	import game.levels.*;
	
	[SWF(width="800", height="480", backgroundColor="#000000")]
	[Frame(factoryClass = "Preloader")]
	
	/**
	 * ...
	 * @author Jayson
	 */
	public class Main extends FlxGame 
	{
		public static var gameSave: FlxSave;
		private var PULLATOR: String = "Pullator";
		private static var _game: FlxGame;
		private var error: Boolean;
		
		public function Main():void 
		{
			_game = this;
			
			error = false;
			
			if (CONFIG::debug)
			{
				//Força modo debug do Flixel
				forceDebugger = true;
				FlxG.debug = true;
			}
			
			gameSave = new FlxSave();
			gameSave.bind(PULLATOR);
			
			super(800, 480, Level1, 1, 30, 30);
		}
		
		public static function get game():FlxGame {
			return _game;
		}
		
	}
	
}