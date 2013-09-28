package  
{
	import flash.display.MovieClip;
	
	public class Ball extends SteeringVehicle 
	{
		private var _ballTarget:Target;
		private var _leaderBall:Ball;
		private var _isLeader:Boolean;
		private var _radius:int;
		private var _ballColor:uint;
		private var _groupNumber:int;
		private var _isGroupNumberAssigned:Boolean;
		private var _isOrbiting:Boolean;
		
		public function Ball(aManager:ColoredBallManager, diameter:int, aX:Number = 0, 
								aY:Number = 0) 
		{
			// constructor code
			super(aManager, diameter, aX, aY);
			this.speed = 60;
			_radius = diameter/2;
		}
		
		//Setters and getters for ball properties
		public function get ballTarget():Target
		{
			return _ballTarget;
		}
		public function get leaderBall():Ball
		{
			return _leaderBall;
		}
		public function get isLeader():Boolean
		{
			return _isLeader;
		}
		public function get radius():int
		{
			return _radius;
		}
		public function get ballColor():uint
		{
			return _ballColor;
		}
		public function get groupNumber():int
		{
			return _groupNumber;
		}
		public function get isGroupNumberAssigned():Boolean
		{
			return _isGroupNumberAssigned;
		}
		public function get isOrbiting():Boolean
		{
			return _isOrbiting;
		}
		public function set ballTarget(target:Target):void
		{
			_ballTarget = target;
		}
		public function set leaderBall(ball:Ball):void 
		{
			_leaderBall = ball;
		}
		public function set isLeader(isBallLeader:Boolean):void
		{
			_isLeader = isBallLeader;
		}
		public function set radius(rad:int):void
		{
			_radius = rad;
		}
		public function set ballColor(color:uint):void
		{
			_ballColor = color;
		}
		public function set groupNumber(number:int):void
		{
			_groupNumber = number;
		}
		public function set isGroupNumberAssigned(assigned:Boolean):void
		{
			_isGroupNumberAssigned = assigned;
		}
		public function set isOrbiting(isOrbit:Boolean):void
		{
			_isOrbiting = isOrbit;
		}
		
		//Calls the superclass's update function for calculating 
		//all of the forces involved in getting the ball to move
		override public function update(dt:Number):void
		{
			//Make the balls gather together first
			if(manager.groupNumberCounter != 6)
			{
				updateGatherMode(dt);
			}
			//After all of the balls have gathered together by their color
			//then make the first group go to the first inner ring
			//and the second group go to the second inner ring and so forth
			else
			{
				//trace("orbit");
				var groupNumber:int = 0;
				//Get the group number from the leader ball
				if(_leaderBall != null)
				{
					groupNumber = _leaderBall.groupNumber;
				}
				//If it is the leader ball then get its group number
				else
				{
					groupNumber = _groupNumber;
				}
				
				if(this != manager.centerBall && groupNumber == manager.orbitGroupNumberCounter || _isOrbiting)
				{
					super.update(dt);
				}
				else if(!_isLeader  && this != manager.centerBall)
				{
					updateGatherMode(dt);
				}
			}
		}
		
		private function updateGatherMode(dt):void
		{
			if(!_isLeader && this != manager.centerBall)
				{
					super.update(dt);
					if(!_leaderBall.isGroupNumberAssigned)
					{
						arrival(_leaderBall);
					}
				}
				//If it is the center ball then go to the center of the screen
				if(this == manager.centerBall)
				{
					super.update(dt);
					arrivalToTarget(_ballTarget);
				}
				//See which group has gathered first, second, and so forth
				manager.determineGroupNumber();
		}
		
		override protected function calcSteeringForce():Vector2
		{
			var steeringForce:Vector2 = new Vector2(0,0);
			
			var groupNumber:int = 0;
			//Get the group number from the leader ball
			if(_leaderBall != null)
			{
				groupNumber = _leaderBall.groupNumber;
			}
			//If it is the leader ball then get its group number
			else
			{
				groupNumber = _groupNumber;
			}
			
			if(manager.groupNumberCounter == manager.NUMBER_OF_COLORS)
			{
				//Regardless they should all go towards the inner ring
				if(manager.orbitGroupNumberCounter == groupNumber || _isOrbiting)
				{
					steeringForce = orbitMode(groupNumber);
				}
				else
				{
					steeringForce = gatherMode();
				}
			}
			else
			{
				steeringForce = gatherMode();
			}
			
			return steeringForce;
		}
		
		//Different modes
		private function gatherMode():Vector2
		{
			var steeringForce:Vector2 = new Vector2(0,0);
			steeringForce.plusEquals(super.fullSpeedAhead());
			if(this == manager.centerBall)
			{
				steeringForce.plusEquals(seek(new Vector2(stage.stageWidth/2,
															stage.stageHeight/2)));
			}
			else if(!_isLeader)
			{
				steeringForce.plusEquals(seek(new Vector2(_leaderBall.position.x, _leaderBall.position.y)));
			}

			//Separate thy colorful balls if the leader has been assigned a group number
			if(!_isLeader && this != manager.centerBall)
			{
				if(_leaderBall.isGroupNumberAssigned)
				{
					var arrayOfBalls:Array = manager.giveRespectiveArrayBasedOnColor(this);
					steeringForce.plusEquals(separation(arrayOfBalls).timesEquals(3));
					//var closestBall:Ball = findClosestFollower(manager.giveRespectiveArrayBasedOnColor(this));
					//steeringForce.plusEquals(seek(closestBall.position).timesEquals(0.5));
				}
			}
			return steeringForce;
		}
		
		private function findClosestFollower(arrayOfBalls:Array):Ball
		{
			var distance:Number = 0;
			var closestBall:Ball;
			for each(var ball:Ball in arrayOfBalls)
			{
				if(distance == 0)
				{
					distance = Vector2.distance(ball.position, position);
					closestBall = ball;
				}
				else if(this != ball && !ball.isLeader)
				{
					distance = Vector2.distance(closestBall.position, position);
					closestBall = ball;
				}
			}
			return closestBall;
		}
		
		private function orbitMode(groupNumber:int):Vector2
		{
			var steeringForce:Vector2 = new Vector2(0,0);
			
			//Generate the inner ring only once
			if(manager.flowFieldMap.generateNextInnerRing && manager.orbitGroupNumberCounter < 6)
			{
				trace("generate ring");
				manager.flowFieldMap.selectCircleOfFlowFieldArrows();
				manager.flowFieldMap.generateNextInnerRing = false;
			}
			//Make the ball be affected by the flow field
			steeringForce.plusEquals(driftByFlowField());
			//Add separation force
			var arrayOfBalls:Array = manager.giveRespectiveArrayBasedOnColor(this);
			steeringForce.plusEquals(separation(arrayOfBalls).timesEquals(0.5));
			
			//Check to see if the balls are in the inner ring
			if(manager.orbitGroupNumberCounter < 6)
			{
				var arrayOfGroupBalls:Array = manager.giveRespectiveArrayBasedOnGroupNumber(manager.orbitGroupNumberCounter);
				var isInsideInnerRing:Boolean = collisionDetectionInnerCircle(arrayOfGroupBalls);
				if(isInsideInnerRing)
				{
					//trace("inside ring");
					manager.orbitGroupNumberCounter++;
					manager.flowFieldMap.generateNextInnerRing = true;
					markBallsAsOrbiting(arrayOfGroupBalls);
				}
			}
			
			return steeringForce;
		}
		
		private function markBallsAsOrbiting(arrayOfBalls:Array):void
		{
			for each(var ball:Ball in arrayOfBalls)
			{
				ball.isOrbiting = true;
			}
		}
		
		//Check to see if the entire group is in the orbit it is supposed to be in
		private function collisionDetectionInnerCircle(arrayOfBalls:Array):Boolean
		{
			var innerRing:DonutHole = manager.flowFieldMap.donutHoleArray[manager.orbitGroupNumberCounter];
			var isInsideInnerRing:Boolean = true;
			var outerCircleRadius:int = innerRing.outerCircle.radius;
			for each(var ball:Ball in arrayOfBalls)
			{
				var distance:Number = Vector2.distance(ball.position, innerRing.outerCircle.position);
				if(!(distance < ball.radius + outerCircleRadius))
				{
					isInsideInnerRing = false;
					return isInsideInnerRing;
				}
			}
			trace(isInsideInnerRing);
			
			return isInsideInnerRing;
		}
		
		//Steering forces
		//Arrival to ball
		private function arrival(target:Ball):void
		{
			//Find the distance between the ball and the target
			var distanceBetweenBallAndTarget:Number = Vector2.distance(this.position, 
																		  target.position);
			//Check to see if the distance is less than the radius of the target
			if(distanceBetweenBallAndTarget < target.radius)
			{
				this.velocity.normalize();
				this.velocity.timesEquals(super.maxSpeed * distanceBetweenBallAndTarget/target.radius);
			}
			
		}
		//Arrival to target
		private function arrivalToTarget(target:Target):void
		{
			//Find the distance between the ball and the target
			var distanceBetweenBallAndTarget:Number = Vector2.distance(this.position, 
																		  target.position);
			//Check to see if the distance is less than the radius of the target
			if(distanceBetweenBallAndTarget < target.radius)
			{
				this.velocity.normalize();
				this.velocity.timesEquals(super.maxSpeed * distanceBetweenBallAndTarget/target.radius);
				//trace("Velcoity in ball" + velocity);
			}
		}
		
		//Leader-Following Steering Force Calculation involves both separation
		//and arrival
		//Separation
		private function separation(arrayOfBalls:Array):Vector2
		{
			var desiredSeparationSpace:Number = _radius * 5;
			var sumOfSeparationVector:Vector2 = new Vector2(0,0);
			var count:int = 0;
			for each(var ball:Ball in arrayOfBalls)
			{
				if(this != ball)
				{
					//Find distance between this ball and the other ball
					var distanceBetweenThisBallAndOtherBall:Number = Vector2.distance(position, ball.position);
					//Make sure it is within the specified range
					if(distanceBetweenThisBallAndOtherBall > 0 
					   && distanceBetweenThisBallAndOtherBall < desiredSeparationSpace)
					{
						var fleeVector:Vector2 = Vector2.subtract(position, ball.position);   
						fleeVector.normalize();
						fleeVector.divideEquals(distanceBetweenThisBallAndOtherBall);
						sumOfSeparationVector.plusEquals(fleeVector);
						count++;
					}
					//Make sure there was a separation vector produced
					if(count > 0)
					{
						sumOfSeparationVector.divideEquals(count);
						sumOfSeparationVector.normalize();
						sumOfSeparationVector.timesEquals(maxSpeed);
						var separationSteeringForce:Vector2 = Vector2.subtract(sumOfSeparationVector, velocity);
						return separationSteeringForce;
					}
				}
			}
			return sumOfSeparationVector;
		}
		
		//Be affected by the flow field arrow direction
		private function driftByFlowField():Vector2
		{
			//Find the flow field arrow the ball is currently on
			var flowFieldArrow:FlowFieldArrow = manager.flowFieldMap.lookUpArrowInFieldMap(this.position);
			//Steer by it
			var steeringForce:Vector2;
			if(flowFieldArrow != null)
			{
				steeringForce = Vector2.subtract(flowFieldArrow.directionForce, velocity);
			}
			else
			{
				steeringForce = new Vector2(0,0);
			}
			return steeringForce;
		}
	}
	
}
