package 
{
	import flash.utils.*;
	import game.*;
	import game.enemies.Skewer;
	import game.levels.*;
	import game.objects.AirTank;
	import game.objects.FuelTank;
	import gui.Map;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Jayson
	 */
	public class LevelGenerator 
	{
		private static var map: FlxTilemap;
		private static var state: GameCore;
		
		private var level1: Level1;
		
		
		public static function generateLevel(level:GameCore):void {
			LevelGenerator.state = level;
			LevelGenerator.map = state.objectsMap;
			
			startPlayerPos();
			airTanks();
			fuelTanks();
			radar();
		}
		
		static private function radar():void {
			var dotPositions: Array;
			var totalPositions: Array = new Array();
			
			for (var i:int = 1; i < 60; i++) 
			{
				dotPositions = state.level.getTileCoords(i, false);
			
				if (dotPositions != null)
				{
					for each (var pos: FlxPoint in dotPositions) 
					{
						totalPositions.push(pos);
					}
				}
			}
				
			state.map = new Map(10, 90, state, totalPositions);
			state.interfaceLayer.add(state.map);
			state.interfaceLayer.add(state.map.player);
			state.interfaceLayer.add(state.map.bussola);
		}
		
		static private function fuelTanks():void {
			var fuelTanks: Array = state.objectsMap.getTileCoords(3, false);
			var fuelTank: FuelTank;
			
			if (fuelTanks != null)
			{
				for each (var pos: FlxPoint in fuelTanks) 
				{
					fuelTank = new FuelTank(75, 75, pos.x, pos.y);
					state.fuelTanksList.add(fuelTank);
					state.gameLayer.add(fuelTank.volumeBar);
				}
			}
		}
		
		static private function airTanks():void {
			var airTanks: Array = state.objectsMap.getTileCoords(2, false);
			var airTank: AirTank;
			
			if (airTanks != null)
			{
				for each (var pos: FlxPoint in airTanks) 
				{
					airTank = new AirTank(1500, 1500, pos.x, pos.y);
					state.airTanksList.add(airTank);
					state.gameLayer.add(airTank.volumeBar);
				}
			}
		}
		
		static public function startPlayerPos():void 
		{
			var players: Array = state.objectsMap.getTileCoords(1, false);
			
			if (players != null)
			{
				for each (var pos: FlxPoint in players) 
				{
					state.player.x = pos.x;
					state.player.y = pos.y;
				}
			}
		}
	}

}