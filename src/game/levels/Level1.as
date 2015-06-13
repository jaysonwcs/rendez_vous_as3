package game.levels 
{
	import game.*;
	import game.inventory.Tool;
	import game.objects.Box;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Jayson
	 */
	public class Level1 extends GameCore 
	{
		[Embed(source = '../../../assets/levels/mapCSV_Group1_map.csv', mimeType = 'application/octet-stream')] public static var level1Csv:Class;
		[Embed(source = '../../../assets/levels/mapCSV_Group1_obj.csv', mimeType = 'application/octet-stream')] public static var obj1Csv:Class;
		[Embed(source = '../../../assets/levels/mapCSV_Group1_back.csv', mimeType = 'application/octet-stream')] public static var back1Csv:Class;
		[Embed(source = '../../../assets/tilesets/tileset.png')] public static var tilesetImg:Class;
		[Embed(source = '../../../assets/tilesets/tileset_back.png')] public static var tilesetBackImg:Class;
		[Embed(source = '../../../assets/backgrounds/sunshine.png')] public static var backgroundImg:Class;
		
		//private const SCROOLFACTOR_BACK: Number = 0.04;
		private const SCROOLFACTOR_BACK: Number = 0;
		
		public function Level1() 
		{
			super();
			
			var backgroundSprite: FlxSprite = new FlxSprite(0, 0, backgroundImg);
			backgroundLayer.add(backgroundSprite);
			backgroundSprite.scrollFactor.x = SCROOLFACTOR_BACK;
			backgroundSprite.scrollFactor.y = SCROOLFACTOR_BACK;
			
			backgroundMap.loadMap(new back1Csv(), tilesetBackImg, 40, 40);
			level.loadMap(new level1Csv(), tilesetImg, 40, 40, FlxTilemap.OFF, 0, 1, 1);
			objectsMap.loadMap(new obj1Csv(), tilesetImg, 40, 40, FlxTilemap.OFF, 0, 1, 1);
			//backgroundMap.loadMap(new Assets.level7BackCsv, Assets.tilesetBackImg, 20, 20, FlxTilemap.OFF, 0, 1, 1);
			
			var tool: Tool = new Tool(200, 200);
			inventoryItemsList.add(tool);
			
			var box: Box = new Box(500, 500);
			boxesList.add(box);
		}
		
	}

}