package com.pixelBender.model.vo.action
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.interfaces.IActionPlayer;

	public class ParallelActionVO extends ActionVO
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		public static const	NAME										:String = "ParallelActionVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The list of action identifiers that will be sequenced
		 */
		protected var actionIDs											:Vector.<String>;

		/**
		 * Reference to the action proxy
		 */
		protected var actionPlayer										:IActionPlayer;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initialize(ID:String, actionIDs:Vector.<String>, actionPlayer:IActionPlayer = null):void
		{
			initializeBaseAction(GameConstants.ACTION_TYPE_PARALLEL, ID);

			AssertHelpers.assertCondition(actionIDs != null, "Action IDs cannot be null!");
			AssertHelpers.assertCondition(actionIDs.length > 0, "Action IDs cannot be empty!");
			this.actionIDs = actionIDs;

			this.actionPlayer = actionPlayer;
		}

		//==============================================================================================================
		// GETTERS / SETTERS
		//==============================================================================================================

		public function getActionIDs():Vector.<String>
		{
			return actionIDs;
		}

		public function getActionPlayer():IActionPlayer
		{
			return actionPlayer;
		}

		public function setActionPlayer(actionPlayer:IActionPlayer):void
		{
			this.actionPlayer = actionPlayer;
		}
	}
}
