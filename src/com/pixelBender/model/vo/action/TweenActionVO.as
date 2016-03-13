package com.pixelBender.model.vo.action
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;

	public class TweenActionVO extends ActionVO
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		public static const	NAME										:String = "TweenActionVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

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

		public function initialize(ID:String, target:Object, duration:int, properties:Object, ease:Function = null,
								   	startDelay:int = 0):void
		{
			initializeBaseAction(GameConstants.ACTION_TYPE_TWEEN, ID);

			AssertHelpers.assertCondition(target != null, "Tween action target cannot be null!");
			this.target = target;

			AssertHelpers.assertCondition(duration > 0, "Tween action duration must be positive!");
			this.duration = duration;

			AssertHelpers.assertCondition(properties != null, "Tween action properties cannot be null!");
			this.properties = properties;

			this.ease = ease;

			AssertHelpers.assertCondition(startDelay >= 0, "Tween action start delay must be at least zero!");
			this.startDelay = startDelay;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getTarget():Object
		{
			return target;
		}

		public function getDuration():int
		{
			return duration;
		}

		public function getProperties():Object
		{
			return properties;
		}

		public function getEase():Function
		{
			return ease;
		}

		public function getStartDelay():int
		{
			return startDelay;
		}
	}
}
