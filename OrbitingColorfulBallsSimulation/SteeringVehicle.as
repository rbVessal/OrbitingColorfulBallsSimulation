package  
{
	public class SteeringVehicle extends VectorBall
	{
		protected var _maxSpeed: Number = 60;
		protected var _maxForce: Number = 150;
		protected var _mass: Number = 1.0;
	
		public function SteeringVehicle(aMan:ColoredBallManager, diameter:int, aX:Number = 0, 
								aY:Number = 0) 
		{
			super(aMan, diameter, aX, aY);
			// initialize velocity to zero so movement results from applied force
			_velocity = new Vector2( );
		}
		
		public function set maxSpeed(s:Number)		{_maxSpeed = s;	}
		public function set maxForce(f:Number)		{_maxForce = f;	}
		public function get maxSpeed( )		{ return _maxSpeed;	}
		public function get maxForce( )		{ return _maxForce; }
		public function get right( )		{ return fwd.perpRight( ); }

		override public function update(dt:Number): void
		{
			//call calcSteeringForce (override in subclass) to get steering force
			var steeringForce:Vector2 = calcSteeringForce( );
			//Ensure that the hunter and prey stay on stage
			steeringForce.plusEquals(stayOnStage());
			
			// clamp steering force to max force
			clampSteeringForce(steeringForce);
	
			// calculate acceleration: force/mass
			var acceleration:Vector2 = Vector2.divide(steeringForce, _mass);
			// add acceleration for time step to velocity
			_velocity.plusEquals(Vector2.multiply(acceleration, dt));
			//_velocity = _velocity.plusEquals(acceleration.timesEquals(dt));
			// update speed to reflect new velocity
			_speed = _velocity.magnitude( );
			// update fwd to reflect new velocity 
			fwd = _velocity;
			// clamp speed and velocity to max speed
			if (_speed > _maxSpeed)
			{
				_speed = _maxSpeed;
				_velocity = Vector2.multiply(fwd, _speed);
			}
			// call move with velocity adjusted for time step
			move( Vector2.multiply(_velocity, dt));
		}
		
		public function calculateFuturePosition():Vector2
		{
			return Vector2.multiply(this.fwd, this.speed * 5);
		}
				
		protected function calcSteeringForce( ):Vector2
		{
			var steeringForce : Vector2 = new Vector2( );
			
			// override this function in subclasses by adding steering forces
			// using syntax like below (assuming target is a position vector)
			
			// steeringForce.plusEquals(seek(target));
			// steeringForce.plusEquals(stayOnStage( ));
			
			// multiple steering forces can be added to produce complex behavior
			
			return steeringForce;
		}

			
		private function clampSteeringForce(force: Vector2 ): void
		{
			var mag:Number = force.magnitude();
			if(mag > _maxForce)
			{
				force.divideEquals(mag);
				force.timesEquals(_maxForce);
			}
		}
		
			
		protected function seek(targPos : Vector2) : Vector2
		{
			//trace("seek in SteeringVehicle");
			// set desiredVelocity equal to a vector from position to targPos
			var desVel:Vector2;
			var steeringForce:Vector2;
			//trace("position in SteeringVehicle" + position);
			//trace("target position in SteeringVehicle" + targPos);
			desVel = Vector2.subtract(targPos, position);
			//trace("desVel in SteeringVehicle" + desVel);
			// scale desired velocity so its magnitude equals max speed
			desVel.normalize( );
			desVel.timesEquals(maxSpeed);
			// to get steerinForce subtract current velocity from desired velocity
			steeringForce = Vector2.subtract(desVel, velocity)
			//trace("steeringForce in SteeringVehicle" + steeringForce);
	
			return steeringForce;
		}
		
		protected function flee(targPos : Vector2) : Vector2
		{
			// Set desiredVelocity equal to a vector AWAY from targPos
			// otherwise the function should be the same as seek 
			var desiredVelocity:Vector2 = Vector2.subtract(targPos, this.position);
			desiredVelocity.normalize();
			desiredVelocity = desiredVelocity.timesEquals(this.maxSpeed);
			var steeringForce = Vector2.subtract(this.velocity, desiredVelocity);
			return steeringForce;
		}
		
		
		//  additional functions you might find useful
		
		  protected function stayOnStage( ):Vector2
		  {
			  var stayOnStageVector:Vector2 = new Vector2(0,0);
			  //we could try this in class
			  if(this.x < 0 || this.x > stage.stageWidth || this.y < 0 || this.y > stage.stageHeight)
			  {
				 stayOnStageVector = seek(new Vector2(stage.stageWidth/2, stage.stageHeight/2));
			  }
			  return stayOnStageVector;
		  }
		  
		  protected function fullSpeedAhead( ):Vector2
		  {			
			var steeringForce:Vector2;
			var desVel:Vector2  = fwd.timesEquals(maxSpeed);
			steeringForce = Vector2.subtract(desVel, velocity);
			return steeringForce;
		  }

	}
}



