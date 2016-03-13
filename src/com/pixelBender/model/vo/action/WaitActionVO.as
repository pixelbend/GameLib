package com.pixelBender.model.vo.action
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;

	public class WaitActionVO extends ActionVO
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		public static const	NAME										:String = "WaitActionVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The wait time in milliseconds
		 */
		protected var waitTime										:int;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initialize(ID:String, waitTime:int):void
		{
			initializeBaseAction(GameConstants.ACTION_TYPE_WAIT, ID);

			AssertHelpers.assertCondition(waitTime > 0, "Wait time cannot be negative or zero!");
			this.waitTime = waitTime;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getWaitTime():int
		{
			return waitTime;
		}
	}
}
