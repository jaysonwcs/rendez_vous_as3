package game.objects 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Jayson
	 */
	public class Box extends FlxSprite 
	{
		
		public function Box(X:Number=0, Y:Number=0) 
		{
			super(X, Y);
			makeGraphic(40, 40, 0xff00ff00);
		}
		
	}

}