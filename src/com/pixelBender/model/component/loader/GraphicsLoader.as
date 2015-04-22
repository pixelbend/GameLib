package com.pixelBender.model.component.loader
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.model.vo.asset.AssetVO;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class GraphicsLoader extends AssetLoader
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The actual loader
		 */
		protected var loader																		:Loader;

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		/**
		 * See inherited documentation
		 * @param asset SWFAssetVO
		 * @param callback Function
		 */
		override public function load(asset:AssetVO, callback:Function):void
		{
			super.load(asset, callback);
			if (loader == null)
			{
				loader = new Loader();
			}
			addListeners(loader.contentLoaderInfo);
			loader.load(new URLRequest(asset.getFullURL()));
		}

		/**
		 * See inherited documentation
		 */
		override public function clear():void
		{
			super.clear();
			removeListeners(loader);
		}

		/**
		 * See inherited documentation
		 */
		override public function dispose():void
		{
			super.dispose();
			if (loader != null)
			{
				removeListeners(loader);
				if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_LOADING))
				{
					loader.close();
				}
				loader = null;
			}
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		/**
		 * Custom error handler.
		 * @param errorEvent Event
		 */
		override protected function handleErrorEvent(errorEvent:Event):void
		{
			removeListeners(loader);
			super.handleErrorEvent(errorEvent);
		}

		/**
		 * Custom complete handler.
		 * @param event Event
		 */
		override protected function handleCompleteEvent(event:Event):void
		{
			removeListeners(loader);
			super.handleCompleteEvent(event);
		}
	}
}
