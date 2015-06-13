package game.levels 
{
	import game.GameCore;
	
	/**
	 * ...
	 * @author Jayson
	 */
	public class Level2 extends GameCore 
	{
		
		public function Level2() 
		{
		[Embed(source = '../../../assets/levels/2/mapCSV_Group1_Map1.csv', mimeType = 'application/octet-stream')] public static var level1Csv:Class;
		[Embed(source = '../../../assets/levels/2/mapCSV_Group1_Map2.csv', mimeType = 'application/octet-stream')] public static var obj1Csv:Class;
		[Embed(source = '../../../assets/tilesets/tileset.png')] public static var tilesetImg:Class;
		[Embed(source = '../../../assets/backgrounds/sunshine.png')] public static var backgroundImg:Class;
		
		//private const SCROOLFACTOR_BACK: Number = 0.04;
		private const SCROOLFACTOR_BACK: Number = 0;
		
		public function Level2() 
		{
			super();
			
			var backgroundSprite: FlxSprite = new FlxSprite(0, 0, backgroundImg);
			backgroundLayer.add(backgroundSprite);
			backgroundSprite.scrollFactor.x = SCROOLFACTOR_BACK;
			backgroundSprite.scrollFactor.y = SCROOLFACTOR_BACK;
			
			level.loadMap(new level1Csv(), tilesetImg, 40, 40, FlxTilemap.OFF, 0, 1, 1);
			objectsMap.loadMap(new obj1Csv(), tilesetImg, 40, 40, FlxTilemap.OFF, 0, 1, 1);
			//backgroundMap.loadMap(new Assets.level7BackCsv, Assets.tilesetBackImg, 20, 20, FlxTilemap.OFF, 0, 1, 1);
			
			
		}
		
	}

}