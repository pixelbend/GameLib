package com.pixelBender.helpers
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.vo.note.tween.AddTweenNotificationVO;
	import com.pixelBender.pool.ObjectPool;

	public class TweenHelpers extends GameHelpers
	{
		//==============================================================================================================
		// STATIC API
		//==============================================================================================================

		public static function initialize():void
		{
			objectPoolMap[AddTweenNotificationVO.NAME] = objectPoolManager.retrievePool(AddTweenNotificationVO.NAME);
		}

		/**
		 * Starts a tween with the given parameters
		 * @param target Object
		 * @param duration int - in milliseconds
		 * @param properties Object - what properties will be tweened
		 * @param completeCallback Function - complete callback invoked when the tween has finished
		 * @param ease Function
		 * @param startDelay int
		 * @return int - tween identifier 
		 */		
		public static function tween(target:Object, duration:int, properties:Object, completeCallback:Function=null,
									 	ease:Function = null, startDelay:int = 0):int
		{
			var pool:ObjectPool = objectPoolMap[AddTweenNotificationVO.NAME],
				addTweenNoteVO:AddTweenNotificationVO = pool.allocate() as AddTweenNotificationVO;
			addTweenNoteVO.initialize(target, duration, properties, completeCallback, ease, startDelay);
			facade.sendNotification(GameConstants.ADD_TWEEN, addTweenNoteVO);
			pool.release(addTweenNoteVO);
			return addTweenNoteVO.getTweenID();
		}

		/**
		 * Pauses an active tween
		 * @param tweenID int - tween identifier
		 */
		public static function pauseTween(tweenID:int):void
		{
			facade.sendNotification(GameConstants.PAUSE_TWEEN, tweenID);
		}

		/**
		 * Resumes an active tween
		 * @param tweenID int - tween identifier
		 */
		public static function resumeTween(tweenID:int):void
		{
			facade.sendNotification(GameConstants.RESUME_TWEEN, tweenID);
		}
		
		/**
		 * Removes an active tween
		 * @param tweenID int - tween identifier 
		 */		
		public static function removeTween(tweenID:int):void
		{
			facade.sendNotification(GameConstants.REMOVE_TWEEN, tweenID);
		}

		/**
		 * Will stop all active tweens for the given target
		 * @param target Object - the tween target
		 */
		public static function removeTweenForTarget(target:Object):void
		{
			facade.sendNotification(GameConstants.REMOVE_TWEEN_FOR_TARGET, target);
		}
	}
}