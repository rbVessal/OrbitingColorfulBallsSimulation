package  
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class Document extends MovieClip
	{
		private const MIN_NUMBER_OF_BALLS:int = 13;
		private const MAX_NUMBER_OF_BALLS:int = 70;
		private const MIN_DIAMETER_OF_BALL:int = 20;
		private const MAX_DIAMETER_OF_BALL:int = 30;
		private var manager:ColoredBallManager;
		private var _dt					: Number;			// clock time since last update 
		private var _lastTime			: Number;			// for calculating dt
		private var _curTime			: Number;			// for calculating dt
		private var centerTarget:Target;
		
		public function Document() 
		{
			// constructor code
			manager = new ColoredBallManager();
			buildWorld();
			
			addEventListener(Event.ENTER_FRAME, frameLoop);
		}
		
		//Populate the world with colorful balls
		private function buildWorld():void
		{
			//Initialize lastTime
			_lastTime = getTimer( );
			
			//Populate the screen with a random number of balls
			//on the screen with colors of the rainbow and random positions
			//and sizes
			var randomNumberOfBalls:int = randomNumberGenerator(MIN_NUMBER_OF_BALLS, MAX_NUMBER_OF_BALLS);
			for(var i:int = 0; i < randomNumberOfBalls; i++)
			{
				var randomSizeNumber:int = randomNumberGenerator(MIN_DIAMETER_OF_BALL, MAX_DIAMETER_OF_BALL);
				var randomPositionX:int = randomNumberGenerator(randomSizeNumber/2, stage.stageWidth);
				var randomPositionY:int = randomNumberGenerator(randomSizeNumber/2, stage.stageHeight);
				var ball:Ball = new Ball(manager, randomSizeNumber, randomPositionX, 
														   randomPositionY);
				
				//If it is not the first ball, then give the ball a color
				if(i > 0)
				{
					//Grab the next color
					manager.giveNextColor();
					
					//Color transforms reflects the color of the movieclip graphics color
					var tempColor:ColorTransform = new ColorTransform();
					tempColor.color = manager.ballColor;
					ball.transform.colorTransform = tempColor;
					ball.ballColor = manager.ballColor;
					
					//Store the ball in the respective array
					manager.storeBallInRespectiveArray(ball);
				}
				else
				{
					manager.centerBall = ball;
					manager.centerBall.ballColor = 0x000000;
				}
				
				//Add it onto the screen
				addChild(ball);
			}
			//Create a temp center target
			centerTarget = new Target(stage.stageWidth/2, stage.stageHeight/2);
			centerTarget.radius = 50;
			//drawCircleAroundCenter(stage.stageWidth/2, stage.stageHeight/2, centerTarget.radius, 0x00ff00);
			addChild(centerTarget);
			centerTarget.visible = false;
			manager.centerBall.ballTarget = centerTarget;
			
			//Designate the leaders as the first ball of the groups
			manager.makeFirstBallLeaderOfGroup();
			
			//Assign leaders to the groups of balls
			manager.assignLeadersToRespectiveGroups();
			
			
			
			//Generate the flow field once the white ball has arrived in the
			//center of the screen and all of the balls have found each other
			var flowField:FlowField = new FlowField(this, manager);
			manager.flowFieldMap = flowField;
			
			//repositionLeaderBalls();
			
			/*&drawCircleAroundCenter(manager.redBallLeader.x, manager.redBallLeader.y, 50, 0xffffff);
			drawCircleAroundCenter(manager.orangeBallLeader.x, manager.orangeBallLeader.y, 50, 0xffffff);
			drawCircleAroundCenter(manager.yellowBallLeader.x, manager.yellowBallLeader.y, 50, 0xffffff);
			drawCircleAroundCenter(manager.greenBallLeader.x, manager.greenBallLeader.y, 50, 0xffffff);
			drawCircleAroundCenter(manager.blueBallLeader.x, manager.blueBallLeader.y, 50, 0xffffff);
			drawCircleAroundCenter(manager.violetBallLeader.x, manager.violetBallLeader.y, 50, 0xffffff);*/
			
		}
		
		//Reposition the leader balls
		private function repositionLeaderBalls():void
		{
			manager.redBallLeader.position = new Vector2(100, 200);
			manager.orangeBallLeader.position = new Vector2(200, 200);
			manager.yellowBallLeader.position = new Vector2(100, 800);
			manager.greenBallLeader.position = new Vector2(200, 800);
			manager.blueBallLeader.position = new Vector2(600, 800);
			manager.violetBallLeader.position = new Vector2(700, 800);
		}
		
		//Random number generator for creating random numbers within a specific range of min and max
		private function randomNumberGenerator(minNumber:int, maxNumber:int):int
		{
			var randomNumber:int = Math.random() * (maxNumber - minNumber + 1) + minNumber;
			return randomNumber;
		}
		
		private function frameLoop(e:Event):void
		{
			// do update based on clock time
			_curTime = getTimer( );
			_dt = (_curTime - _lastTime)/1000;
			_lastTime = _curTime;
			
			//Make the center ball move
			manager.centerBall.update(_dt);
			//Make all of the other balls move
			manager.moveColorfulBalls(_dt);
		}
		
		public function drawCircleAroundCenter (centerX:Number, centerY:Number, radius:Number, color:uint):void
		{
			with (graphics)
			{
				lineStyle(1);
				beginFill(color, 0.25);
				drawCircle(centerX, centerY, radius);
				endFill();
			}
		}
		public function drawLine (startX:Number, startY:Number, endX:Number, endY:Number):void
		{
			//Using the graphics without using the lookup and not being in scope of variable
			//More efficient.  Don't have to do graphics.lineStyle
			with (graphics)
			{
				lineStyle(1, 0x990000);
				moveTo(startX, startY);
				lineTo(endX, endY);
			}
		}

	}
	
}
