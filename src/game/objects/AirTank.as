package game.objects 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Jayson
	 */
	public class AirTank extends Tank 
	{
		[Embed(source = '../../../assets/spritesheets/ar.png')] public static var tankImg:Class;
		
		public function AirTank(volume: Number, limit: Number, X:Number=0, Y:Number=0) 
		{
			super(volume, limit, X, Y, true);
			
			loadGraphic(tankImg);
		}
		
		override public function set volume(value:Number):void 
		{
			super.volume = value;
			
			drawBar(_volume / _limit, true);
		}
	}

}