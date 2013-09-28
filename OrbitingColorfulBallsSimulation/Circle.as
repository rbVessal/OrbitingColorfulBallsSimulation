package  
{
	
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	public class Circle extends MovieClip 
	{
		
		public var radius:int;
		public var position:Vector2;
		public function Circle(diameter:int, xPos:int, yPos:int) 
		{
			// constructor code
			x = xPos;
			y = yPos;
			width = diameter;
			height = diameter;
			radius = diameter/2;
			position = new Vector2(x, y);
			
			//Color transforms reflects the color of the movieclip graphics color
			/*var tempColor:ColorTransform = new ColorTransform();
			tempColor.color = color;
			this.transform.colorTransform = tempColor;*/
		}
	}
	
}
