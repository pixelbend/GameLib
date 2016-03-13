package com.pixelBender.model.component.action
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.interfaces.IFrameUpdate;
	import com.pixelBender.model.vo.action.WaitActionVO;
	import com.pixelBender.update.FrameUpdateManager;

	public class WaitAction extends BaseAction implements IFrameUpdate
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		public static const NAME									:String = "WaitAction";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The wait time the action will wait before calling complete
		 */
		protected var waitTime										:int;

		/**
		 * Local reference
		 */
		protected var frameUpdateManager							:FrameUpdateManager;

		/**
		 * Flag
		 */
		protected var currentElapsedTime							:int;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initialize(waitActionVO:WaitActionVO):void
		{
			ID = waitActionVO.getID();
			waitTime = waitActionVO.getWaitTime();
			frameUpdateManager = FrameUpdateManager.getInstance();
			state = GameConstants.STATE_IDLE;
		}

		//==============================================================================================================
		// IAction IMPLEMENTATION
		//==============================================================================================================

		public override function getType():int
		{
			return GameConstants.ACTION_TYPE_WAIT;
		}

		//==============================================================================================================
		// IFrameUpdate IMPLEMENTATION
		//==============================================================================================================

		/**
		 * Update implementation
		 * @param dt int - the time passed in the last frame
		 */
		public function frameUpdate(dt:int):void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED) || BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED))
				return;

			currentElapsedTime += dt;

			if (currentElapsedTime >= waitTime)
			{
				currentElapsedTime = 0;
				frameUpdateManager.unregisterFromUpdate(this);
				state = GameConstants.STATE_IDLE;
				invokeCompleteCallback(false);
			}
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[WaitAction ID:" + ID + "state:" + state + " waitTime::" + waitTime + "]";
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		/**
		 * Starts the wait action
		 */
		protected override function startAction():void
		{
			currentElapsedTime = 0;
			frameUpdateManager.registerForUpdate(this);
		}

		/**
		 * Pauses the action
		 */
		protected override function pauseAction():void
		{
			frameUpdateManager.unregisterFromUpdate(this);
		}

		/**
		 * Resumes the action
		 */
		protected override function resumeAction():void
		{
			frameUpdateManager.registerForUpdate(this);
		}

		/**
		 * Stops the waiting action
		 */
		protected override function stopAction():void
		{
			frameUpdateManager.unregisterFromUpdate(this);
		}

		/**
		 * Memory management
		 */
		protected override function disposeAction():void
		{
			if (frameUpdateManager)
			{
				frameUpdateManager.unregisterFromUpdate(this);
				frameUpdateManager = null;
			}
		}
	}
}