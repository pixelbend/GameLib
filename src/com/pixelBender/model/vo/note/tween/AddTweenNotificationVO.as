package com.pixelBender.model.vo.note.tween
{
	import com.pixelBender.interfaces.IDispose;

	public class AddTweenNotificationVO implements IDispose
	{
		//==============================================================================================================
		// STATIC CONSTANTS
		//==============================================================================================================

		public static const NAME												:String = "AddTweenNotificationVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Tweened target
		 */		
		private var target																	:Object;
		
		/**
		 * Tween duration 
		 */		
		private var duration																:int;
		
		/**
		 * The tweened properties of the object 
		 */		
		private var properties																:Object;
		
		/**
		 * Complete callback 
		 */		
		private var completeCallback														:Function;
		
		/**
		 * Tween ease function. Default linear  
		 */		
		private var easeFunction															:Function;
		
		/**
		 * Tween start delay. In milliseconds  
		 */		
		private var delay																	:int;
		
		/**
		 * Result tween ID. Can be used to remove the tween before it's completed.
		 */		
		private var tweenID																	:int;
		
		//==============================================================================================================
		// API
		//==============================================================================================================
				
		public function initialize(target:Object, duration:int, properties:Object, completeCallback:Function,
								   		ease:Function, startDelay:int):AddTweenNotificationVO
		{
			this.target = target;
			this.duration = duration;
			this.properties = properties;
			this.completeCallback = completeCallback;
			this.easeFunction = ease;
			this.delay = startDelay;
			this.tweenID = -1;
			return this;
		}
		
		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		public function dispose():void
		{
			target = null;
			properties = null;
			completeCallback = null;
			easeFunction = null;
		}
		
		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================
		
		public function getTarget():Object
		{
			return target;
		}
		
		public function getDuration():int
		{
			return duration;
		}
		
		public function getProperties():Object
		{
			return properties;
		}
		
		public function getCompleteCallback():Function
		{
			return completeCallback;
		}
		
		public function getStartDelay():int
		{
			return delay;
		}
		
		public function getEaseFunction():Function
		{
			return easeFunction;
		}
		
		public function getTweenID():int
		{
			return tweenID;
		}
		
		public function setTweenID(value:int):void
		{
			tweenID = value;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[AddTweenNotificationVO target:" + target + " duration: " + duration +
						" properties:" + properties + "]";
		}
	}
}