package com.pixelBender.model.vo.action
{
	import com.pixelBender.interfaces.IAction;
	import com.pixelBender.interfaces.IDispose;

	public class RunningActionVO implements IDispose
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		public static const NAME										:String = "RunningActionVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The running action pointer
		 */
		private var action												:IAction;

		/**
		 * The complete callback that should be invoked upon completion
		 */
		private var actionCompleteCallback								:Function;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function RunningActionVO() {}

		//==============================================================================================================
		// API
		//==============================================================================================================

		/**
		 * Initializes the RunningAction VO
		 * @param action IAction - the running action pointer
		 * @param actionCompleteCallback Function - the complete callback that should be invoked upon completion
		 */
		public function initialize(action:IAction, actionCompleteCallback:Function):void
		{
			this.action = action;
			this.actionCompleteCallback = actionCompleteCallback;
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		/**
		 * Proper memory management
		 */
		public function dispose():void
		{
			this.action = null;
			this.actionCompleteCallback = null;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getAction():IAction
		{
			return action;
		}

		public function getActionCompleteCallback():Function
		{
			return actionCompleteCallback;
		}
	}
}
