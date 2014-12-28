package com.pixelBender.model.vo.tween
{
	import com.pixelBender.ease.Linear;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.interfaces.IDispose;
	
	public class TweenVO implements IDispose
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const NAME									:String = "TweenVO";

		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		private static var counter									:int = 0; 
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Tween unique identifier 
		 */		
		public var ID												:int;
		
		/**
		 * The tween target 
		 */		
		public var target											:Object;
		
		/**
		 * Tween start time. In milliseconds 
		 */		
		public var startTime										:int;
		
		/**
		 * Tween duration. In milliseconds 
		 */		
		public var duration											:int;
		
		/**
		 * The tween properties  
		 */		
		public var tweenTargetProperties							:Vector.<TweenTargetPropertyVO>;
		
		/**
		 * Complete callback invoked when tween is over 
		 */		
		public var completeCallback									:Function;
		
		/**
		 * Tween ease function. Default linear  
		 */		
		public var easeFunction										:Function;
		
		/**
		 * Tween start delay. In milliseconds  
		 */		
		public var delay											:int;

		/**
		 * In the case of the tween being explicitly paused, this flag is needed to compute the pause time
		 */
		public var lastUpdate										:int;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function TweenVO():void
		{
			ID = ++counter;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Initializes the TweenVO object
		 * @param target
		 * @param duration
		 * @param tweenTargetProperties
		 * @param completeCallback
		 * @param ease
		 * @param startDelay
		 * @return TweenVO
		 */		
		public function init(target:Object, duration:int, tweenTargetProperties:Vector.<TweenTargetPropertyVO>,
							 completeCallback:Function, ease:Function = null, startDelay:int = 0):TweenVO
		{
			this.target = target;
			this.duration = duration;
			this.tweenTargetProperties = tweenTargetProperties;
			this.completeCallback = completeCallback;
			this.easeFunction = (ease == null) ? Linear.linear : ease;
			this.delay = startDelay;
			this.startTime = -1;
			return this;
		}
		
		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Proper memory management
		 */		
		public function dispose():void
		{
			if (tweenTargetProperties)
			{
				IRunnableHelpers.dispose(tweenTargetProperties);
				tweenTargetProperties = null;
			}
			target = null;
			completeCallback = null;
			startTime = -1;
			lastUpdate = -1;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[TweenVO target:" + target + " duration: " + duration +
						" tweenProperties:" + tweenTargetProperties + "]";
		}
	}
}