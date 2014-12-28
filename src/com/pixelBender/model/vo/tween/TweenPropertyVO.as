package com.pixelBender.model.vo.tween
{
	import com.pixelBender.interfaces.IDispose;
	
	public class TweenPropertyVO implements IDispose
	{
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
			
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Initializes the property VO
		 */
		public function init(name:String, initialValue:Number, finalValue:Number):TweenPropertyVO
		{
			this.name = name;
			this.initialValue = initialValue;
			this.finalValue = finalValue;
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
			return "[TweenPropertyVO name:" + name + " initialValue: " + initialValue + " finalValue:" + finalValue + "]";
		}
	}
}