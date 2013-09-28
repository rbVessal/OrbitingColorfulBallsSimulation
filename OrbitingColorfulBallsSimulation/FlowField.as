package  
{
	import flash.geom.ColorTransform;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class FlowField
	{
		//Constant
		private const MAX_SPEED_OF_FLOW_FIELD_ARROW:int = 60;
		public var document:Document;
		public var _centerVector:Vector2;
		private var _manager:ColoredBallManager;
		
		private var _fieldMapArray:Array;
		private var _columns:int;
		private var _rows:int;
		//Number of pixels in which each flow field arrow is populated in
		private var _resolution:int;
		private var _innerCircleArrayOfFlowFieldArrows:Array;
		private var _outerCircleArrayOfFlowFieldArrows:Array;
		private var _donutHoleArray:Array;
		private var _innerDiameter:int;
		private var _outerDiameter:int;
		private var _generateNextInnerRing:Boolean;
		private var _isClockwiseOrbit:Boolean;
		private var _isVisible:Boolean;
		
		
		public function FlowField(aDocument:Document, aMan:ColoredBallManager) 
		{
			// constructor code
			document = aDocument;
			_manager = aMan;
			_resolution = 15;
			_columns = document.stage.stageWidth/resolution;
			_rows = document.stage.stageHeight/resolution;
			trace("Columns: " + _columns);
			trace("Rows: " + _rows);
			
			//Define the field map
			_fieldMapArray = new Array();
			
			_centerVector = new Vector2(document.stage.stageWidth/2, document.stage.stageHeight/2);
			
			_innerCircleArrayOfFlowFieldArrows = new Array();
			_outerCircleArrayOfFlowFieldArrows = new Array();
			
			//Draw the flow field to point to the center
			drawFlowFields();
			
			_innerDiameter = 50;
			_outerDiameter = _innerDiameter + 90;
			
			_donutHoleArray = new Array();
			_generateNextInnerRing = true;
			_isClockwiseOrbit = true;
			
			document.stage.addEventListener(KeyboardEvent.KEY_DOWN, toggleFlowFieldVisibility);
			_isVisible = true;
		}
		
		//Getters and setters
		public function get manager():ColoredBallManager
		{
			return _manager;
		}
		public function get fieldMapArray():Array
		{
			return _fieldMapArray;
		}
		public function get resolution():int
		{
			return _resolution;
		}
		public function get innerCircleArrayOfFlowFieldArrows():Array
		{
			return _innerCircleArrayOfFlowFieldArrows;
		}
		public function get outerCircleArrayOfFlowFieldArrows():Array
		{
			return _outerCircleArrayOfFlowFieldArrows;
		}
		public function get donutHoleArray():Array
		{
			return _donutHoleArray;
		}
		public function get innerDiameter():int
		{
			return _innerDiameter;
		}
		public function get outerDiameter():int
		{
			return _outerDiameter;
		}
		public function get generateNextInnerRing():Boolean
		{
			return _generateNextInnerRing;
		}
		public function set manager(man:ColoredBallManager):void
		{
			_manager = man;
		}
		public function set fieldMapArray(array:Array):void
		{
			_fieldMapArray = array;
		}
		public function set columns(number:int):void
		{
			_columns = number;
		}
		public function set rows(number:int):void
		{
			_rows = number;
		}
		public function set resolution(number:int):void
		{
			_resolution = number;
		}
		public function set innerCircleArrayOfFlowFieldArrows(array:Array):void
		{
			_innerCircleArrayOfFlowFieldArrows = array;
		}
		public function set outerCircleArrayOfFlowFieldArrows(array:Array):void
		{
			_outerCircleArrayOfFlowFieldArrows = array;
		}
		public function set donutHoleArray(array:Array):void
		{
			_donutHoleArray = array;
		}
		public function set innerDiameter(diameter:int):void
		{
			_innerDiameter = diameter;
		}
		public function set outerDiameter(diameter:int):void
		{
			_outerDiameter = diameter;
		}
		public function set generateNextInnerRing(createRing:Boolean):void
		{
			_generateNextInnerRing = createRing;
		}
		
		//Draw a the desired flow field
		private function drawFlowFields():void
		{
			var vectorPointingToCenter:Vector2;
			//General formula for creating a circle
			//cos(angle) * radius and sin(angle)*radius
			trace("Field Map Array: " + _fieldMapArray.length);
			for(var i:int = 0; i < _columns; i++)
			{
				_fieldMapArray[i] = new Array();
				//var rowsArray:Array = new Array();
				for(var j:int = 0; j < _rows; j++)
				{
					//Create an arrow in a spot of the 2d grid
					var flowFieldArrow:FlowFieldArrow = new FlowFieldArrow(i * _resolution, j * _resolution);
					//Make flow field arrows point towards the center
					vectorPointingToCenter = Vector2.subtract(_centerVector, flowFieldArrow.position);
					flowFieldArrow.turnAbs(vectorPointingToCenter.angle);
					//Set their direction force by the max speed
					flowFieldArrow.directionForce = Vector2.multiply(flowFieldArrow.fwd, MAX_SPEED_OF_FLOW_FIELD_ARROW);
					//Store the arrow into the array
					_fieldMapArray[i][j] = flowFieldArrow;
					//Add it onto the stage
					document.addChild(flowFieldArrow);
					flowFieldArrow.visible = false;
				}
			}
			//Manipulate a circle of flow field arrows to be pointing in
			//a clockwise direction
			//selectCircleOfFlowFieldArrows();
		}
		
		//Finds the flow field arrow in the location of the ball in the flow
		//field map
		public function lookUpArrowInFieldMap(locationOfBall:Vector2):FlowFieldArrow
		{
			var column:int = locationOfBall.x/_resolution;
			var row:int = locationOfBall.y/_resolution;
			var testArrow:FlowFieldArrow;
			if(column <= _columns-1 && row <= _rows-1 && column >=0 && row >=0)
			{
				 testArrow = _fieldMapArray[column][row];
				 return testArrow;
			}
			return null;
		}
		
		//Selects a circle of flow field arrows
		public function selectCircleOfFlowFieldArrows():void
		{
			//trace("select circle");
			//Increase the diameter after the first inner ring is made
			//and all of the first group of balls is in that inner ring
			if(manager.orbitGroupNumberCounter > 0)
			{
				innerDiameter = outerDiameter + 40;
				outerDiameter += 170;
			}
			//Create 6 donut holes for 6 rings - 3 for clockwise and 3 for counterclockwise
			var donutHole:DonutHole = new DonutHole(innerDiameter, outerDiameter, document, manager);
			document.addChild(donutHole);
			//Find arrows in donut and place them in the appropriate arrays
			findArrowsInDonut(donutHole);
			//Change directions of flow field arrows to orbit
			if(_isClockwiseOrbit)
			{
				changeDirectionToOrbit(_isClockwiseOrbit);
				_isClockwiseOrbit = false;
			}
			else
			{
				changeDirectionToOrbit(_isClockwiseOrbit);
				_isClockwiseOrbit = true;
			}
			
			_donutHoleArray.push(donutHole);
			_outerCircleArrayOfFlowFieldArrows.length = 0;
			_innerCircleArrayOfFlowFieldArrows.length = 0;
			
			
		}
		
		//Find arrows in donut
		private function findArrowsInDonut(donutHole:DonutHole):void
		{
			for(var i:int = 0; i < _columns; i++)
			{
				for(var j:int = 0; j < _rows; j++)
				{
					//Get the flow field arrow out of the array
					var flowFieldArrow:FlowFieldArrow = _fieldMapArray[i][j];
					//Check to see if it intersects the inner circle
					if(donutHole.innerCircle.hitTestPoint(flowFieldArrow.x, flowFieldArrow.y, true))
					{
						_innerCircleArrayOfFlowFieldArrows.push(flowFieldArrow);
					}
					else if(donutHole.outerCircle.hitTestPoint(flowFieldArrow.x, flowFieldArrow.y, true))
					{
						_outerCircleArrayOfFlowFieldArrows.push(flowFieldArrow);
					}
					
				}
			}
		}
		
		//Make orbit pattern
		private function changeDirectionToOrbit(isClockwise:Boolean):void
		{
			//var angle:int = 0;
			for each(var flowFieldArrow:FlowFieldArrow in _outerCircleArrayOfFlowFieldArrows)
			{
				var perpRight:Vector2 = flowFieldArrow.fwd.perpRight();
				if(isClockwise)
				{
					perpRight.timesEquals(-1);
				}
				flowFieldArrow.turnAbs(perpRight.angle);
				flowFieldArrow.directionForce = Vector2.multiply(flowFieldArrow.fwd, MAX_SPEED_OF_FLOW_FIELD_ARROW);
				
			}
		}
		
		//Trigger the visibility of the flow field with a spacebar
		private function toggleFlowFieldVisibility(keyboardEvent:KeyboardEvent):void
		{
			if(keyboardEvent.keyCode == Keyboard.SPACE)
			{
				if(!_isVisible)
				{
					_isVisible = true;
					triggerFlowFieldVisibility(_isVisible);
				}
				else
				{
					_isVisible = false;
					triggerFlowFieldVisibility(_isVisible);
				}
			}
		}
		
		private function triggerFlowFieldVisibility(visiblity:Boolean):void
		{
			for(var i:int = 0; i < _columns; i++)
			{
				for(var j:int = 0; j < _rows; j++)
				{
					_fieldMapArray[i][j].visible = visiblity;
				}
			}
		}

	}
	
}
