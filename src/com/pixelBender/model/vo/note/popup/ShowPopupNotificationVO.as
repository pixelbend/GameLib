package com.pixelBender.model.vo.note.popup
{
	import com.pixelBender.model.AssetProxy;
	import com.pixelBender.view.popup.PopupMediator;

	public class ShowPopupNotificationVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The popup mediator instance that will be shown 
		 */		
		private var popup																	:PopupMediator;
		
		/**
		 * Reference to the asset proxy. Most likely needed for graphics/sounds etc. 
		 */		
		private var assetProxy																:AssetProxy;

		/**
		 * The VO needed for the popup to configure itself
		 */
		private var popupVO																	:Object;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function ShowPopupNotificationVO(popup:PopupMediator, assetProxy:AssetProxy, popupVO:Object)
		{
			this.popup = popup;
			this.assetProxy = assetProxy;
			this.popupVO = popupVO;
		}
		
		//==============================================================================================================
		// GETTERS
		//==============================================================================================================
		
		public function getPopup():PopupMediator
		{
			return popup;
		}
		
		public function getAssetProxy():AssetProxy
		{
			return assetProxy;
		}

		public function getPopupVO():Object
		{
			return popupVO;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[ShowPopupNotificationVO]";
		}
	}
}