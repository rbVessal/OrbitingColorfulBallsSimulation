package  
{
	import flash.display.MovieClip;
	
	public class DonutHole extends MovieClip
	{
		var _innerCircle:Circle;
		var _outerCircle:Circle;
		public function DonutHole(innerDiameter:int, outerDiameter:int, document:Document, manager:ColoredBallManager) 
		{
			// constructor code
			var centerX = document.stage.stageWidth/2;
			var centerY = document.stage.stageHeight/2;
			
			//Create the inner and outer circle
			_innerCircle = new Circle(innerDiameter, centerX, centerY);
			_outerCircle = new Circle(outerDiameter, centerX, centerY);
			
			//Add it onto the screen
			addChild(_innerCircle);
			addChild(_outerCircle);
		}
		
		//Getters and setters
		public function get innerCircle():Circle
		{
			return _innerCircle;
		}
		public function get outerCircle():Circle
		{
			return _outerCircle;
		}
		public function set innerCircle(circle:Circle):void
		{
			_innerCircle = circle;
		}
		public function set outerCircle(circle:Circle):void
		{
			_outerCircle = circle;
		}

	}
	
}
