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
		 */
		public final function preparePopupForOpen(container:DisplayObjectContainer, assetProxy:AssetProxy):void
		{
			prepareForOpen(container, assetProxy);
			state = GameConstants.STATE_PREPARING_FOR_OPEN;
		}

		/**
		 * Must be overridden by concrete NormalDisplayPopup implementations.
		 * @param container DisplayObjectContainer
		 * @param assetProxy AssetProxy
		 */
		public function prepareForOpen(container:DisplayObjectContainer, assetProxy:AssetProxy):void
		{
			AssertHelpers.assertCondition(false, "Implement this!");
		}
	}
}
