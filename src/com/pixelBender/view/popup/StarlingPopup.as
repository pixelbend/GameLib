package com.pixelBender.view.popup
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.model.AssetProxy;
	import starling.display.DisplayObjectContainer;

	public class StarlingPopup extends PopupMediator
	{
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function StarlingPopup(mediatorName:String)
		{
			super(mediatorName);
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		/**
		 * Prepares the popup to be opened, given the starling display container
		 * @param container DisplayObjectContainer
		 * @param assetProxy AssetProxy
		 */
		public final function preparePopupForOpen(container:DisplayObjectContainer, assetProxy:AssetProxy):void
		{
			prepareForOpen(container, assetProxy);
			state = GameConstants.STATE_PREPARING_FOR_OPEN;
		}

		/**
		 * Must be overridden by concrete StarlingPopup implementations.
		 * @param container DisplayObjectContainer
		 * @param assetProxy AssetProxy
		 */
		public function prepareForOpen(container:DisplayObjectContainer, assetProxy:AssetProxy):void
		{
			AssertHelpers.assertCondition(false, "Implement this!");
		}
	}
}
