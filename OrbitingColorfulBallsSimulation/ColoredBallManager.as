package  
{
	
	public class ColoredBallManager
	{
		//Constants
		public const RED_COLOR:uint = 0xff0000;
		public const ORANGE_COLOR:uint = 0xcc6600;
		public const YELLOW_COLOR:uint = 0xffff00;
		public const GREEN_COLOR:uint = 0x00ff00;
		public const BLUE_COLOR:uint = 0x0000ff;
		public const VIOLET_COLOR:uint = 0xff00ff;
		public const NUMBER_OF_COLORS:int = 6;
		//Properties
		public var ballColor:uint;
		private var colorCounter:int;
		public var _groupNumberCounter:int;
		public var _orbitGroupNumberCounter:int;
		//Arrays for keeping the colorful balls
		public var _redBallsArray:Array;
		public var _orangeBallsArray:Array;
		public var _yellowBallsArray:Array;
		public var _greenBallsArray:Array;
		public var _blueBallsArray:Array;
		public var _violetBallsArray:Array;
		//Convenience way to access the leaders
		public var _redBallLeader:Ball;
		public var _orangeBallLeader:Ball;
		public var _yellowBallLeader:Ball;
		public var _greenBallLeader:Ball;
		public var _blueBallLeader:Ball;
		public var _violetBallLeader:Ball;
		public var _leaderBallsArray:Array;
		//Convenience for accessing the center ball
		public var _centerBall:Ball;
		//Convenience for accessing the flow field
		private var _flowFieldMap:FlowField;
		
		
		public function ColoredBallManager() 
		{
			// constructor code
			colorCounter = 0;
			_orbitGroupNumberCounter = 0;
			trace("constructor");
			redBallsArray = new Array();
			orangeBallsArray = new Array();
			yellowBallsArray = new Array();
			greenBallsArray = new Array();
			blueBallsArray = new Array();
			violetBallsArray = new Array();
			
			
		}
		
		//Getter and setters for manager properties
		//Getters
		public function get redBallsArray():Array
		{
			return _redBallsArray;
		}
		public function get orangeBallsArray():Array
		{
			return _orangeBallsArray;
		}
		public function get yellowBallsArray():Array
		{
			return _yellowBallsArray;
		}
		public function get greenBallsArray():Array
		{
			return _greenBallsArray;
		}
		public function get blueBallsArray():Array
		{
			return _blueBallsArray;
		}
		public function get violetBallsArray():Array
		{
			return _violetBallsArray;
		}
		public function get redBallLeader():Ball
		{
			return _redBallLeader;
		}
		public function get orangeBallLeader():Ball
		{
			return _orangeBallLeader;
		}
		public function get yellowBallLeader():Ball
		{
			return _yellowBallLeader;
		}
		public function get greenBallLeader():Ball
		{
			return _greenBallLeader;
		}
		public function get blueBallLeader():Ball
		{
			return _blueBallLeader;
		}
		public function get violetBallLeader():Ball
		{
			return _violetBallLeader;
		}
		public function get centerBall():Ball
		{
			return _centerBall;
		}
		public function get groupNumberCounter():int
		{
			return _groupNumberCounter;
		}
		public function get flowFieldMap():FlowField
		{
			return _flowFieldMap;
		}
		public function get orbitGroupNumberCounter():int
		{
			return _orbitGroupNumberCounter;
		}
		public function get leaderBallsArray():Array
		{
			return _leaderBallsArray;
		}
		//Setters
		public function set redBallsArray(array:Array):void
		{
			_redBallsArray = array;
		}
		public function set orangeBallsArray(array:Array):void
		{
			_orangeBallsArray = array;
		}
		public function set yellowBallsArray(array:Array):void
		{
			_yellowBallsArray = array;
		}
		public function set greenBallsArray(array:Array):void
		{
			_greenBallsArray = array;
		}
		public function set blueBallsArray(array:Array):void
		{
			_blueBallsArray = array;
		}
		public function set violetBallsArray(array:Array):void
		{
			_violetBallsArray = array;
		}
		public function set redBallLeader(ball:Ball):void
		{
			_redBallLeader = ball;
		}
		public function set orangeBallLeader(ball:Ball):void
		{
			_orangeBallLeader = ball;
		}
		public function set yellowBallLeader(ball:Ball):void
		{
			_yellowBallLeader = ball;
		}
		public function set greenBallLeader(ball:Ball):void
		{
			_greenBallLeader = ball;
		}
		public function set blueBallLeader(ball:Ball):void
		{
			_blueBallLeader = ball;
		}
		public function set violetBallLeader(ball:Ball):void
		{
			_violetBallLeader = ball;
		}
		public function set centerBall(ball:Ball):void
		{
			_centerBall = ball;
		}
		public function set groupNumberCounter(number:int):void
		{
			_groupNumberCounter = number;
		}
		public function set flowFieldMap(map:FlowField):void
		{
			_flowFieldMap = map;
		}
		public function set orbitGroupNumberCounter(number:int):void
		{
			_orbitGroupNumberCounter = number;
		}
		public function set leaderBallsArray(array:Array):void
		{
			_leaderBallsArray = array;
		}
		
		//Generates the next color in the sequence
		//for the next ball being created
		public function giveNextColor():void
		{
			if(colorCounter == NUMBER_OF_COLORS)
			{
				colorCounter %= NUMBER_OF_COLORS;
			}
			switch(colorCounter)
			{
				case 0:
				{
					ballColor = RED_COLOR;
					break;
				}
				case 1:
				{
					ballColor = ORANGE_COLOR;
					break;
				}
				case 2:
				{
					ballColor = YELLOW_COLOR;
					break;
				}
				case 3:
				{
					ballColor = GREEN_COLOR;
					break;
				}
				case 4:
				{
					ballColor = BLUE_COLOR;
					break;
				}
				case 5:
				{
					ballColor = VIOLET_COLOR;
					break;
				}
				default:
				{
					break;
				}
			}
			colorCounter++;
		}
		
		//Create a function for storing the balls in their respective array
		public function storeBallInRespectiveArray(ball:Ball):void
		{
			switch(ball.ballColor)
			{
				case RED_COLOR:
				{
					_redBallsArray.push(ball);
					break;
				}
				case ORANGE_COLOR:
				{
					_orangeBallsArray.push(ball);
					break;
				}
				case YELLOW_COLOR:
				{
					_yellowBallsArray.push(ball);
					break;
				}
				case GREEN_COLOR:
				{
					_greenBallsArray.push(ball);
					break;
				}
				case BLUE_COLOR:
				{
					_blueBallsArray.push(ball);
					break;
				}
				case VIOLET_COLOR:
				{
					_violetBallsArray.push(ball);
				}
			}
		}
		
		//Make the first ball of each array the leader of the group
		public function makeFirstBallLeaderOfGroup():void
		{
			_redBallsArray[0].isLeader = true;
			_redBallLeader = _redBallsArray[0];
			
			_orangeBallsArray[0].isLeader = true;
			_orangeBallLeader = _orangeBallsArray[0];
			
			_yellowBallsArray[0].isLeader = true;
			_yellowBallLeader = _yellowBallsArray[0];
			
			_greenBallsArray[0].isLeader = true;
			_greenBallLeader = _greenBallsArray[0];
			
			_blueBallsArray[0].isLeader = true;
			_blueBallLeader = _blueBallsArray[0];
			
			_violetBallsArray[0].isLeader = true;
			_violetBallLeader = _violetBallsArray[0];
		}
		
		//Assign groups of balls their leader
		public function assignLeadersToRespectiveGroups():void
		{
			assignLeaderToRespectiveGroup(_redBallsArray);
			assignLeaderToRespectiveGroup(_orangeBallsArray);
			assignLeaderToRespectiveGroup(_yellowBallsArray);
			assignLeaderToRespectiveGroup(_greenBallsArray);
			assignLeaderToRespectiveGroup(_blueBallsArray);
			assignLeaderToRespectiveGroup(_violetBallsArray);
			
			createLeaderBallsArray();
		}
		
		private function createLeaderBallsArray():void
		{
			_leaderBallsArray = new Array();
			_leaderBallsArray.push(_redBallLeader);
			_leaderBallsArray.push(_orangeBallLeader);
			_leaderBallsArray.push(_yellowBallLeader);
			_leaderBallsArray.push(_greenBallLeader);
			_leaderBallsArray.push(_blueBallLeader);
			_leaderBallsArray.push(_violetBallLeader);
			
		}
		//Helper method for the one above it
		private function assignLeaderToRespectiveGroup(array:Array):void
		{
			for each(var ball:Ball in array)
			{
				if(!ball.isLeader)
				{
					switch(ball.ballColor)
					{
						case RED_COLOR:
						{
							ball.leaderBall = _redBallLeader;
							ball.leaderBall.position = new Vector2(100, 100);
							break;
						}
						case ORANGE_COLOR:
						{
							ball.leaderBall = _orangeBallLeader;
							ball.leaderBall.position = new Vector2(1000, 200);
							break;
						}
						case YELLOW_COLOR:
						{
							ball.leaderBall = _yellowBallLeader;
							ball.leaderBall.position  = new Vector2(100, 800);
							break;
						}
						case GREEN_COLOR:
						{
							ball.leaderBall = _greenBallLeader;
							ball.leaderBall.position = new Vector2(100, 700);
							break;
						}
						case BLUE_COLOR:
						{
							ball.leaderBall = _blueBallLeader;
							ball.leaderBall.position = new Vector2(1100, 800);
							break;
						}
						case VIOLET_COLOR:
						{
							ball.leaderBall = _violetBallLeader;
							ball.leaderBall.position = new Vector2(1100, 100);
							break;
						}
						default:
						{
							break;
						}
						
					}
				}
			}
		}
		
		//Helps get rid of repetitive calls to move the colorful balls in
		//Document class
		public function moveColorfulBalls(dt:Number):void
		{
			helpMoveColorfulBalls(_redBallsArray, dt);
			helpMoveColorfulBalls(_orangeBallsArray, dt);
			helpMoveColorfulBalls(_yellowBallsArray, dt);
			helpMoveColorfulBalls(_greenBallsArray, dt);
			helpMoveColorfulBalls(_blueBallsArray, dt);
			helpMoveColorfulBalls(_violetBallsArray, dt);
		}
		//Helper method for the one above it
		private function helpMoveColorfulBalls(array:Array, dt:Number):void
		{
			for each(var ball:Ball in array)
			{
				ball.update(dt);
			}
		}
		
		//Check to see which colorful ball group has all of the members 
		//gathered first, second, and so forth
		public function determineGroupNumber():void
		{
			splitBallsByColor(_redBallsArray);
			splitBallsByColor(_orangeBallsArray);
			splitBallsByColor(_yellowBallsArray);
			splitBallsByColor(_greenBallsArray);
			splitBallsByColor(_blueBallsArray);
			splitBallsByColor(_violetBallsArray);
		}
		
		//Helper method for the one above it
		private function splitBallsByColor(arrayOfBalls:Array):void
		{
			var allTogetherFlag:Boolean = false;
			for(var i:int = 0; i < arrayOfBalls.length; i++)
			{
				var ball:Ball = arrayOfBalls[i];
				if(!ball.isLeader)
				{
					if(ball.hitTestObject(ball.leaderBall))
					{
						allTogetherFlag = true;
					}
					else
					{
						allTogetherFlag = false;
						break;
					}
				}
				if(i == arrayOfBalls.length -1)
				{
					if(allTogetherFlag)
					{
						if(!ball.leaderBall.isGroupNumberAssigned)
						{
							if(_groupNumberCounter > 0 && _groupNumberCounter < NUMBER_OF_COLORS)
							{
								ball.leaderBall.groupNumber = _groupNumberCounter;
								ball.leaderBall.isGroupNumberAssigned = true;
								reportGroupNumber(ball.leaderBall);
								_groupNumberCounter++;
							}
							else
							{
								_groupNumberCounter = 0;
								ball.leaderBall.groupNumber = _groupNumberCounter;
								ball.leaderBall.isGroupNumberAssigned = true;
								reportGroupNumber(ball.leaderBall);
								_groupNumberCounter++;
								
							}
						}
					}
				}
			}
			
		}
		
		//Report the group number
		private function reportGroupNumber(ball:Ball):void
		{
			var colorString:String = "";
			switch(ball.ballColor)
			{
				case RED_COLOR:
				{
					colorString = "Red"
					trace(ball.groupNumber + colorString);
					break;
				}
				case ORANGE_COLOR:
				{
					colorString = "Orange";
					trace(ball.groupNumber + colorString);
					break;
				}
				case YELLOW_COLOR:
				{
					colorString = "Yellow";
					trace(ball.groupNumber + colorString);
					break;
				}
				case GREEN_COLOR:
				{
					colorString = "Green";
					trace(ball.groupNumber + colorString);
					break;
				}
				case BLUE_COLOR:
				{
					colorString = "Blue";
					trace(ball.groupNumber + colorString);
					break;
				}
				case VIOLET_COLOR:
				{
					colorString = "Violet";
					trace(ball.groupNumber + colorString);
					break;
				}
			}
		}
		
		//Create a convience method for getting back a group based on group number
		public function giveRespectiveArrayBasedOnGroupNumber(groupNumber:int):Array
		{
			var ball:Ball;
			for each(var leaderBall:Ball in _leaderBallsArray)
			{
				if(leaderBall.groupNumber == groupNumber)
				{
					ball = leaderBall;
					break;
				}
			}
			
			return giveRespectiveArrayBasedOnColor(ball);
		}
		
		//Create a convience method for giving back the appropriate array
		//based on color
		public function giveRespectiveArrayBasedOnColor(ball:Ball):Array
		{
			switch(ball.ballColor)
			{
				case RED_COLOR:
				{
					return _redBallsArray;
				}
				case ORANGE_COLOR:
				{
					return _orangeBallsArray;
				}
				case YELLOW_COLOR:
				{
					return _yellowBallsArray;
				}
				case GREEN_COLOR:
				{
					return _greenBallsArray;
				}
				case BLUE_COLOR:
				{
					return _blueBallsArray;
				}
				case VIOLET_COLOR:
				{
					return _violetBallsArray;
				}
				default:
				{
					break;
				}
			}
			return null;
		}

	}
	
}
