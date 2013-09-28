package  
{
	
	import flash.display.MovieClip;
	
	
	public class FlowFieldArrow extends MovieClip
	{
		private var _position:Vector2;
		private var _fwd:Vector2;
		private var _directionForce:Vector2;
		public function FlowFieldArrow(aX:Number, aY:Number) 
		{
			// constructor code
			x = aX;
			y = aY;
			_position = new Vector2(x, y);
			_fwd = new Vector2(1, 0);
		}
		
		//Getters and setters
		public function get position():Vector2
		{
			return _position;
		}
		public function get fwd():Vector2
		{
			return _fwd;
		}
		public function get directionForce():Vector2
		{
			return _directionForce;
		}
		public function set position(pos:Vector2):void
		{
			_position.x = pos.x;
			_position.y = pos.y;
			x = pos.x;
			y = pos.y;
		}
		public function set fwd(forward:Vector2):void
		{
			_fwd.x = forward.x;
			_fwd.y = forward.y;
			_fwd.normalize( );
			rotation = _fwd.angle;
		}
		public function set directionForce(force:Vector2):void
		{
			_directionForce = force;
		}
		
		//-----------------ROTATION-----------------//
		
		// rotate the arrow to face an absolute angle
		// rotation  here is a property inherited from MovieClip
		// degToVector returns a unit vector whose direction
		// corresponds to the set rotation
		public function turnAbs(ang: Number): void
		{
			rotation = ang;
			_fwd = Vector2.degToVector(rotation);
		}
		
	}
	
}
