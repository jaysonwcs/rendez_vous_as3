package game.inventory 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Jayson
	 */
	public class Tool extends FlxSprite 
	{
		
		
		public function Tool(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			makeGraphic(40, 40, 0xff681268);
		}
		
	}

}