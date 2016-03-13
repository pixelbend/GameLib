package com.pixelBender.model.vo.action
{
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.interfaces.IActionVO;

	public class ActionVO implements IActionVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Action type
		 */
		protected var actionType													:int;

		/**
		 * Action identifier
		 */
		protected var ID															:String;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function ActionVO() {}

		//==============================================================================================================
		// INITIALIZE
		//==============================================================================================================

		public function initializeBaseAction(actionType:int, ID:String):void
		{
			this.actionType = actionType;
			this.ID = ID;
			AssertHelpers.assertCondition(ID.length > 0, "Action identifier cannot be empty!");
		}

		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================

		public function dispose():void
		{
			ID = null;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getType():int
		{
			return actionType;
		}

		public function getID():String
		{
			return ID;
		}
	}
}
