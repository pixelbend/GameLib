package com.pixelBender.model.vo.action
{
	import com.pixelBender.constants.GameConstants;

	public class CompleteActionPropertiesVO extends ActionVO
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		public static const	NAME										:String = "CompleteActionPropertiesVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Flag whether the action has been completed forcefully (by stopping) or not
		 */
		protected var forced											:Boolean;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function CompleteActionPropertiesVO() {}

		//==============================================================================================================
		// API
		//==============================================================================================================

		/**
		 * Initializes the complete action VO
		 * @param actionType int - the action type (in this case wait)
		 * @param ID - action string unique identifier
		 * @param forced - flag whether the action has been completed forcefully (by stopping) or not
		 */
		public function initialize(actionType:int, ID:String, forced:Boolean):void
		{
			initializeBaseAction(actionType, ID);
			this.forced = forced;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getForced():Boolean
		{
			return forced;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[CompleteActionPropertiesVO ID:" + ID + " type:" + getTypeName() + " forced:" + forced + "]";
		}

		private function getTypeName():String
		{
			switch(actionType)
			{
				case GameConstants.ACTION_TYPE_PARALLEL:
					return "parallel";
				case GameConstants.ACTION_TYPE_PLAY_SOUND:
					return "playSound";
				case GameConstants.ACTION_TYPE_SEQUENTIAL:
					return "sequential";
				case GameConstants.ACTION_TYPE_TWEEN:
					return "tween";
				case GameConstants.ACTION_TYPE_WAIT:
					return "wait";
				default:
					return "custom type " + actionType;
			}
		}
	}
}
