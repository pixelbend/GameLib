package com.pixelBender.model.vo.tween
{
	import com.pixelBender.interfaces.IDispose;
	
	public class TweenTargetPropertyVO implements IDispose
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const NAME												:String = "TweenTargetPropertyVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Tween property name (currentFrame/x/y/etc.) 
		 */		
		public var name															:String;
		
		/**
		 * Property initial value 
		 */		
		public var initialValue													:Number;
		
		/**
		 * Property final value 
		 */		
		public var finalValue													:Number;
		
		/**
		 * Property diff value. Computed once for optimization reasons. 
		 */		
		public var diffValue													:Number;
			
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Initializes the target property VO
		 */
		public function init(name:String, initialValue:Number, finalValue:Number):TweenTargetPropertyVO
		{
			this.name = name;
			this.initialValue = initialValue;
			this.finalValue = finalValue;
			this.diffValue = finalValue - initialValue;
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
			name = null;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[TweenTargetPropertyVO name:" + name + " initialValue: " + initialValue +
						" finalValue:" + finalValue + "]";
		}
	}
}