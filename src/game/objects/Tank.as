package game.objects 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Jayson
	 */
	public class Tank extends FlxSprite 
	{
		protected var _volume: Number;
		protected var _limit: Number;
		
		private var _volumeBar: FlxSprite;
		
		private var originalY: Number;
		private var originalHeight: Number;
		
		public function Tank(volume: Number, limit: Number, X:Number=0, Y:Number=0, isVertical: Boolean = false) 
		{
			super(X, Y);
			
			if (isVertical) {
				_volumeBar = new FlxSprite(x + 21, y + 4);
				_volumeBar.makeGraphic(2, 32, 0xff0000ff);
			} else {
				_volumeBar = new FlxSprite(x + 4, y + 21);
				_volumeBar.makeGraphic(32, 2, 0xff00ff00);
			}
			
			originalY = _volumeBar.y;
			originalHeight = volumeBar.height;
			
			_limit = limit;
			_volume = volume;
		}
		
		public function set volume(value:Number):void 
		{
			if (value <= 0)
				value = 0;
			else if (value >= _limit)
				value = _limit;
				
			_volume = value;
		}
		
		protected function drawBar(ratio: Number, isVertical: Boolean):void {
			if (isVertical) {
				_volumeBar.makeGraphic(2, Math.round(32 * ratio), 0xff0000ff);
				_volumeBar.y = originalY + originalHeight - volumeBar.height;
			} else
				_volumeBar.makeGraphic(Math.round(32 * ratio), 2, 0xff00ff00);
		}
		
		public function get volume():Number {
			return _volume;
		}
		
		public function get volumeBar():FlxSprite {
			return _volumeBar;
		}
		
	}

}