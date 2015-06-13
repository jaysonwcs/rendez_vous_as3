package game.inventory 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Jayson
	 */
	public class Inventory extends FlxGroup 
	{
		private var background: FlxSprite;
		
		public function Inventory() 
		{
			super();
			
			background = new FlxSprite();
			background.makeGraphic(FlxG.width, FlxG.height, 0x7fffffff);
			background.scrollFactor.x = 0;
			background.scrollFactor.y = 0;
			add(background);
		}
		
		override public function update():void {
			
		}
		
		override public function add(Object:FlxBasic):FlxBasic {
			
			if (Object is Tool) {
				Tool(Object).x = 50;
				Tool(Object).y = 50;
				Tool(Object).scrollFactor.x = 0;
				Tool(Object).scrollFactor.y = 0;
			}
			
			return super.add(Object);
		}
		
	}

}