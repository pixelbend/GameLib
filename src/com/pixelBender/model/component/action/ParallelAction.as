package com.pixelBender.model.component.action
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.interfaces.IActionPlayer;
	import com.pixelBender.model.vo.action.CompleteActionPropertiesVO;
	import com.pixelBender.model.vo.action.ParallelActionVO;

	public class ParallelAction extends BaseAction
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		public static const NAME									:String = "ParallelAction";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The list of action identifiers that will be sequenced
		 */
		protected var actionIDs										:Vector.<String>;

		/**
		 * Local reference to action player needed to play all child actions
		 */
		protected var actionPlayer									:IActionPlayer;

		/**
		 * If anyone is interested to know if a child action is completed, this callback will be invoked
		 */
		protected var childCompleteCallback							:Function;

		/**
		 * The already completed children action.
		 */
		protected var completedActions								:Vector.<Boolean>;

		/**
		 * Internal flag
		 */
		protected var completedActionsCount							:int = 0;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initialize(actionVO:ParallelActionVO):void
		{
			ID = actionVO.getID();
			actionIDs = actionVO.getActionIDs();
			completedActions = new Vector.<Boolean>(actionIDs.length, true);
			actionPlayer = actionVO.getActionPlayer();
			state = GameConstants.STATE_IDLE;
		}

		public function setChildCompleteCallback(childCompleteCallback:Function):void
		{
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED))
			{
				AssertHelpers.assertCondition(false, "Cannot modify action proxy while running");
				return;
			}

			this.childCompleteCallback = childCompleteCallback;
		}

		//==============================================================================================================
		// IAction IMPLEMENTATION
		//==============================================================================================================

		public override function getType():int
		{
			return GameConstants.ACTION_TYPE_PARALLEL;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[ParallelAction ID:" + ID + "state:" + state + " actionIDs:" + actionIDs + "]";
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		/**
		 * Starts the wait action
		 */
		protected override function startAction():void
		{
			var i:int = 0,
				length:int = actionIDs.length;

			// Reset counters
			completedActionsCount = 0;
			for (; i<length; i++)
				completedActions[i] = false;

			// Start all actions
			for (i=0; i<length; i++)
				actionPlayer.startAction(actionIDs[i], handleChildComplete);
		}

		/**
		 * Pauses the action
		 */
		protected override function pauseAction():void
		{
			var i:int = 0,
				length:int = actionIDs.length;

			for (; i<length; i++)
				actionPlayer.pauseAction(actionIDs[i]);
		}

		/**
		 * Resumes the action
		 */
		protected override function resumeAction():void
		{
			var i:int = 0,
				length:int = actionIDs.length;

			for (; i<length; i++)
				actionPlayer.resumeAction(actionIDs[i]);
		}

		/**
		 * Stops the waiting action
		 */
		protected override function stopAction():void
		{
			var i:int = 0,
				length:int = actionIDs.length;

			for (; i<length; i++)
				actionPlayer.stopAction(actionIDs[i]);
		}

		/**
		 * Memory management
		 */
		protected override function disposeAction():void
		{
			actionIDs = null;
			actionPlayer = null;
			childCompleteCallback = null;
			completedActions = null;
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		private function handleChildComplete(completeVO:CompleteActionPropertiesVO):void
		{
			var i:int = 0,
				length:int = actionIDs.length,
				completeChildID:String = completeVO.getID(),
				ownChildStopped:Boolean = false;

			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED))
				return;

			// Propagate further
			if (childCompleteCallback != null)
				childCompleteCallback(completeVO);

			// Make sure this is ours. We can get others though propagation
			for (; i < length; i++)
			{
				if (actionIDs[i] == completeChildID && false == completedActions[i])
				{
					completedActions[i] = true;
					ownChildStopped = true;
					break;
				}
			}

			if (!ownChildStopped)
				return;

			completedActionsCount++;

			if (completeVO.getForced())
			{
				// We're done here, someone stopped our child
				stopAction();
				invokeCompleteCallback(true);
			}
			else
			{
				if (completedActionsCount == length)
				{
					state = GameConstants.STATE_IDLE;
					invokeCompleteCallback(false);
				}
			}
		}
	}
}
