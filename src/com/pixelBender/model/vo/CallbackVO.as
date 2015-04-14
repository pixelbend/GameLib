package com.pixelBender.model.vo
{
	import com.pixelBender.interfaces.IDispose;
	
	public class CallbackVO implements IDispose
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		private static const EMPTY_PARAMETER_LIST										:Array = [];

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Callback that will be invoked 
		 */		
		private var callback															:Function;
		
		/**
		 * The callback parameters 
		 */		
		private var callbackParams														:Array;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function CallbackVO(callback:Function, params:Array)
		{
			this.callback = callback;
			this.callbackParams = params;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Memory management 
		 */		
		public function dispose():void
		{
			callback = null;
			callbackParams = null;
		}
		
		/**
		 * Invokes the callback  
		 */		
		public function invoke():void
		{
			callback.apply(this, (callbackParams != null) ? callbackParams : EMPTY_PARAMETER_LIST);
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[CallbackVO]";
		}
	}
}