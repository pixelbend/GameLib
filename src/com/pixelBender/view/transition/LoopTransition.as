package com.pixelBender.view.transition
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.BitMaskHelpers;
	
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class LoopTransition extends TransitionView
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The set timeout ID. Used to simulate loops. 
		 */		
		private var timeoutID																		:int;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function LoopTransition(name:String)
		{
			super(name);
			timeoutID = -1;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function toString():String
		{
			return "[LoopTransition]";
		}
		
		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================
		
		/**
		 * Starts the timeout  
		 */		
		override protected function playTransition():void
		{
			createTimeout();
		}
		
		/**
		 * Paused the timeout  
		 */
		override protected function pauseTransition():void
		{
			removeTimeout();
		}
		
		/**
		 * Resumes the timeout 
		 */		
		override protected function resumeTransition():void
		{
			createTimeout();
		}
		
		/**
		 * Removes the timeout 
		 */		
		override protected function stopTransition():void
		{
			removeTimeout();
		}
		
		/**
		 * Loop complete custom handler. 
		 * @param e Event
		 */		
		override protected function handleLoopComplete(e:Event=null):void
		{
			// Super behavior
			super.handleLoopComplete(e);
			// If still active, reactivate timeout
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_PLAYING))
			{
				createTimeout();
			}
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Removes the loop complete callback. If any.  
		 */		
		private function removeTimeout():void
		{
			if (timeoutID>=0)
			{
				clearTimeout(timeoutID);
				timeoutID = -1;
			}
		}
		
		/**
		 * Creates the loop complete callback. 
		 */		
		private function createTimeout():void
		{
			removeTimeout(); // Fail safe
			timeoutID = setTimeout(handleLoopComplete, 100);
		}
	}
}