package com.pixelBender.model.component.action
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.interfaces.IAction;
	import com.pixelBender.model.vo.action.CompleteActionPropertiesVO;
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.pool.ObjectPoolManager;

	public class BaseAction implements IAction
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected static var completeObjectPool						:ObjectPool;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Action identifier
		 */
		protected var ID											:String;

		/**
		 * The function to call when the wait action is complete
		 */
		protected var completeCallback								:Function;

		/**
		 * Flag
		 */
		protected var state											:int;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function BaseAction()
		{
			if (completeObjectPool == null)
				completeObjectPool = ObjectPoolManager.getInstance().retrievePool(CompleteActionPropertiesVO.NAME);
		}

		//==============================================================================================================
		// IAction IMPLEMENTATION
		//==============================================================================================================

		/**
		 * Starts the action
		 * @param completeCallback Function - the callback that will be invoked when the action has finished on its own
		 * 										or was forcefully stopped
		 */
		public final function start(completeCallback:Function):void
		{
			AssertHelpers.assertCondition(state == GameConstants.STATE_IDLE, "Cannot start action unless idle!");
			this.completeCallback = completeCallback;
			state = GameConstants.STATE_STARTED;
			startAction();
		}

		/**
		 * Pauses the action
		 */
		public final function pause():void
		{
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED) && !BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED))
			{
				state = BitMaskHelpers.addBit(state, GameConstants.STATE_PAUSED);
				pauseAction();
			}
		}

		/**
		 * Resumes the action
		 */
		public final function resume():void
		{
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED))
			{
				state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PAUSED);
				resumeAction();
			}
		}

		/**
		 * Stops the action
		 */
		public final function stop():void
		{
			var normalStopProcedure:Boolean;

			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED))
			{
				 normalStopProcedure = !BitMaskHelpers.isBitActive(state, GameConstants.STATE_DISPOSING);

				if (normalStopProcedure)
					state = GameConstants.STATE_IDLE;

				stopAction();

				if (normalStopProcedure)
					invokeCompleteCallback(true);
			}
		}

		/**
		 * Memory management
		 */
		public final function dispose():void
		{
			// Update state
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_DISPOSING);
			// Remove 'listener'
			completeCallback = null;
			// Stop
			stop();
			// Let inherited actions do their stuff
			disposeAction();
			// Nullify other members
			ID = null;
			// Update state again
			state = GameConstants.STATE_DISPOSED;
		}

		public function getType():int
		{
			AssertHelpers.assertCondition(false, "Override this and return proper type!");
			return 0;
		}

		public function getID():String
		{
			return ID;
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		/**
		 * Invokes the complete callback if any has been assigned
		 * @param forced Boolean - flag whether the action has been completed forcefully (by stopping) or not
		 */
		protected function invokeCompleteCallback(forced:Boolean):void
		{
			var completeCallbackBackup:Function,
				completeVO:CompleteActionPropertiesVO;

			if (completeCallback == null)
				return;

			completeCallbackBackup = completeCallback; // Keep clone in case complete causes a new start with a different callback
			completeVO = completeObjectPool.allocate() as CompleteActionPropertiesVO;

			completeVO.initialize(getType(), getID(), forced);
			completeCallback = null;
			completeCallbackBackup(completeVO);

			// Release back in the pool
			completeObjectPool.release(completeVO);
		}

		/**
		 * Internal start handler. Can be overridden by inherited classes to do proprietary logic
		 */
		protected function startAction():void {}

		/**
		 * Internal pause handler. Can be overridden by inherited classes to do proprietary logic
		 */
		protected function pauseAction():void {}

		/**
		 * Internal resume handler. Can be overridden by inherited classes to do proprietary logic
		 */
		protected function resumeAction():void {}

		/**
		 * Internal stop handler. Can be overridden by inherited classes to do proprietary logic
		 */
		protected function stopAction():void {}

		/**
		 * Internal dispose handler. Can be overridden by inherited classes to do proprietary logic
		 */
		protected function disposeAction():void {}
	}
}
