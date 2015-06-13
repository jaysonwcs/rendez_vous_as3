package game.objects 
{
	/**
	 * ...
	 * @author Jayson
	 */
	public class FuelTank extends Tank 
	{
		[Embed(source = '../../../assets/spritesheets/combustivel.png')] public static var fuelImg:Class;
		
		public function FuelTank(volume:Number, limit:Number, X:Number=0, Y:Number=0) 
		{
			super(volume, limit, X, Y);
			
			loadGraphic(fuelImg);
		}
		
		override public function set volume(value:Number):void 
		{
			super.volume = value;
			
			drawBar(_volume / _limit, false);
		}
	}

}