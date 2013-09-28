package  
{
	import flash.display.MovieClip;
	
	public class Target extends MovieClip
	{
		private var _position:Vector2;
		private var _radius:Number;
		public function Target(aX:Number, aY:Number) 
		{
			// constructor code
			x = aX;
			y = aY;
			_position = new Vector2(x, y);
		}
		
		//Setters and getters for Target properties
		public function get position():Vector2
		{
			return _position;
		}
		public function get radius():Number
		{
			return _radius;
		}
		public function set position(pos:Vector2):void
		{
			_position = pos;
		}
		public function set radius(targetRadius:Number):void
		{
			_radius = targetRadius;
		}
	}
	
}
