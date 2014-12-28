package com.pixelBender.controller.gameScreen.vo
{
	public class ShowGameScreenCommandVO
	{
		//==============================================================================================================
		// STATIC CONSTANTS
		//==============================================================================================================

		public static const NAME												:String = "ShowGameScreenCommandVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The new screen unique identifier 
		 */		
		private var newScreenName																	:String;
		
		/**
		 * Transition sequence unique identifier 
		 */		
		private var transitionSequenceName															:String;
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function initialize(newScreenName:String, transitionSequenceName:String):ShowGameScreenCommandVO
		{
			this.newScreenName = newScreenName;
			this.transitionSequenceName = transitionSequenceName;
			return this;
		}
		
		//==============================================================================================================
		// GETTERS
		//==============================================================================================================
		
		public function getScreenName():String
		{
			return newScreenName;
		}
		
		public function getTransitionSequenceName():String
		{
			return transitionSequenceName;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[ShowGameScreenCommandVO newScreenName:" + newScreenName +
						" transitionSequenceName: " + transitionSequenceName + "]";
		}
	}
}