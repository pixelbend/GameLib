package com.pixelBender.model.component.action
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.interfaces.IActionPlayer;
	import com.pixelBender.model.vo.action.CompleteActionPropertiesVO;
	import com.pixelBender.model.vo.action.SequenceActionVO;

	public class SequenceAction extends BaseAction
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		public static const NAME									:String = "SequenceAction";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The list of action identifiers that will be sequenced
		 */
		protected var actionIDs										:Vector.<String>;

		/**
		 * Local reference to controlling action proxy
		 */
		protected var actionPlayer									:IActionPlayer;

		/**
		 * If anyone is interested to know if a child action is completed, this function will be used.
		 */
		protected var childCompleteCallback							:Function;

		/**
		 * Internal flag
		 */
		protected var currentActionIndex							:int;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initialize(actionVO:SequenceActionVO):void
		{
			ID = actionVO.getID();
			actionIDs = actionVO.getActionIDs();
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
			return GameConstants.ACTION_TYPE_SEQUENTIAL;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[SequenceAction ID:" + ID + "state:" + state + " actionIDs:" + actionIDs + "]";
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		/**
		 * Starts the action
		 */
		protected override function startAction():void
		{
			currentActionIndex = -1;
			advance();
		}

		/**
		 * Pauses the child action as well
		 */
		protected override function pauseAction():void
		{
			actionPlayer.pauseAction(actionIDs[currentActionIndex]);
		}

		/**
		 * Resumes the child action as well
		 */
		protected override function resumeAction():void
		{
			actionPlayer.resumeAction(actionIDs[currentActionIndex]);
		}

		/**
		 * Stops the action
		 */
		protected override function stopAction():void
		{
			actionPlayer.stopAction(actionIDs[currentActionIndex]);
		}

		/**
		 * Memory management
		 */
		protected override function disposeAction():void
		{
			actionIDs = null;
			actionPlayer = null;
			childCompleteCallback = null;
		}

		protected function handleChildActionComplete(completeVO:CompleteActionPropertiesVO):void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED))
				return;

			// Propagate further
			if (childCompleteCallback != null)
				childCompleteCallback(completeVO);

			// Make sure this is ours. We can get others though propagation
			if (completeVO.getID() != actionIDs[currentActionIndex])
				return;

			if (completeVO.getForced())
			{
				// We're done here, someone stopped our child
				stopAction();
				invokeCompleteCallback(true);
			}
			else
			{
				// Move on to the next action
				advance();
			}
		}

		protected function advance():void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED))
				return;

			currentActionIndex++;

			if (currentActionIndex >= actionIDs.length)
			{
				// All done
				state = GameConstants.STATE_IDLE;
				invokeCompleteCallback(false);
			}
			else
			{
				// Start next action
				actionPlayer.startAction(actionIDs[currentActionIndex], handleChildActionComplete);
			}
		}
	}
}
