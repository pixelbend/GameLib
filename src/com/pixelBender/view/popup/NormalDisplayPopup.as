package com.pixelBender.view.popup
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.model.AssetProxy;
	import flash.display.DisplayObjectContainer;

	public class NormalDisplayPopup extends PopupMediator
	{
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function NormalDisplayPopup(mediatorName:String)
		{
			super(mediatorName);
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		/**
		 * Prepares the popup to be opened, given the normal display container
		 * @param container DisplayObjectContainer
		 * @param assetProxy AssetProxy
		 * @param popupInitVO Object
		 */
		public final function preparePopupForOpen(container:DisplayObjectContainer, assetProxy:AssetProxy, popupInitVO:Object=null):void
		{
			prepareForOpen(container, assetProxy, popupInitVO);
			state = GameConstants.STATE_PREPARING_FOR_OPEN;
		}

		/**
		 * Must be overridden by concrete NormalDisplayPopup implementations.
		 * @param container DisplayObjectContainer
		 * @param assetProxy AssetProxy
		 * @param popupInitVO Object
		 */
		public function prepareForOpen(container:DisplayObjectContainer, assetProxy:AssetProxy, popupInitVO:Object=null):void
		{
			AssertHelpers.assertCondition(false, "Implement this!");
		}
	}
}
