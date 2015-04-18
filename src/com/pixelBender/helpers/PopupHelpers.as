package com.pixelBender.helpers
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.vo.popup.PopupTranslucentLayerVO;
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.view.popup.vo.OpenPopupVO;
	import com.pixelBender.view.popup.vo.PopupHelpersResponseVO;

	public class PopupHelpers extends GameHelpers
	{

		//==============================================================================================================
		// STATIC POPUP API
		//==============================================================================================================

		public static function initialize():void
		{
			objectPoolMap[PopupHelpersResponseVO.NAME] = objectPoolManager.retrievePool(PopupHelpersResponseVO.NAME);
			objectPoolMap[OpenPopupVO.NAME] = objectPoolManager.retrievePool(OpenPopupVO.NAME);
		}

		/**
		 * Opens the specified popup mediator
		 * @param popupName String - popup mediator name
		 * @param popupVO Object - popup init object
		 */
		public static function openPopup(popupName:String, popupVO:Object=null):void
		{
			var pool:ObjectPool = objectPoolMap[OpenPopupVO.NAME],
				noteVO:OpenPopupVO = OpenPopupVO(pool.allocate());
			noteVO.initialize(popupName, popupVO);
			facade.sendNotification(GameConstants.DO_OPEN_POPUP, noteVO);
			pool.release(noteVO);
		}
		
		/**
		 * Closes the specified popup mediator
		 * @param popupName String - popup mediator name
		 */
		public static function closePopup(popupName:String):void
		{
			facade.sendNotification(GameConstants.CLOSE_POPUP, popupName);
		}

		/**
		 * Retrieves whether the current popup show/hide configuration is stack or not.
		 * @return Boolean
		 */
		public static function getStackPopups():Boolean
		{
			var pool:ObjectPool = objectPoolMap[PopupHelpersResponseVO.NAME],
				noteVO:PopupHelpersResponseVO = pool.allocate() as PopupHelpersResponseVO;
			facade.sendNotification(GameConstants.GET_STACK_POPUPS, noteVO);
			pool.release(noteVO);
			return Boolean(noteVO.getResponse());
		}

		/**
		 * Set the current popup show/hide configuration.
		 * @param stackPopups Boolean
		 */
		public static function setStackPopups(stackPopups:Boolean):void
		{
			facade.sendNotification(GameConstants.SET_STACK_POPUPS, stackPopups);
		}

		/**
		 * Get the translucent layer properties.
		 * @return PopupTranslucentLayerVO
		 */
		public static function getTranslucentLayerProperties():PopupTranslucentLayerVO
		{
			var pool:ObjectPool = objectPoolMap[PopupHelpersResponseVO.NAME],
				noteVO:PopupHelpersResponseVO = objectPoolMap[PopupHelpersResponseVO.NAME].allocate() as PopupHelpersResponseVO;
			facade.sendNotification(GameConstants.GET_POPUP_TRANSLUCENT_LAYER_PROPERTIES, noteVO);
			pool.release(noteVO);
			return PopupTranslucentLayerVO(noteVO.getResponse());
		}

		/**
		 * Set the availability of the translucent layer.
		 * @param enabled Boolean
		 */
		public static function setTranslucentLayerEnabled(enabled:Boolean):void
		{
			facade.sendNotification(GameConstants.SET_POPUP_TRANSLUCENT_LAYER_ENABLED, enabled);
		}

		/**
		 * Sets the global popup translucent layer alpha
		 * @param alpha Number - between 0 and 1
		 */
		public static function setTranslucentLayerAlpha(alpha:Number):void
		{
			facade.sendNotification(GameConstants.SET_POPUP_TRANSLUCENT_LAYER_ALPHA, alpha);
		}

		/**
		 * Sets the global popup translucent layer alpha
		 * @param color int - between 0x000000 and 0xFFFFFF
		 */
		public static function setTranslucentLayerColor(color:int):void
		{
			facade.sendNotification(GameConstants.SET_POPUP_TRANSLUCENT_LAYER_COLOR, color);
		}
	}
}