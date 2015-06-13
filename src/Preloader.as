package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import org.flixel.system.FlxPreloader;
	import org.flixel.FlxSprite;

	public class Preloader extends FlxPreloader
	{
		public function Preloader()
		{
			className = "Main";
			
			//Tem que mudar a className e acrescentar o nome da biblioteca pra funcionar no FlashDevelop
			super();
		}
		
	}
}