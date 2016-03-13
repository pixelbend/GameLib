package com.pixelBender.model.component.action
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.helpers.TweenHelpers;
	import com.pixelBender.model.vo.action.TweenActionVO;

	public class TweenAction extends BaseAction
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		public static const NAME												:String = "TweenAction";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Tween identifier
		 */
		protected var tweenID											:int;

		/**
		 * Tween action target. Can be anything with getters/setters
		 */
		protected var target											:Object;

		/**
		 * Tween action duration. In milliseconds
		 */
		protected var duration											:int;

		/**
		 * Tween action properties.
		 */
		protected var properties										:Object;

		/**
		 * Tween ease function. Default is linear
		 */
		protected var ease												:Function;

		/**
		 * Tween start delay. In milliseconds.
		 */
		protected var startDelay										:int;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initialize(playSoundActionVO:TweenActionVO):void
		{
			ID = playSoundActionVO.getID();
			target = playSoundActionVO.getTarget();
			duration = playSoundActionVO.getDuration();
			properties = playSoundActionVO.getProperties();
			ease = playSoundActionVO.getEase();
			startDelay = playSoundActionVO.getStartDelay();
			state = GameConstants.STATE_IDLE;
		}

		//==============================================================================================================
		// IAction IMPLEMENTATION
		//==============================================================================================================

		public override function getType():int
		{
			return GameConstants.ACTION_TYPE_TWEEN;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[TweenAction ID:" + ID + "state:" + state + "]";
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		/**
		 * Starts the tween action
		 */
		protected override function startAction():void
		{
			tweenID = TweenHelpers.tween(target, duration, properties, handleTweenComplete, ease, startDelay);
		}

		/**
		 * Pauses the current tween
		 */
		protected override function pauseAction():void
		{
			TweenHelpers.pauseTween(tweenID);
		}

		/**
		 * Resumes the current tween
		 */
		protected override function resumeAction():void
		{
			TweenHelpers.resumeTween(tweenID);
		}

		/**
		 * Stops the current tween
		 */
		protected override function stopAction():void
		{
			TweenHelpers.removeTween(tweenID);
		}

		/**
		 * Memory management
		 */
		protected override function disposeAction():void
		{
			target = null;
			properties = null;
			ease = null;
		}

		/**
		 * Tween complete callback
		 * @param tweenID int
		 */
		protected function handleTweenComplete(tweenID:int):void
		{
			// Check if we are in the normal end procedure
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED) && this.tweenID == tweenID)
			{
				state = GameConstants.STATE_IDLE;
				invokeCompleteCallback(false);
			}
		}
	}
}
